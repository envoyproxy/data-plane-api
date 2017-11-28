.. _config_cluster_manager:

Cluster manager
===============

.. toctree::
  :hidden:

  cluster
  sds
  sds_api
  outlier
  cds

Cluster manager :ref:`architecture overview <arch_overview_cluster_manager>`.

* :ref:`v1 API reference <config_cluster_manager_v1>`
* :ref:`v2 API reference <envoy_api_msg_ClusterManager>`

Statistics
----------

The cluster manager has a statistics tree rooted at *cluster_manager.* with the following
statistics. Any ``:`` character in the stats name is replaced with ``_``.

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

  cluster_added, Counter, Total clusters added (either via static config or CDS)
  cluster_modified, Counter, Total clusters modified (via CDS)
  cluster_removed, Counter, Total clusters removed (via CDS)
  total_clusters, Gauge, Number of currently loaded clusters
