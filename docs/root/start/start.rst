.. _start:

Getting Started
===============

This section provides some example configurations.

Envoy does not currently provide separate pre-built binaries, but does provide Docker images. This is
the fastest way to get started using Envoy. Should you wish to use Envoy outside of a
Docker container, you will need to :ref:`build it <building>`.

These examples use the :ref:`v2 Envoy API <envoy_api_reference>`, but use only the static configuration
feature of the API, which is most useful for simple requirements. For more complex requirements
:ref:`Dynamic Configuration <arch_overview_dynamic_config>` is supported.

Examples
--------

To quickly learn the basics of configuring Envoy, here are examples with annotated configuration files.

.. toctree::
    :maxdepth: 1

    simple_example


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

Using a Configuration File with the Envoy Docker Image
------------------------------------------------------

You can create a simple Dockerfile to execute Envoy, which assumes that envoy.yaml (described in the Examples)
is in your local directory.
You can refer to the :ref:`Command line options <operations_cli>`.

.. code-block:: none

  FROM envoyproxy/envoy:latest
  RUN apt-get update
  COPY envoy.yaml /etc/envoy.yaml
  CMD /usr/local/bin/envoy -c /etc/envoy.yaml

Build the Docker image that runs your configuration using::

  $ docker build -t envoy:v1

And now you can execute it with (assumes the port mapping of the :ref:`simple example <start_simple>`)::

  $ docker run -d --name envoy -p 9901:9901 -p 10000:10000 envoy:v1

And finally test it using (again, assuming the :ref:`simple example <start_simple>`)::

  $ curl -v localhost:10000


Other use cases
---------------

In addition to the proxy itself, Envoy is also bundled as part of several open
source distributions that target specific use cases.

.. toctree::
    :maxdepth: 1

    distro/ambassador
