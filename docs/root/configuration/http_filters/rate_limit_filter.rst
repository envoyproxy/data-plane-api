.. _config_http_filters_rate_limit:

Rate limit
==========

* Global rate limiting :ref:`architecture overview <arch_overview_rate_limit>`
* :ref:`v1 API reference <config_http_filters_rate_limit_v1>`
* :ref:`v2 API reference <envoy_api_msg_config.filter.http.rate_limit.v2.RateLimit>`

The HTTP rate limit filter will call the rate limit service when the request's route or virtual host
has one or more :ref:`rate limit configurations<config_http_conn_man_route_table_route_rate_limits>`
that match the filter stage setting. The :ref:`route<config_http_conn_man_route_table_route_include_vh>`
can optionally include the virtual host rate limit configurations. More than one configuration can
apply to a request. Each configuration results in a descriptor being sent to the rate limit service.

If the rate limit service is called, and the response for any of the descriptors is over limit, a
429 response is returned.

.. _config_http_filters_rate_limit_composing_actions:

Composing Actions
-----------------

.. attention::

  This section is written for the v1 API but the concepts also apply to the v2 API. It will be
  rewritten to target the v2 API in a future release.

Each :ref:`rate limit action <config_http_conn_man_route_table_rate_limit_config>` on the route or
virtual host populates a descriptor entry. A vector of descriptor entries compose a descriptor. To
create more complex rate limit descriptors, actions can be composed in any order. The descriptor
will be populated in the order the actions are specified in the configuration.

Example 1
^^^^^^^^^

For example, to generate the following descriptor:

.. code-block:: cpp

  ("generic_key", "some_value")
  ("source_cluster", "from_cluster")

The configuration would be:

.. code-block:: json

  {
    "actions" : [
    {
      "type" : "generic_key",
      "descriptor_value" : "some_value"
    },
    {
      "type" : "source_cluster"
    }
    ]
  }

Example 2
^^^^^^^^^

If an action doesn't append a descriptor entry, no descriptor is generated for
the configuration.

For the following configuration:

.. code-block:: json

  {
    "actions" : [
    {
      "type" : "generic_key",
      "descriptor_value" : "some_value"
    },
    {
      "type" : "remote_address"
    },
    {
      "type" : "souce_cluster"
    }
    ]
  }

If a request did not set :ref:`x-forwarded-for<config_http_conn_man_headers_x-forwarded-for>`,
no descriptor is generated.

If a request sets :ref:`x-forwarded-for<config_http_conn_man_headers_x-forwarded-for>`, the
the following descriptor is generated:

.. code-block:: cpp

  ("generic_key", "some_value")
  ("remote_address", "<trusted address from x-forwarded-for>")
  ("source_cluster", "from_cluster")

Statistics
----------

The buffer filter outputs statistics in the *cluster.<route target cluster>.ratelimit.* namespace.
429 responses are emitted to the normal cluster :ref:`dynamic HTTP statistics
<config_cluster_manager_cluster_stats_dynamic_http>`.

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

  ok, Counter, Total under limit responses from the rate limit service
  error, Counter, Total errors contacting the rate limit service
  over_limit, Counter, total over limit responses from the rate limit service

Runtime
-------

The HTTP rate limit filter supports the following runtime settings:

ratelimit.http_filter_enabled
  % of requests that will call the rate limit service. Defaults to 100.

ratelimit.http_filter_enforcing
  % of requests that will call the rate limit service and enforce the decision. Defaults to 100.
  This can be used to test what would happen before fully enforcing the outcome.

ratelimit.<route_key>.http_filter_enabled
  % of requests that will call the rate limit service for a given *route_key* specified in the
  :ref:`rate limit configuration <config_http_conn_man_route_table_rate_limit_config>`. Defaults to 100.
