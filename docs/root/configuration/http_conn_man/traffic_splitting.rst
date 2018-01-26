.. _config_http_conn_man_route_table_traffic_splitting:

Traffic Shifting/Splitting
===========================================

.. attention::

  This section is written for the v1 API but the concepts also apply to the v2 API. It will be
  rewritten to target the v2 API in a future release.

.. contents::
  :local:

Envoy's router can split traffic to a route in a virtual host across
two or more upstream clusters. There are two common use cases.

1. Version upgrades: traffic to a route is shifted gradually
from one cluster to another. The
:ref:`traffic shifting <config_http_conn_man_route_table_traffic_splitting_shift>`
section describes this scenario in more detail.

2. A/B testing or multivariate testing: ``two or more versions`` of
the same service are tested simultaneously. The traffic to the route has to
be *split* between clusters running different versions of the same
service. The
:ref:`traffic splitting <config_http_conn_man_route_table_traffic_splitting_split>`
section describes this scenario in more detail.

.. _config_http_conn_man_route_table_traffic_splitting_shift:

Traffic shifting between two upstreams
--------------------------------------

The :ref:`runtime <config_http_conn_man_route_table_route_runtime>` object
in the route configuration determines the probability of selecting a
particular route (and hence its cluster). By using the runtime
configuration, traffic to a particular route in a virtual host can be
gradually shifted from one cluster to another. Consider the following
example configuration, where two versions ``helloworld_v1`` and
``helloworld_v2`` of a service named ``helloworld`` are declared in the
envoy configuration file.

.. code-block:: json

    {
      "route_config": {
        "virtual_hosts": [
          {
            "name": "helloworld",
            "domains": ["*"],
            "routes": [
              {
                "prefix": "/",
                "cluster": "helloworld_v1",
                "runtime": {
                  "key": "routing.traffic_shift.helloworld",
                  "default": 50
                }
              },
              {
                "prefix": "/",
                "cluster": "helloworld_v2",
              }
            ]
          }
        ]
      }
    }

Envoy matches routes with a :ref:`first match <config_http_conn_man_route_table_route_matching>` policy.
If the route has a runtime object, the request will be additionally matched based on the runtime
:ref:`value <config_http_conn_man_route_table_route_runtime_default>`
(or the default, if no value is specified). Thus, by placing routes
back-to-back in the above example and specifying a runtime object in the
first route, traffic shifting can be accomplished by changing the runtime
value. The following are the approximate sequence of actions required to
accomplish the task.

1. In the beginning, set ``routing.traffic_shift.helloworld`` to ``100``,
   so that all requests to the ``helloworld`` virtual host would match with
   the v1 route and be served by the ``helloworld_v1`` cluster.
2. To start shifting traffic to ``helloworld_v2`` cluster, set
   ``routing.traffic_shift.helloworld`` to values ``0 < x < 100``. For
   instance at ``90``, 1 out of every 10 requests to the ``helloworld``
   virtual host will not match the v1 route and will fall through to the v2
   route.
3. Gradually decrease the value set in ``routing.traffic_shift.helloworld``
   so that a larger percentage of requests match the v2 route.
4. When ``routing.traffic_shift.helloworld`` is set to ``0``, no requests
   to the ``helloworld`` virtual host will match to the v1 route. All
   traffic would now fall through to the v2 route and be served by the
   ``helloworld_v2`` cluster.


.. _config_http_conn_man_route_table_traffic_splitting_split:

Traffic splitting across multiple upstreams
-------------------------------------------

Consider the ``helloworld`` example again, now with three versions (v1, v2 and
v3) instead of two. To split traffic evenly across the three versions
(i.e., ``33%, 33%, 34%``), the ``weighted_clusters`` option can be used to
specify the weight for each upstream cluster.

Unlike the previous example, a **single** :ref:`route
<config_http_conn_man_route_table_route>` entry is sufficient. The
:ref:`weighted_clusters <config_http_conn_man_route_table_route_weighted_clusters>`
configuration block in a route can be used to specify multiple upstream clusters
along with weights that indicate the **percentage** of traffic to be sent
to each upstream cluster.

.. code-block:: json

    {
      "route_config": {
        "virtual_hosts": [
          {
            "name": "helloworld",
            "domains": ["*"],
            "routes": [
              {
                "prefix": "/",
                "weighted_clusters": {
                  "runtime_key_prefix" : "routing.traffic_split.helloworld",
                  "clusters" : [
                    { "name" : "helloworld_v1", "weight" : 33 },
                    { "name" : "helloworld_v2", "weight" : 33 },
                    { "name" : "helloworld_v3", "weight" : 34 }
                  ]
                }
              }
            ]
          }
        ]
      }
    }

By default, the weights must sum to exactly 100. In the V2 API, the
:ref:`total weight <envoy_api_field_route.WeightedCluster.total_weight>` defaults to 100, but can
be modified to allow finer granularity.

The weights assigned to each cluster can be dynamically adjusted using the
following runtime variables: ``routing.traffic_split.helloworld.helloworld_v1``,
``routing.traffic_split.helloworld.helloworld_v2`` and
``routing.traffic_split.helloworld.helloworld_v3``.
