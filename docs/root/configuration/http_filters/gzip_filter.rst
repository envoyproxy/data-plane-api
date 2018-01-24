.. _config_http_filters_gzip:

Gzip
====
Gzip is an HTTP filter which enables Envoy to compress dispatched data
from an upstream service upon client request. Compression is useful in
situations where large payloads need to be transmitted without
compromising the response time.

Configuration
-------------
* :ref:`v1 API reference <config_http_filters_gzip_v1>`
* :ref:`v2 API reference <envoy_api_msg_filter.http.Gzip>`

.. attention::

  Due to a known bug in the underlying Zlib library, window bits with value
  eight does not work as expected. Therefore any number below that will be
  automatically set to 9. This issue might be solved in future releases of
  the library.

How it works
------------
When gzip filter is enabled, request and response headers are inspected to
determine whether or not the content should be compressed. The content is
compressed and then sent to the client with the appropriate headers if either
response and request allow.

By *default* compression will be *skipped* when:

- A request does NOT contain *Accept-Encoding* header.
- A request includes *Accept-Encoding* header, but it does not contain "gzip".
- A response contains a *Content-Encoding* header.
- A Response contains a *Cache-Control* header whose value includes "no-transform".
- A response contains a *Transfer-Encoding* header whose value includes "gzip".
- A response does not contain a Content-Type value that matches one of the selected
  mime-types, which default to *application/javascript*, *application/json*,
  *application/xhtml+xml*, *image/svg+xml*, *text/css*, *text/html*, *text/plain*,
  *text/xml*.
- Neither *Content-Length* nor *Transfer-Encoding* headers are present in
  the response.
- Response size is smaller than 30 bytes (only applicable when transfer-encoding
  is not chuncked).

When compression is *applied*:

- *Content-Length* is removed from response headers.
- Response headers contain "*Transfer-Encoding: chunked*" and
  "*Content-Encoding: gzip*".
- "*Vary: Accept-Encoding*" header is inserted on every response.
