.. _start_simple:

Simple Example
==============

This is perhaps the most minimal Envoy configuration which can be used to validate basic plain HTTP
proxying is available in :repo:`configs/google_com_proxy.v2.yaml`. This is not
intended to represent a realistic Envoy deployment.

Quick Start
-----------

This Quick Start runs the example quickly using files in the Envoy repo. The sections below explain
the configuation file and execution steps in detail.

Copy both :repo:`configs/Dockerfile` and
:repo:`configs/google_com_proxy.v2.yaml` to the same directory on your local
disk. Then, build and run the Dockerfile, and test out Envoy by sending a
request to port 10000::

  $ docker build -t envoy-google-test:v1 .
  $ docker run -d -p 10000:10000 envoy-google-test:v1
  $ curl -v localhost:10000

The Dockerfile will build a container containing the latest version of Envoy,
and copy a basic Envoy configuration into the container. This basic
configuration tells Envoy to route incoming requests to \*.google.com.


Simple Configuration
--------------------

Envoy can be configured using a single YAML file passed in as an argument on the command line.

Below is the `google_com_proxy.v2.yaml` file.

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 0.0.0.0, port_value: 9901 }
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
        # Comment out the following line to test on v6 networks
        dns_lookup_family: V4_ONLY
        lb_policy: ROUND_ROBIN
        hosts: [{ socket_address: { address: google.com, port_value: 443 }}]
        tls_context: { sni: www.google.com }


Let's go through each section in detail.

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 0.0.0.0, port_value: 9901 }

..

  The :ref:`admin message <envoy_api_msg_config.bootstrap.v2.Admin>` is required to configure
  the administration server.

  The ``address`` key specifies the
  listening :ref:`address <envoy_api_file_envoy/api/v2/core/address.proto>`
  which in this case is simply `0.0.0.0:9901`.

.. code-block:: yaml

    static_resources:

..

  The :ref:`static_resources <envoy_api_field_config.bootstrap.v2.Bootstrap.static_resources>` contains
  everything that is configured statically when Envoy starts,
  as opposed to the means of configuring resources dynamically when Envoy is running.
  The :ref:`v2 API Overview <config_overview_v2>` describes this.

.. code-block:: yaml

      listeners:
      - name: listener_0
        address:
          socket_address: { address: 0.0.0.0, port_value: 10000 }
        filter_chains:

..

  The specification of the :ref:`listeners <envoy_api_file_envoy/api/v2/lds.proto>`. One or more
  listeners can be specified as members of ``listeners``.

  The ``name`` key uniquely identifies the listener.

  The ``address`` key specifies specifies the
  listening :ref:`address <envoy_api_file_envoy/api/v2/core/address.proto>`
  which in this case is simply `0.0.0.0:10000`.

  The ``filter_chains`` key is required and specifies the list of filter chains to
  consider for this listener. The
  :ref:`FilterChain <envoy_api_msg_listener.FilterChain>` with the most specific
  :ref:`FilterChainMatch <envoy_api_msg_listener.FilterChainMatch>` criteria is used on a
  connection.

.. code-block:: yaml

        - filters:
          - name: envoy.http_connection_manager
            config:

..

  The filter chain consists of a list of ``filters``.

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

  The ``stat_prefix`` key is a human readable prefix used to identify this connection manager in
  the :ref:`statistics <config_http_conn_man_stats>`.

  The ``route_config`` key specifies a static :ref:`Route configuration <envoy_api_file_envoy/api/v2/rds.proto>`.

  The ``name`` key names the route configuration. This is optional.

  The ``virtual_hosts`` key contains a list of :ref:`Virtual Hosts <envoy_api_msg_route.VirtualHost>`.

  The ``name`` key names the virtual host for statistics reporting.

  The ``domains`` key contains a list of domains (host/authority header) that will be matched to this virtual
  host.

  The ``routes`` key contains a list of :ref:`Routes <envoy_api_msg_route.Route>` that are matched, in order, for incoming requests. The first
  route that matches is used.

  The ``match`` key provides the :ref:`RouteMatch parameters <envoy_api_msg_route.RouteMatch>` used to select the route.

  The ``route`` key provides the :ref:`RouteAction parameters <envoy_api_msg_route.RouteAction>` invoked when the route is selected.

  The ``http_filters`` key contains a list of
  :ref:`HttpFilter <envoy_api_msg_config.filter.network.http_connection_manager.v2.HttpFilter>` for the connection manager.
  In this case
  the built-in :ref:`envoy.router <config_http_filters_router>` filter is specified which
  implements HTTP forwarding by following the instructions specified above in the route table.


.. code-block:: yaml

      clusters:
      - name: service_google
        connect_timeout: 0.25s
        type: LOGICAL_DNS
        # Comment out the following line to test on v6 networks
        dns_lookup_family: V4_ONLY
        lb_policy: ROUND_ROBIN
        hosts: [{ socket_address: { address: google.com, port_value: 443 }}]
        tls_context: { sni: www.google.com }

..

  The ``clusters`` key specifies a list of :ref:`clusters <arch_overview_cluster_manager>`. You can refer to the
  :ref:`cluster configuration <envoy_api_file_envoy/api/v2/cds.proto>` details.

  The ``name`` key is required and must be unique across all clusters. It is used when emitting statistics.

  The ``connect_timeout`` key specifies a timeout value for new network connections to hosts in the cluster.

  The ``type`` key specifies the :ref:`service discovery type <arch_overview_service_discovery_types>`
  to use for resolving the cluster.

  The ``dns_lookup_family`` key specifies the :ref:`DnsLookupFamily <envoy_api_enum_Cluster.DnsLookupFamily>`
  which is the DNS IP address resolution
  policy.

  The ``lb_policy`` key specifies the :ref:`load balancer type <arch_overview_load_balancing_types>`
  to use when picking a host in the cluster.

  The ``hosts`` key specifies the :ref:`host address <envoy_api_msg_core.Address>`.
  If the service discovery type is
  :ref:`STATIC<envoy_api_enum_value_Cluster.DiscoveryType.STATIC>`,
  :ref:`STRICT_DNS<envoy_api_enum_value_Cluster.DiscoveryType.STRICT_DNS>`
  or :ref:`LOGICAL_DNS<envoy_api_enum_value_Cluster.DiscoveryType.LOGICAL_DNS>`,
  then ``hosts`` is required.

  The ``tls_context`` key specifies the :ref:`TLS configuration <envoy_api_msg_auth.UpstreamTlsContext>`.
  for connections to the upstream cluster. If no TLS
  configuration is specified, TLS will not be used for new connections.


Using the Envoy Docker Image
----------------------------

Create a simple Dockerfile to execute Envoy, which assumes that envoy.yaml (described above) is in your local directory.
You can refer to the :ref:`Command line options <operations_cli>`.

.. code-block:: none

  FROM envoyproxy/envoy:latest
  RUN apt-get update
  COPY envoy.yaml /etc/envoy.yaml
  CMD /usr/local/bin/envoy -c /etc/envoy.yaml

Build the Docker image that runs your configuration using::

  $ docker build -t envoy:v1

And now you can execute it with::

  $ docker run -d --name envoy -p 9901:9901 -p 10000:10000 envoy:v1

And finally test is using::

  $ curl -v localhost:10000


