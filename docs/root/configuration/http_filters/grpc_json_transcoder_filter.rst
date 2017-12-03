.. _config_http_filters_grpc_json_transcoder:

gRPC-JSON transcoder filter
===========================

* gRPC :ref:`architecture overview <arch_overview_grpc>`
* :ref:`v1 API reference <config_http_filters_grpc_json_transcoder_v1>`
* :ref:`v2 API reference <envoy_api_msg_filter.http.GrpcJsonTranscoder>`

This is a filter which allows a RESTful JSON API client to send requests to Envoy over HTTP
and get proxied to a gRPC service. The HTTP mapping for the gRPC service has to be defined by
`custom options <https://cloud.google.com/service-management/reference/rpc/google.api#http>`_.
