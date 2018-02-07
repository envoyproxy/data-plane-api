.. _install_getting_started:

Getting Started
===============

This section features sample configurations and guides to quickly getting started with Envoy.

Sandboxes
---------

We've created a number of sandboxes using Docker Compose that set up different environments to test out Envoy's features and show samples configurations. As we gauge people's interests we will add more sandboxes demonstrating
different features. The following sandboxes are available:

.. toctree::
  :maxdepth: 1

  sandboxes/front_proxy
  sandboxes/zipkin_tracing
  sandboxes/jaeger_tracing
  sandboxes/grpc_bridge

Modifying Envoy
---------------

If you're interested in modifying Envoy and testing your changes, one approach is to use Docker. This guide will walk through the process of building your own Envoy binary, and putting the binary in an Ubuntu container.

.. toctree::
  :maxdepth: 1
  
  sandboxes/local_docker_build
