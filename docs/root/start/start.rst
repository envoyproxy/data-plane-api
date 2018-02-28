.. _start:

Getting Started
===============

This section gets you started with a very simple configuration and provides some example configurations.

Envoy does not currently provide separate pre-built binaries, but does provide Docker images. This is
the fastest way to get started using Envoy. Should you wish to use Envoy outside of a
Docker container, you will need to :ref:`build it <building>`.

These examples use the :ref:`v2 Envoy API <envoy_api_reference>`, but use only the static configuration
feature of the API, which is most useful for simple requirements. For more complex requirements
:ref:`Dynamic Configuration <arch_overview_dynamic_config>` is supported.

Quick Start to Run Simple Example
---------------------------------

These instructions run from files in the Envoy repo. The sections below give a
more detailed explanation of the configuration file and execution steps for
the same configuration.

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


Simple Configuration
--------------------

Envoy can be configured using a single YAML file passed in as an argument on the command line.

The :ref:`admin message <envoy_api_msg_config.bootstrap.v2.Admin>` is required to configure
the administration server. The `address` key specifies the
listening :ref:`address <envoy_api_file_envoy/api/v2/core/address.proto>`
which in this case is simply `0.0.0.0:9901`.

.. code-block:: yaml

  admin:
    access_log_path: /tmp/admin_access.log
    address:
      socket_address: { address: 0.0.0.0, port_value: 9901 }

The :ref:`static_resources <envoy_api_field_config.bootstrap.v2.Bootstrap.static_resources>` contains everything that is configured statically when Envoy starts,
as opposed to the means of configuring resources dynamically when Envoy is running.
The :ref:`v2 API Overview <config_overview_v2>` describes this.

.. code-block:: yaml

    static_resources:

The specification of the :ref:`listeners <envoy_api_file_envoy/api/v2/listener/listener.proto>`.

.. code-block:: yaml

      listeners:
      - name: listener_0
        address:
          socket_address: { address: 0.0.0.0, port_value: 10000 }
        filter_chains:
        - filters:
          - name: envoy.http_connection_manager
            config:
              stat_prefix: ingress_http
              codec_type: AUTO
              route_config:
                name: local_route
                virtual_hosts:
                - name: local_service
                  domains: ["*"]
                  routes:
                  - match: { prefix: "/" }
                    route: { host_rewrite: www.google.com, cluster: service_google }
              http_filters:
              - name: envoy.router

The specification of the :ref:`clusters <envoy_api_file_envoy/api/v2/cds.proto>`.

.. code-block:: yaml

      clusters:
      - name: service_google
        connect_timeout: 0.25s
        type: LOGICAL_DNS
        # Comment out the following line to test on v6 networks
        dns_lookup_family: V4_ONLY
        lb_policy: ROUND_ROBIN
        hosts: [{ socket_address: { address: google.com, port_value: 443 }}]
        tls_context: { sni: www.google.com }


Using the Envoy Docker Image
----------------------------

Create a simple Dockerfile to execute Envoy, which assumes that envoy.yaml (described above) is in your local directory.
You can refer to the :ref:`Command line options <operations_cli>`.

.. code-block:: none

  FROM envoyproxy/envoy:latest
  RUN apt-get update
  COPY envoy.yaml /etc/envoy.yaml
  CMD /usr/local/bin/envoy -c /etc/envoy.yaml

Build the Docker image that runs your configuration using::

  $ docker build -t envoy:v1

And now you can execute it with::

  $ docker run -d --name envoy -p 9901:9901 -p 10000:10000 envoy:v1

And finally test is using::

  $ curl -v localhost:10000


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

Other use cases
---------------

In addition to the proxy itself, Envoy is also bundled as part of several open
source distributions that target specific use cases.

.. toctree::
    :maxdepth: 1

    distro/ambassador
