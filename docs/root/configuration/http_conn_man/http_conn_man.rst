.. _config_http_conn_man:

HTTP connection manager
=======================

* HTTP connection manager :ref:`architecture overview <arch_overview_http_conn_man>`
* HTTP protocols :ref:`architecture overview <arch_overview_http_protocols>`
* :ref:`v1 API reference <config_network_filters_http_conn_man_v1>`
* :ref:`v2 API reference <envoy_api_msg_config.filter.network.http_connection_manager.v2.HttpConnectionManager>`

Runtime
-------

The HTTP connection manager supports the following runtime settings:

http_connection_manager.remote_address_ipv4_mapped_ipv6
  % of requests with a remote address that will have their IPv4 address mapped to IPv6. Defaults to
  0.
  :ref:`use_remote_address <envoy_api_field_config.filter.network.http_connection_manager.v2.HttpConnectionManager.use_remote_address>`
  must also be enabled. See
  :ref:`remote_address_ipv4_mapped_ipv6 <envoy_api_field_config.filter.network.http_connection_manager.v2.HttpConnectionManager.remote_address_ipv4_mapped_ipv6>`
  for more details.

.. toctree::
  :hidden:

  route_matching
  traffic_splitting
  headers
  header_sanitizing
  stats
  runtime
  rds
