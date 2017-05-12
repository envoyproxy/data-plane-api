# Envoy v2 gRPC APIs

## Goals

This repository contains the draft v2 gRPC
[Envoy](https://github.com/lyft/envoy/) APIs. Envoy today has a number of JSON
REST APIs through which it may discover and have updated its runtime
configuration from some management server. These are:

* [Cluster Discovery Service (CDS)](https://lyft.github.io/envoy/docs/configuration/cluster_manager/cds.html)
* [Rate Limit Service (RLS)](https://lyft.github.io/envoy/docs/configuration/overview/rate_limit.html)
* [Route Discovery Service (RDS)](https://lyft.github.io/envoy/docs/configuration/http_conn_man/rds.html)
* [Service Discovery Service (SDS)](https://lyft.github.io/envoy/docs/configuration/cluster_manager/sds_api.html)

Version 2 of the Envoy API will evolve existing APIs and introduce new APIs to:

* Allow for more advanced load balancing through load and resource utilization reporting to management servers.
* Improve N^2 health check scalability issues by optionally offloading health checking to other Envoy instances.
* Support Envoy deployment in edge, sidecar and middle proxy deployment models via changes to the listener model and CDS/SDS APIs.
* Allow streaming updates from the management server on change, instead of polling APIs from Envoy. gRPC APIs will be supported
  alongside JSON REST APIs to provide for this.
* Ensure all Envoy runtime configuration is dynamically discoverable via API
  calls, including listener configuration, certificates and runtime settings, which are today sourced from the filesystem.
* Revisit and where appropriate cleanup any v1 technical debt.

## Status

Draft work-in-progress. Input is welcome via issue filing. Small, localized PRs
are also welcome, but any major changes or suggestions should be coordinated in
a tracking issue with the authors.

## Principles

* [Proto3](https://developers.google.com/protocol-buffers/docs/proto3) will be
  used to specify the canonical API. This will provide directly the gRPC API and
  via gRPC-JSON transcoding the JSON REST API.

* xDS APIs should support eventual consistency. For example, if HDS references a
  host that has not yet been supplied by EDS, it should be silently ignored.

* The API is primarily intended for machine generation and consumption. It is
  expected that the management server is responsible for mapping higher level
  configuration concepts to API responses. Similarly, static configuration
  fragments may be generated by templating tools, etc.

* [Wrapped](https://github.com/google/protobuf/blob/master/src/google/protobuf/wrappers.proto)
  protobuf fields should be used for all non-string [scalar
  types](https://developers.google.com/protocol-buffers/docs/proto3#scalar), to
  support non-zero default values. While only some fields require wrapping, for
  consistency we prefer to have all non-string scalar fields wrapped.

## APIs

Unless otherwise states, the APIs with the same names as v1 APIs have a similar role.

* [Cluster Discovery Service](api/cds.proto).
* [Endpoint Discovery Service](api/eds.proto). This has the same role as SDS in the [v1 API](https://lyft.github.io/envoy/docs/configuration/cluster_manager/sds_api.html). Advanced global load balancing capable of utilizing N-dimensional upstream metrics is now supported.
* [Listener Discover Service](api/lds.proto). This new API supports dynamic discovery of the listener configuration (which ports to bind to, TLS details, filter chains, etc.).
* Health Discovery Service. This new API supports efficient endpoint health discovery by the management server via the Envoy instances it manages.
* Rate Limit Service.
* [Route Discovery Service](api/rds.proto).

## Terminology

Some relevant [existing terminology](https://lyft.github.io/envoy/docs/intro/arch_overview/terminology.html) is
repeated below and some new v2 gRPC terms introduced.

* Cluster: A cluster is a group of logically similar upstream hosts that Envoy
  connects to. In v2, RDS routes points to clusters, CDS provides cluster configuration and
  Envoy discovers the cluster members via EDS.

* Downstream: A downstream host connects to Envoy, sends requests, and receives responses.

* Endpoint: An endpoint is an upstream host that is a member of one or more clusters. Endpoints are discovered via EDS.

* Listener: A listener is a named network location (e.g., port, unix domain socket, etc.) that can be connected to by downstream clients. Envoy exposes one or more listeners that downstream hosts connect to.

* Locality: A location where an Envoy instance or an endpoint runs. This includes
  region, zone and sub-zone identification.

* Management server: A logical server implementing the v2 Envoy APIs. This is not necessarily a single physical machine since it may be replicated/sharded and API serving for different xDS APIs may be implemented on different physical machines.

* Region: Geographic region where a zone is located.

* Sub-zone: Location within a zone where an Envoy instance or an endpoint runs.

* Upstream: An upstream host receives connections and requests from Envoy and returns responses.

* xDS: CDS/EDS/HDS/LDS/RDS.

* Zone: Availability Zone (AZ) in AWS, Zone in GCP.
