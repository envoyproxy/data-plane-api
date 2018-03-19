.. _start_simple:

Simple Example
==============

This is perhaps the most minimal Envoy configuration which can be used to validate basic plain HTTP
proxying. It is available in :repo:`configs/google_com_proxy.v2.yaml`. This is not
intended to represent a realistic Envoy deployment.

Quick Start
-----------

This quick start shows you how to build and execute an Envoy Docker image with the Dockerfile and
configuration in the Envoy repository. The Dockerfile will build a container containing the latest version of Envoy,
and copy a basic Envoy configuration into the container. This basic
configuration tells Envoy to route incoming requests to \*.google.com.

The :ref:`Configuration Walkthough <start_simple.Configuration_Walkthrough>`
explains this configuration file in detail.

Copy both :repo:`configs/Dockerfile` and
:repo:`configs/google_com_proxy.v2.yaml` to the same directory on your local
disk. Then, build and run the Dockerfile, and test out Envoy by sending a
request to port 10000::

  $ docker build -t envoy-google-test:v1 .
  Sending build context to Docker daemon  6.656kB
  Step 1/4 : FROM envoyproxy/envoy:latest
   ---> a644e13668b4
  Step 2/4 : RUN apt-get update
   ---> Using cache
   ---> f44649242d3c
  Step 3/4 : COPY envoy.yaml /etc/envoy.yaml
   ---> Using cache
   ---> 87092e3e257d
  Step 4/4 : CMD /usr/local/bin/envoy -c /etc/envoy.yaml
   ---> Using cache
   ---> d052ceb13974
  Successfully built d052ceb13974
  Successfully tagged envoy-google-test:v1
  $ docker run -d -p 10000:10000 -p 9901:9901 envoy-google-test:v1
  d011c286e96b2c247a0ebd9f589acc2838f6d2894670d6bc4f3b084d3f03523f
  $ curl -v localhost:10000
  (you get a lot of HTML here)

You can point your browser to the administrative server at: `<http://localhost:9901>` which shows
the possible commands.

You can also have a look at the Envoy statistics using the administrative server. In this case
we are looking for the number of 200 response codes from the Google service::

  $ curl http://localhost:9901/stats | grep rq_200
  cluster.service_google.external.upstream_rq_200: 1
  cluster.service_google.upstream_rq_200: 1

You can look at the Envoy log file as well::

  $ docker ps
  CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                              NAMES
  68fc8e67f0dc        envoy-google-test:v1   "/bin/sh -c '/usr/lo…"   13 minutes ago      Up 13 minutes       0.0.0.0:9901->9901/tcp, 0.0.0.0:10000->10000/tcp   pensive_hoover
  $ docker exec 6 more /tmp/admin_access.log
  ::::::::::::::
  /tmp/admin_access.log
  ::::::::::::::
  [2018-03-17T19:04:57.540Z] "GET / HTTP/1.1" 200 - 0 4164 1 - "172.17.0.1" "curl/7.54.0" "-" "localhost:9901" "-"
  [2018-03-17T19:05:14.648Z] "GET /stats HTTP/1.1" 200 - 0 9926 1 - "172.17.0.1" "curl/7.54.0" "-" "localhost:9901" "-"
  [2018-03-17T19:07:05.811Z] "GET / HTTP/1.1" 200 - 0 4164 0 - "172.17.0.1" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:58.0) Gecko/20100101 Firefox/58.0" "-" "localhost:9901" "-"
  (and more...)

.. _start_simple.Configuration_Walkthrough:

Configuration Walkthrough
-------------------------

Envoy can be configured both statically and dynamically.
In the static configuration model, a YAML configuration file is used, which is passed
as an argument on the command line.
Envoy also has an extensive set of APIs that can be used for dynamic configuration
(which are not covered in this example).

Below is the :repo:`configs/google_com_proxy.v2.yaml` file.

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 127.0.0.1, port_value: 9901 }
  static_resources:
    listeners:
    - name: listener_0
      address:
        socket_address: { address: 0.0.0.0, port_value: 10000 }
      filter_chains:
      - filters:
        - name: envoy.http_connection_manager
          config:
            stat_prefix: ingress_http
            route_config:
              name: local_route
              virtual_hosts:
              - name: local_service
                domains: ["*"]
                routes:
                - match: { prefix: "/" }
                  route: { host_rewrite: www.google.com, cluster: service_google }
            http_filters:
            - name: envoy.router
    clusters:
    - name: service_google
      connect_timeout: 0.25s
      type: LOGICAL_DNS
      lb_policy: ROUND_ROBIN
      hosts: [{ socket_address: { address: google.com, port_value: 443 }}]
      tls_context: { sni: www.google.com }


Let's go through each section in detail.

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 127.0.0.1, port_value: 9901 }

..

  The :ref:`admin message <envoy_api_msg_config.bootstrap.v2.Admin>` is required to configure
  the administration server.

  The ``address`` field specifies the
  listening :ref:`address <envoy_api_file_envoy/api/v2/core/address.proto>`
  which in this case is simply `127.0.0.1:9901`.

.. code-block:: yaml

    static_resources:

..

  The :ref:`static_resources <envoy_api_field_config.bootstrap.v2.Bootstrap.static_resources>` contains
  everything that is configured statically when Envoy starts (which is this entire example). In addition
  any of this configuration can be expressed dynamically using the
  :ref:`API <config_overview_v2>` when Envoy is running; this is not covered here.

.. code-block:: yaml

      listeners:
      - name: listener_0
        address:
          socket_address: { address: 0.0.0.0, port_value: 10000 }
        filter_chains:

..

  The ``listeners`` field specifies a list of :ref:`listeners <arch_overview_listeners>` which service
  inbound connections and specifies the processing on the connections once they are established. See
  :ref:`listener configuration <envoy_api_file_envoy/api/v2/lds.proto>` for details.

  The ``name`` field uniquely identifies the listener.

  The ``address`` field specifies specifies the
  listening :ref:`address <envoy_api_file_envoy/api/v2/core/address.proto>`
  which in this case is `0.0.0.0:10000`, which is a wildcard address that causes
  Enjoy to bind to all local addresses on port 10000.

  The ``filter_chains`` field is required and specifies the list of filter chains to
  consider for this listener. A single filter chain is selected to process the connection
  based on the :ref:`FilterChainMatch <envoy_api_msg_listener.FilterChainMatch>` criteria.
  If there is no :ref:`FilterChainMatch <envoy_api_msg_listener.FilterChainMatch>` criteria (which is
  the case for this example),
  the filter chain is always selected. Within the :ref:`FilterChain <envoy_api_msg_listener.FilterChain>`
  the filters (see below) are used to process messages on the connection.

.. code-block:: yaml

        - filters:
          - name: envoy.http_connection_manager
            config:

..

  Each filter chain consists of a list of :ref:`network (L3/L4) filters <arch_overview_network_filters>`
  (which includes the
  :ref:`HTTP Connection Manager <arch_overview_http_conn_man>` filter) that are used to process the messages
  on the connection. HTTP-specific (L7) filtering is provided using the ``http_filters`` field in the HTTP Connection
  Manager (see below); this filtering is not specified here in the filter chain.

  The ``name`` specifies a supported filter.
  Envoy has several built in filters that start with `envoy`. The specified filter is the
  :ref:`HTTP Connection Manager <config_http_conn_man>` which does all manner of things to manage HTTP
  connections.

  The ``config`` contains the filter-specific configuration.

.. code-block:: yaml

              stat_prefix: ingress_http
              route_config:
                name: local_route
                virtual_hosts:
                - name: local_service
                  domains: ["*"]
                  routes:
                  - match: { prefix: "/" }
                    route: { host_rewrite: www.google.com, cluster: service_google }
              http_filters:
              - name: envoy.router

..

  This is the configuration for the :ref:`HTTP Connection Manager <config_http_conn_man>`.

  The ``stat_prefix`` field is a human readable prefix used to identify this connection manager in
  the :ref:`statistics <config_http_conn_man_stats>`.

  The ``route_config`` field specifies a static :ref:`Route configuration <envoy_api_file_envoy/api/v2/rds.proto>`.
  In addition to containing the list of virtual hosts (below), you can specify processing for request/response
  headers.

  The ``name`` (local_route) field names the route configuration. This is optional.

  The ``virtual_hosts`` field contains a list of :ref:`Virtual Hosts <envoy_api_msg_route.VirtualHost>`.
  A virtual host is selected based on the routing criteria below and used to specify routing of the message.

  The ``name`` (local_service) field names the virtual host for statistics reporting.

  The ``domains`` field contains a list of domains (host/authority header) that will be matched to this virtual
  host. In this case, because of the specified "*", all domains will be routed to this virtual host.

  The ``routes`` field contains a list of :ref:`Routes <envoy_api_msg_route.Route>` that are matched,
  in order, for incoming requests. The first route that matches is used.

  The ``match`` field provides the :ref:`RouteMatch parameters <envoy_api_msg_route.RouteMatch>` used to select the route.
  In this case, by specifying "/", all paths will match. The ``match`` field can match on a path prefix
  (specified), an exact path,
  or a regular expression against the path.

  The ``route`` field provides the :ref:`RouteAction parameters <envoy_api_msg_route.RouteAction>` invoked
  when the route is selected. Once the request matches the above ``domains`` and ``routes`` section (which are effectively
  wildcards), the rewrite will be applied and the request is forwarded to the cluster (service_google).

  The ``http_filters`` field contains a list of
  :ref:`HTTP filters <arch_overview_http_filters>` to process each message. See
  :ref:`HttpFilter <envoy_api_msg_config.filter.network.http_connection_manager.v2.HttpFilter>` for more details.
  In this case,
  the built-in :ref:`envoy.router <config_http_filters_router>` filter is specified which
  implements HTTP forwarding by following the instructions specified above in the route table.


.. code-block:: yaml

      clusters:
      - name: service_google
        connect_timeout: 0.25s
        type: LOGICAL_DNS
        lb_policy: ROUND_ROBIN
        hosts: [{ socket_address: { address: google.com, port_value: 443 }}]
        tls_context: { sni: www.google.com }

..

  The ``clusters`` field specifies a list of :ref:`clusters <arch_overview_cluster_manager>`. See
  :ref:`cluster configuration <envoy_api_file_envoy/api/v2/cds.proto>` for details.

  The ``name`` field is required and must be unique across all clusters. It is used when emitting statistics.

  The ``connect_timeout`` field specifies a timeout value for new network connections to hosts in the cluster.

  The ``type`` field specifies the :ref:`service discovery type <arch_overview_service_discovery_types>`
  to use for resolving the cluster. :ref:`LOGICAL_DNS<arch_overview_service_discovery_types_logical_dns>`
  (the default) is generally the best choice for a static configuration based on DNS, read the description to find
  out why.

  The ``hosts`` field specifies the :ref:`host address <envoy_api_msg_core.Address>`.
  If the service discovery type is
  :ref:`STATIC<envoy_api_enum_value_Cluster.DiscoveryType.STATIC>`,
  :ref:`STRICT_DNS<envoy_api_enum_value_Cluster.DiscoveryType.STRICT_DNS>`
  or :ref:`LOGICAL_DNS<envoy_api_enum_value_Cluster.DiscoveryType.LOGICAL_DNS>`,
  then ``hosts`` is required. In this case, all requests will be routed to google.com:443.

  The ``tls_context`` field specifies the :ref:`TLS configuration <envoy_api_msg_auth.UpstreamTlsContext>`.
  for connections to the upstream cluster. If no TLS
  configuration is specified, TLS will not be used for new connections. In this case the
  `SNI <https://en.wikipedia.org/wiki/Server_Name_Indication>`_ is set to www.google.com.


