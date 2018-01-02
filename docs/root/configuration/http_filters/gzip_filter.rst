.. _config_http_filters_gzip:

Gzip
====
Gzip is an HTTP filter which enables Envoy to compress dispatched data from an upstream
service upon client request. This is useful in situations where large payloads need to
be transmitted without compromising the response time.

Configuration
-------------
* :ref:`v1 API reference <config_http_filters_gzip_v1>`
* :ref:`v2 API reference <envoy_api_field_filter.network.HttpFilter.name>`

.. attention::

  Due to a known bug in the underlying zlib library, window bits with value 8 does not work as expected,
  therefore 9 is the smallest window size supported by gzip filter at the moment. This issue might be
  solved in future releases of the library.

How it works
------------
When gzip filter is enable, request headers are inspected and potentially processed before
being sent to an upstream service. As soon as upstream responds, the response headers are also
analyzed. If either response and request allows, content is compressed and then sent to
the client with the appropriate headers.

By *default* compression will be *skipped* when:

- Request does NOT contain Accept-Encoding header.
- Request contains Accept-Encoding header, however "gzip" is NOT one of the values.
- Response contains a Content-Encoding header.
- Response contains a Cache-Control header whose value is no-transform.
- Response contains a Transfer-Encoding header whose value is gzip.
- Neither Content-Length nor Transfer-Encoding headers are present in the response.
- Response size is smaller than 30 bytes.

When compression is *applied*:

- Content-Length will be removed from response headers.
- Response headers will contain "Transfer-Encoding: chunked" and "Content-Encodig: gzip".

When filter is *enabled*:

- "Vary: Accept-Encoding" header will be inserted on every response.
