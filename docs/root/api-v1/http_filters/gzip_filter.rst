.. _config_http_filters_gzip_v1:

Gzip
======

Gzip :ref:`configuration overview <config_http_filters_gzip>`.

.. code-block:: json

  {
    "name": "gzip",
    "config": {
      "memory_level": "...",
      "content_length": "...",
      "compression_level": "...",
      "compression_strategy": "...",
      "content_type": "...",
      "disable_on_etag_header": "...",
      "disable_on_last_modified_header": "...",
      "window_bits": "...",
      "disable_vary": "...",
    }
  }

memory_level
  *(optional, integer)* Value from 1 to 9 that controls the amount of internal memory used
  by Zlib. Higher values use more memory, but are faster and produce better compression results.
  The default value is 5.

content_length
  *(optional, integer)* Minimum response length, in bytes, which will trigger compression. The default
  value is 30.

compression_level
  *(optional, string)* A value used for selecting Zlib's compression level. This setting will affect
  speed and amount of compression applied to the content. "BEST" provides higher compression at the
  cost of higher latency, "SPEED" provides lower compression with minimum impact on response time.
  "DEFAULT" provides an optimal result between speed and compression. This field will be set
  to "DEFAULT" if not specified.

compression_strategy
  *(optional, string)* A value used for selecting Zlib's compression strategy which is directly related
  to the characteristics of the content. Most of the time "DEFAULT" will be the best choice, though
  there are situations which changing this parameter might produce better results. For example,
  Run-length encoding (RLE) is typically used when the content is known for having sequences which
  same data occurs many consecutive times. For more information about each strategy, please refer to
  Zlib manual.

content_type
  *(optional, string)* Set of strings that allows specifying which mime-types yield compression; e.g.,
  application/JSON, text/HTML, etc. When this field is not defined, compression will be applied to
  the following mime-types: "application/javascript", "application/json", "application/xhtml+xml",
  "image/svg+xml", "text/css", "text/html", "text/plain", "text/xml".

disable_on_etag_header
  *(optional, boolean)* If true, disables compression when the response contains Etag header. When
  it is false, the filter will preserve weak Etags and remove the ones that require strong validation.
  Note that if any of these options fit the specific scenario, an alternative solution is to disabled
  Etag at the origin and use Last-Modified header instead.

disable_on_last_modified_header
  *(optional, boolean)* Value that disables compression if response contains Last-Modified
  header. Default is false, which means that filter will not skip compression upon the presence
  of this header.

window_bits
  *(optional, integer)* Value from 9 to 15 that represents the base two logarithm of the
  compressor's window size. Larger values result in better compression at the expense of memory
  usage; e.g. 12 will produce a 4096 bytes window. Default is 12. For more details about this
  parameter, please refer to Zlib manual > deflateInit2.
