.. _config_overview_v2:

Overview (v2 API)
=================

The Envoy v2 APIs are defined as `proto3
<https://developers.google.com/protocol-buffers/docs/proto3>`_ `Protocol Buffers
<https://developers.google.com/protocol-buffers/>`_ in the `data plane API
repository <https://github.com/envoyproxy/data-plane-api/tree/master/api>`_. They evolve the
existing :ref:`v1 xDS APIs and concepts <config_overview_v1>` to support:

* Streaming delivery of xDS API updates via gRPC. This reduces resource requirements and can
  lower the update latency.
* A new REST-JSON API in which the JSON/YAML formats are derived mechanically via the `proto3
  canonical JSON mapping
  <https://developers.google.com/protocol-buffers/docs/proto3#json>`_.
* Delivery of updates via the filesystem, REST-JSON or gRPC endpoints.
* Advanced load balancing through an extended endpoint assignment API and load
  and resource utilization reporting to management servers.
* `Stronger consistency and ordering properties
  <https://github.com/envoyproxy/data-plane-api/blob/master/XDS_PROTOCOL.md#eventual-consistency-considerations>`_
  when needed. The v2 APIs still maintain a baseline eventual consistency model.

See the `xDS protocol description <https://github.com/envoyproxy/data-plane-api/blob/master/XDS_PROTOCOL.md>`_ for 
further details on aspects of v2 message exchange between Envoy and the management server.

Bootstrap configuration
-----------------------

To use the v2 API, it's necessary to supply a bootstrap configuration file. This
provides static server configuration and configures Envoy to access :ref:`dynamic
configuration if needed <arch_overview_dynamic_config>`. As with the v1
JSON/YAML configuration, this is supplied on the command-line via the ``-c``
flag, i.e.:

.. code-block:: console

  ./envoy -c <path to config>.{json,yaml,pb,pb_text}

where the extension reflects the underlying v2 config representation.

The :ref:`bootstrap configuration proto <envoy_api_file_api/bootstrap.proto>` describes
the static config file format.

The :ref:`Bootstrap <envoy_api_msg_Bootstrap>` message is the root of the
configuration. A key concept in the :ref:`Bootstrap <envoy_api_msg_Bootstrap>`
message is the distinction between static and dynamic resouces.  Resources such
as a :ref:`Listener <config_listeners>` or :ref:`Cluster
<config_cluster_manager_cluster>` may be supplied either statically in
``static_resources`` or have an xDS service such as :ref:`LDS
<config_overview_lds>` or :ref:`CDS <config_cluster_manager_cds>` configured in
``dynamic_resources``.

Example
-------

Below we will use YAML representation of the config protos and a running example
of a service proxying HTTP from 127.0.0.1:10000 to 127.0.0.2:1234.

Static
^^^^^^

A minimal fully static bootstrap config is provided below:

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 127.0.0.1, port_value: 9901 }

  static_resources:
    listeners:
    - name: listener_0
      address:
        socket_address: { address: 127.0.0.1, port_value: 10000 }
      filter_chains:
      - filters:
        - name: envoy.http_connection_manager
          config:
            stat_prefix: ingress_http
            codec_type: AUTO
            route_config:
              name: local_route
              virtual_hosts:
              - name: local_service
                domains: ["*"]
                routes:
                - match: { prefix: "/" }
                  route: { cluster: some_service }
            http_filters:
            - name: envoy.router
    clusters:
    - name: some_service
      connect_timeout: 0.25s
      type: STATIC
      lb_policy: ROUND_ROBIN
      hosts: [{ socket_address: { address: 127.0.0.2, port_value: 1234 }}]

Mostly static with dynamic EDS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A bootstrap config that continues from the above example with :ref:`dynamic endpoint
discovery <arch_overview_dynamic_config_sds>` via an EDS gRPC management server listening
on 127.0.0.3:5678 is provided below:

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 127.0.0.1, port_value: 9901 }

  static_resources:
    listeners:
    - name: listener_0
      address:
        socket_address: { address: 127.0.0.1, port_value: 10000 }
      filter_chains:
      - filters:
        - name: envoy.http_connection_manager
          config:
            stat_prefix: ingress_http
            codec_type: AUTO
            route_config:
              name: local_route
              virtual_hosts:
              - name: local_service
                domains: ["*"]
                routes:
                - match: { prefix: "/" }
                  route: { cluster: some_service }
            http_filters:
            - name: envoy.router
    clusters:
    - name: some_service
      connect_timeout: 0.25s
      lb_policy: ROUND_ROBIN
      type: EDS
      eds_cluster_config:
        eds_config:
          api_config_source:
            api_type: GRPC
            cluster_name: [xds_cluster]
    - name: xds_cluster
      connect_timeout: 0.25s
      type: STATIC
      lb_policy: ROUND_ROBIN
      hosts: [{ socket_address: { address: 127.0.0.3, port_value: 5678 }}]

Notice above that ``xds_cluster`` is defined to point Envoy at the management server. Even in
an otherwise completely dynamic configurations, some static resources need to be defined to point Envoy at
its xDS management server(s).

In the above example, the EDS management server could then return a proto encoding of a
:ref:`DiscoveryResponse <envoy_api_msg_DiscoveryResponse>`:

.. code-block:: yaml

  version_info: "0"
  resources:
  - "@type": type.googleapis.com/envoy.api.v2.ClusterLoadAssignment
    cluster_name: some_service
    endpoints:
    - lb_endpoints:
      - endpoint:
          address:
            socket_address:
              address: 127.0.0.2
              port_value: 1234


The versioning and type URL scheme that appear above are explained in more
detail in the `streaming gRPC subscription protocol
<https://github.com/envoyproxy/data-plane-api/blob/master/XDS_PROTOCOL.md#streaming-grpc-subscriptions>`_
documentation.

Dynamic
^^^^^^^

A fully dynamic bootstrap configuration, in which all resources other than
those belonging to the management server are discovered via xDS is provided
below:

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 127.0.0.1, port_value: 9901 }
  
  dynamic_resources:
    lds_config:
      api_config_source:
        api_type: GRPC
        cluster_name: [xds_cluster]
    cds_config:
      api_config_source:
        api_type: GRPC
        cluster_name: [xds_cluster]

  static_resources:
    clusters:
    - name: xds_cluster
      connect_timeout: 0.25s
      type: STATIC
      lb_policy: ROUND_ROBIN
      hosts: [{ socket_address: { address: 127.0.0.3, port_value: 5678 }}]

The management server could respond to LDS requests with:

.. code-block:: yaml

  version_info: "0"
  resources:
  - "@type": type.googleapis.com/envoy.api.v2.Listener
    name: listener_0
    address:
      socket_address:
        address: 127.0.0.1
        port_value: 10000
    filter_chains:
    - filters:
      - name: envoy.http_connection_manager
        config:
          stat_prefix: ingress_http
          codec_type: AUTO
          rds:
            route_config_name: local_route
            config_source:
              api_config_source:
                api_type: GRPC
                cluster_name: [xds_cluster]
          http_filters:
          - name: envoy.router

The management server could respond to RDS requests with:

.. code-block:: yaml

  version_info: "0"
  resources:
  - "@type": type.googleapis.com/envoy.api.v2.RouteConfiguration
    name: local_route
    virtual_hosts:
    - name: local_service
      domains: ["*"]
      routes:
      - match: { prefix: "/" }
        route: { cluster: some_service }

The management server could respond to CDS requests with:

.. code-block:: yaml

  version_info: "0"
  resources:
  - "@type": type.googleapis.com/envoy.api.v2.Cluster
    name: some_service
    connect_timeout: 0.25s
    lb_policy: ROUND_ROBIN
    type: EDS
    eds_cluster_config:
      eds_config:
        api_config_source:
          api_type: GRPC
          cluster_name: [xds_cluster]

The management server could respond to EDS requests with:

.. code-block:: yaml

  version_info: "0"
  resources:
  - "@type": type.googleapis.com/envoy.api.v2.ClusterLoadAssignment
    cluster_name: some_service
    endpoints:
    - lb_endpoints:
      - endpoint:
          address:
            socket_address:
              address: 127.0.0.2
              port_value: 1234

Management server endpoints
---------------------------

A v2 xDS management server will implement the below endpoints. In both streaming gRPC and
REST-JSON cases, a :ref:`DiscoveryRequest <envoy_api_msg_DiscoveryRequest>` is sent and a
:ref:`DiscoveryResponse <envoy_api_msg_DiscoveryResponse>` received.

.. http:post:: /envoy.api.v2.ClusterDiscoveryService/StreamClusters

v2 CDS gRPC bidirectional stream.

.. http:post:: /v2/discovery:clusters

v2 CDS REST-JSON request-response.

.. http:post:: /envoy.api.v2.EndpointDiscoveryService/StreamEndpoints

v2 EDS gRPC bidirectional stream.

.. http:post:: /v2/discovery:endpoints

v2 EDS REST-JSON request-response.

.. http:post:: /envoy.api.v2.ListenerDiscoveryService/StreamListeners

v2 LDS gRPC bidirectional stream.

.. http:post:: /v2/discovery:listeners

v2 LDS REST-JSON request-response.

.. http:post:: /envoy.api.v2.RouteDiscoveryService/StreamRoutes

v2 RDS gRPC bidirectional stream.

.. http:post:: /v2/discovery:routes

v2 RDS REST-JSON request-response.

Status
------

The current API status is tracked `here
<https://github.com/envoyproxy/data-plane-api#status>`_. All features described
in the :ref:`v2 API reference <envoy_api_reference>` are implemented unless
otherwise noted.
