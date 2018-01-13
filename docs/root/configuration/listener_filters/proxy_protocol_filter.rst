.. _config_listener_filters_proxy_protocol:

Proxy Protocol
==============

Proxy protocol filter processes the `PROXY protocol V1
<http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt>`_ header added by some load balancers
(e.g., AWL ELB) on new connections. With this the listener will assume that that remote address of
the connection is the one specified in the header. If this filter is not used, Envoy will use the
physical peer address of the connection as the remote address. Note that if the proxy protocol
header is present, further handling of the connection may fail if this filter is not used.

* :ref:`v2 API reference <envoy_api_field_ListenerFilter.name>`
