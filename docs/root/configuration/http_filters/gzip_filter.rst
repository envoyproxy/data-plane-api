.. _config_http_filters_gzip:

Gzip
====
Gzip is an HTTP filter which enables Envoy to compress dispatched data from an upstream
service upon client request. This is useful in situations where large payloads need to
be transmitted without compromising the response time.

Configuration
-------------
* :ref:`v1 API reference <config_http_filters_gzip_v1>`
* :ref:`v2 API reference <envoy_api_msg_filter.http.Gzip>`

.. attention::

  Due to a known bug in the underlying zlib library, window bits with value 8 does not work as expected,
  therefore 9 is the smallest window size supported by gzip filter at the moment. This issue might be
  solved in future releases of the library.

How it works
------------
When gzip filter is enabled, request and response headers are inspected in order to determine whether or
not the content should be compressed. If either response and request allows, content is compressed and then sent to
the client with the appropriate headers.

By *default* compression will be *skipped* when:

- Request does NOT contain *Accept-Encoding* header.
- Request contains *Accept-Encoding* header, however it does not allow "gzip".
- Response contains a *Content-Encoding* header.
- Response contains a *Cache-Control* header whose value is no-transform.
- Response contains a *Transfer-Encoding* header whose value is gzip.
- Response does not contain a *Content-Type* value that matches one of the following
  MIME-TYPES: *html, text, css, js, json, svg, xml. xhtml*.
- Neither *Content-Length* nor *Transfer-Encoding* headers are present in the response.
- Response size is smaller than 30 bytes.
- Strong *Etag* is removed from the response if any.

When compression is *applied*:

- *Content-Length* is removed from response headers.
- Response headers contain "*Transfer-Encoding: chunked*" and "*Content-Encodig: gzip*".
- "*Vary: Accept-Encoding*" header is inserted on every response.
