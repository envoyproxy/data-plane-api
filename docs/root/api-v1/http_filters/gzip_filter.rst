.. _config_http_filters_gzip_v1:

Gzip
======

Gzip :ref:`configuration overview <config_http_filters_gzip>`.

.. code-block:: json

  {
    "name": "gzip",
    "config": {
      "memory_level": "...",
      "compression_level": "...",
      "compression_strategy": "...",
      "window_bits": "...",
      "content_length": "...",
      "content_type": "...",
      "no_proxied_request": "...",
      "no_vary": "...",
      "take_ownership": "..."
    }
  }

memory_level
  *(optional, integer)* Value from 1 to 9 that controls the amount of internal memory used by zlib.
  Higher values use more memory, but are faster and produce better compression results. Default value is 8.

compression_level
  *(optional, string)* Allows adjusting zlib's compression level. This setting will affect
  speed and amount of compression applied to the content. "BEST" option provides higher
  compression at cost of higher latency, "SPEED" provides lower compression with minimum impact
  on response time. "DEFAULT" provides an optimal result between speed and compression. This
  field will be set to "DEFAULT" if not specified.

compression_strategy
  *(optional, string)* Allows adjusting zlib's compression strategy. Strategy is directly
  related to the characteristics of the content which is being compressed. Most of the time
  "DEFAULT" will be the best choice, however there are situations which changing the strategy
  might produce better results. For example, Run-length encoding (RLE) is normally used when the
  content is known for having sequences which same data occurs many consecutive times. For more
  information about each strategy, please refer to Zlib manual. This field will be set to
  "DEFAULT" if not specified.

window_bits
  *(optional, integer)* Value from 9 to 15 that represents the base two logarithm of the compressor's window size.
  Larger values result in better compression at the expense of memory usage; e.g. 12 will produce
  a 4096 bytes window. Default is 15. For more details about this parameter, please refer to Zlib
  manual > deflateInit2.
  Note that due to a known bug in the underlying zlib library, window bits
  with value 8 does not work as expected, therefore 9 is the smallest window size supported by
  this filter at the moment. This issue might be solved in future releases of the library.

content_length
  *(optional, integer)* Minimum response length, in bytes, which will trigger compression.
  Default value is 30.

content_type
  *(optional, string)* Set of strings that allows specifying which mime-types yield compression; e.g.
  application/json, text/html, etc. When this field is not specified, compression will be applied
  to any "content-type".

no_proxied_request
  *(optional, boolean)* Value that allows disabling proxied requests by looking for the presence of Via request
  header. Default is false which means proxied requests will be allowed.

no_vary
  *(optional, boolean)* Value that allows disabling the insertion of “Vary: Accept-Encoding” in response header.
  Vary is useful for instructing proxies to store both compressed and uncompressed versions of the content.
  Default is false which means Vary http header will be inserted in every response.

take_ownership
  *(optional, boolean)* Value that allows offloading compression from an upstream service by stripping off
  Accept-Encoding from request header. Default is false which means that Accept-Encoding will not be
  removed.
