.. _config_cluster_manager_cluster_ring_hash_lb_config:

Ring hash load balancer configuration
=====================================

Ring hash load balancing settings are used when the *lb_type* is set to *ring_hash* in the
:ref:`cluster manager <config_cluster_manager_cluster_lb_type>`.

.. code-block:: json

  {
    "minimum_ring_size": "...",
    "use_std_hash": "..."
  }

minimum_ring_size
  *(optional, integer)* Minimum hash ring size, i.e. total virtual nodes. Defaults to 1024. In the
  case that total number of hosts is greater than the minimum, each host will be allocated a single
  virtual node.

use_std_hash
  *(optional, boolean)* If set to false, use `xxHash <https://github.com/Cyan4973/xxHash>`_ for hashing hosts onto the ring. Defaults to
  true, which uses *std::hash* instead. *std::hash* varies by platform. For this reason, setting to
  false is recommended.  Eventually, the setting will be removed and only *xxHash* will be
  supported.
