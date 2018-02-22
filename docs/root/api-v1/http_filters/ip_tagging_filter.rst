.. _config_http_filters_ip_tagging_v1:

HTTP IP Tagging Filter
======================

HTTP IP Tagging :ref:`configuration overview <config_http_filters_ip_tagging>`.

.. code-block:: json

  {
    "name": "ip_tagging",
    "config": {
      "request_type": "...",
      "ip_tags": []
    }
  }

request_type
  *(optional, string)* The type of requests the filter should apply to. The supported
  types are *INTERNAL*, *EXTERNAL* or *BOTH*. The
  :ref:`x-forwarded-for<config_http_conn_man_headers_x-forwarded-for_internal_origin>` header is
  used to determine if a request is internal and will result in
  :ref:`x-envoy-internal<config_http_conn_man_headers_x-envoy-internal>`
  being set. The filter defaults to both, and it will apply to all request types.

ip_tags
  *(required, array)* A list of tags and the associated IP addresses subnets.

IP Tags
-------

.. code-block:: json

  {
    "ip_tag_name": {},
    "ip_list": []
  }

ip_tag_name
  *(required, string)* Specifies the IP tag name to apply to a request.

ip_list
  *(required, array)* A list of IP address subnets in the form "ip_address/xx".

  .. code-block:: json

    [
      "10.15.0.0/16",
      "2001:db8::/32"
    ]


