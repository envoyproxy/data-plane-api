.. _config_listener_filters_original_dst:

Original Destination
====================

Original destination listener filter reads the SO_ORIGINAL_DST socket option set when a connection
has been redirected by iptables REDIRECT. Later processing in Envoy sees the restored destination
address as the connection's local address, rather than the address at which the listener is
listening at. Furthermore, :ref:`an original destination cluster
<arch_overview_service_discovery_types_original_destination>` may be used to forward HTTP requests
or TCP connections to the restored destination address.

* :ref:`v2 API reference <envoy_api_field_listener.Filter.name>`
