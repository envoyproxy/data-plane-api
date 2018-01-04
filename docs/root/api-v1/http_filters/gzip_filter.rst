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
      "disable_on_etag": "...",
      "disable_on_last_modified": "...",
      "window_bits": "...",
      "disable_vary": "...",
    }
  }

memory_level
  *(optional, integer)* Value from 1 to 9 that controls the amount of internal memory used by zlib. Higher values
  use more memory, but are faster and produce better compression results. Default value is 5.

content_length
  *(optional, integer)* Minimum response length, in bytes, which will trigger compression. Default value is 30.

compression_level
  *(optional, string)* Value used for selecting zlib's compression level. This setting will affect
  speed and amount of compression applied to the content. "BEST" option provides higher
  compression at cost of higher latency, "SPEED" provides lower compression with minimum impact
  on response time. "DEFAULT" provides an optimal result between speed and compression. This
  field will be set to "DEFAULT" if not specified.

compression_strategy
  *(optional, string)* Value used for selecting zlib's compression strategy. Strategy is directly
  related to the characteristics of the content which is being compressed. Most of the time
  "DEFAULT" will be the best choice, however there are situations which changing the strategy
  might produce better results. For example, Run-length encoding (RLE) is normally used when the
  content is known for having sequences which same data occurs many consecutive times. For more
  information about each strategy, please refer to Zlib manual. This field will be set to
  "DEFAULT" if not specified.

content_type
  *(optional, string)* Set of strings that allows specifying which mime-types yield compression; e.g.
  application/json, text/html, etc. When this field is not specified, compression will be applied
  to the following MIME-TYPES: html, text, css, js, json, svg, xml. xhtml".

disable_on_etag
  *(optional, boolean)* Value that disables compression if response contains Etag (entity tag)
  header. This option is disabled by default (false), which means that strong Etags will be
  re-writen to its weak form before being dispatched to the client. If for some reason the client
  does not support weak validation, it is recommended to have this enabled.

disable_on_last_modified
  *(optional, boolean)* Value that disables compression if response contains Last-Modified
  header. Default is false, which means that filter will not skip compression upon the presence
  of this header.

window_bits
  *(optional, integer)* Value from 9 to 15 that represents the base two logarithm of the compressor's window size.
  Larger values result in better compression at the expense of memory usage; e.g. 12 will produce
  a 4096 bytes window. Default is 12. For more details about this parameter, please refer to Zlib
  manual > deflateInit2.

disable_vary
  *(optional, boolean)* Value that disables the insertion of “Vary: Accept-Encoding” in the response header.
  Tipically Vary:Accept-Encoding instructs proxies to store the compressed version of
  the content. Default is false, which means that this header will be inserted on every
  compressed response.
