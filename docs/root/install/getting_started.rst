.. _install_getting_started:

Getting Started
===============

This section features sample configurations and guides to quickly getting started with Envoy.

A basic configuration
---------------------

A very minimal Envoy configuration that can be used to validate basic plain HTTP
proxying is available in :repo:`configs/google_com_proxy.v2.yaml`. This is not
intended to represent a realistic Envoy deployment.

Copy both :repo:`configs/Dockerfile` and
:repo:`configs/google_com_proxy.v2.yaml` to the same directory on your local
disk. Then, build and run the Dockerfile, and test out Envoy by sending a
request to port 10000::

  $ docker build -t envoy-google-test:v1 .
  $ docker run -d -p 10000:10000 envoy-google-test:v1
  $ curl -v localhost:10000

The Dockerfile will build a container containing the latest version of Envoy,
and copy a basic Envoy configuration into the container. This basic
configuration tells Envoy to route incoming requests to \*.google.com.

Sandboxes
---------

We've created a number of sandboxes using Docker Compose that set up different
environments to test out Envoy's features and show sample configurations. As we
gauge peoples' interests we will add more sandboxes demonstrating different
features. The following sandboxes are available:

.. toctree::
  :maxdepth: 1

  sandboxes/front_proxy
  sandboxes/zipkin_tracing
  sandboxes/jaeger_tracing
  sandboxes/grpc_bridge

Modifying Envoy
---------------

If you're interested in modifying Envoy and testing your changes, one approach
is to use Docker. This guide will walk through the process of building your own
Envoy binary, and putting the binary in an Ubuntu container.

.. toctree::
  :maxdepth: 1

  sandboxes/local_docker_build
