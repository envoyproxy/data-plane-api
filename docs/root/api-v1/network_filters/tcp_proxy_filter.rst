.. _config_network_filters_tcp_proxy_v1:

TCP proxy
=========

TCP proxy :ref:`configuration overview <config_network_filters_tcp_proxy>`.

.. code-block:: json

  {
    "name": "tcp_proxy",
    "config": {
      "stat_prefix": "...",
      "route_config": "{...}",
      "access_log": []
    }
  }

:ref:`route_config <config_network_filters_tcp_proxy_route_config>`
  *(required, object)* The route table for the filter.
  All filter instances must have a route table, even if it is empty.

stat_prefix
  *(required, string)* The prefix to use when emitting :ref:`statistics
  <config_network_filters_tcp_proxy_stats>`.

:ref:`access_log <config_access_log>`
  *(optional, array)* Configuration for :ref:`access logs <arch_overview_access_logs>`
  emitted by the this tcp_proxy.

.. _config_network_filters_tcp_proxy_route_config:

Route Configuration
-------------------

.. code-block:: json

  {
    "routes": []
  }

:ref:`routes <config_network_filters_tcp_proxy_route>`
  *(required, array)* An array of route entries that make up the route table.

.. _config_network_filters_tcp_proxy_route:

Route
-----

A TCP proxy route consists of a set of optional L4 criteria and the name of a
:ref:`cluster <config_cluster_manager_cluster>`. If a downstream connection matches
all the specified criteria, the cluster in the route is used for the corresponding upstream
connection. Routes are tried in the order specified until a match is found. If no match is
found, the connection is closed. A route with no criteria is valid and always produces a match.

.. code-block:: json

  {
    "cluster": "...",
    "destination_ip_list": [],
    "destination_ports": "...",
    "source_ip_list": [],
    "source_ports": "..."
  }

cluster
  *(required, string)* The :ref:`cluster <config_cluster_manager_cluster>` to connect
  to when a the downstream network connection matches the specified criteria.

destination_ip_list
  *(optional, array)*  An optional list of IP address subnets in the form "ip_address/xx".
  The criteria is satisfied if the destination IP address of the downstream connection is
  contained in at least one of the specified subnets.
  If the parameter is not specified or the list is empty, the destination IP address is ignored.
  The destination IP address of the downstream connection might be different from the addresses
  on which the proxy is listening if the connection has been redirected. Example:

 .. code-block:: json

    [
      "192.168.3.0/24",
      "50.1.2.3/32",
      "10.15.0.0/16",
      "2001:abcd::/64"
    ]

destination_ports
  *(optional, string)* An optional string containing a comma-separated list of port numbers or
  ranges. The criteria is satisfied if the destination port of the downstream connection
  is contained in at least one of the specified ranges.
  If the parameter is not specified, the destination port is ignored. The destination port address
  of the downstream connection might be different from the port on which the proxy is listening if
  the connection has been redirected. Example:

 .. code-block:: json

  {
    "destination_ports": "1-1024,2048-4096,12345"
  }

source_ip_list
  *(optional, array)*  An optional list of IP address subnets in the form "ip_address/xx".
  The criteria is satisfied if the source IP address of the downstream connection is contained
  in at least one of the specified subnets. If the parameter is not specified or the list is empty,
  the source IP address is ignored. Example:

 .. code-block:: json

    [
      "192.168.3.0/24",
      "50.1.2.3/32",
      "10.15.0.0/16",
      "2001:abcd::/64"
    ]

source_ports
  *(optional, string)* An optional string containing a comma-separated list of port numbers or
  ranges. The criteria is satisfied if the source port of the downstream connection is contained
  in at least one of the specified ranges. If the parameter is not specified, the source port is
  ignored. Example:

 .. code-block:: json

  {
    "source_ports": "1-1024,2048-4096,12345"
  }
