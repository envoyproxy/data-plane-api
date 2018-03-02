.. _config_http_filters_ip_tagging:

IP Tagging
==========

The HTTP IP Tagging filter sets the header *x-envoy-ip-tags* with the string tags for the trusted address from
:ref:`x-forwarded-for <config_http_conn_man_headers_x-forwarded-for>`. If there are no tags for an address,
the header is not set.

The implementation for IP Tagging provides a scalable way to compare an IP address to a large list of CIDR
ranges efficiently. The underlying algorithm for storing tags and IP address subnets is a Level-Compressed trie
described in the paper `IP-address lookup using
LC-tries <https://www.nada.kth.se/~snilsson/publications/IP-address-lookup-using-LC-tries/>`_ by S. Nilsson and
G. Karlsson.


Configuration
-------------
* :ref:`v2 API reference <envoy_api_msg_config.filter.http.ip_tagging.v2.IPTagging>`

Statistics
----------

The IP Tagging filter outputs statistics in the *http.<stat_prefix>.ip_tagging.* namespace. The stat prefix comes from
the owning HTTP connection manager.

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

        <tag_name>.hit, Counter, Total number of requests that have the <tag_name> applied to it.
        no_hit, Counter, Total number of requests with no applicable IP tags.
        total, Counter, Total number of requests the IP Tagging Filter operated on.

Runtime
-------

The IP Tagging filter supports the following runtime settings:

ip_tagging.http_filter_enabled
    The % of requests for which the filter is enabled. Default is 100.
