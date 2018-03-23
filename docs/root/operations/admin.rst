.. _operations_admin_interface:

Administration interface
========================

Envoy exposes a local administration interface that can be used to query and
modify different aspects of the server:

* :ref:`v1 API reference <config_admin_v1>`
* :ref:`v2 API reference <envoy_api_msg_config.bootstrap.v2.Admin>`

.. attention::

  The administration interface in its current form both allows destructive operations to be
  performed (e.g., shutting down the server) as well as potentially exposes private information
  (e.g., stats, cluster names, cert info, etc.). It is **critical** that access to the
  administration interface is only allowed via a secure network. It is also **critical** that hosts
  that access the administration interface are **only** attached to the secure network (i.e., to
  avoid CSRF attacks). This involves setting up an appropriate firewall or optimally only allowing
  access to the administration listener via localhost. This can be accomplished with a v2
  configuration like the following:

  .. code-block:: yaml

    admin:
      access_log_path: /tmp/admin_access.log
      address:
        socket_address: { address: 127.0.0.1, port_value: 9901 }

  In the future additional security options will be added to the administration interface. This
  work is tracked in `this <https://github.com/envoyproxy/envoy/issues/2763>`_ issue.

.. http:get:: /

  Render an HTML home page with a table of links to all available options.

.. http:get:: /help

  Print a textual table of all available options.

.. http:get:: /certs

  List out all loaded TLS certificates, including file name, serial number, and days until
  expiration.

.. _operations_admin_interface_clusters:

.. http:get:: /clusters

  List out all configured :ref:`cluster manager <arch_overview_cluster_manager>` clusters. This
  information includes all discovered upstream hosts in each cluster along with per host statistics.
  This is useful for debugging service discovery issues.

  Cluster manager information
    - ``version_info`` string -- the version info string of the last loaded
      :ref:`CDS<config_cluster_manager_cds>` update.
      If envoy does not have :ref:`CDS<config_cluster_manager_cds>` setup, the
      output will read ``version_info::static``.

  Cluster wide information
    - :ref:`circuit breakers<config_cluster_manager_cluster_circuit_breakers>` settings for all priority settings.

    - Information about :ref:`outlier detection<arch_overview_outlier_detection>` if a detector is installed. Currently
      :ref:`success rate average<arch_overview_outlier_detection_ejection_event_logging_cluster_success_rate_average>`,
      and :ref:`ejection threshold<arch_overview_outlier_detection_ejection_event_logging_cluster_success_rate_ejection_threshold>`
      are presented. Both of these values could be ``-1`` if there was not enough data to calculate them in the last
      :ref:`interval<config_cluster_manager_cluster_outlier_detection_interval_ms>`.

    - ``added_via_api`` flag -- ``false`` if the cluster was added via static configuration, ``true``
      if it was added via the :ref:`CDS<config_cluster_manager_cds>` api.

  Per host statistics
    .. csv-table::
      :header: Name, Type, Description
      :widths: 1, 1, 2

      cx_total, Counter, Total connections
      cx_active, Gauge, Total active connections
      cx_connect_fail, Counter, Total connection failures
      rq_total, Counter, Total requests
      rq_timeout, Counter, Total timed out requests
      rq_success, Counter, Total requests with non-5xx responses
      rq_error, Counter, Total requests with 5xx responses
      rq_active, Gauge, Total active requests
      healthy, String, The health status of the host. See below
      weight, Integer, Load balancing weight (1-100)
      zone, String, Service zone
      canary, Boolean, Whether the host is a canary
      success_rate, Double, "Request success rate (0-100). -1 if there was not enough
      :ref:`request volume<config_cluster_manager_cluster_outlier_detection_success_rate_request_volume>`
      in the :ref:`interval<config_cluster_manager_cluster_outlier_detection_interval_ms>`
      to calculate it"

  Host health status
    A host is either healthy or unhealthy because of one or more different failing health states.
    If the host is healthy the ``healthy`` output will be equal to *healthy*.

    If the host is not healthy, the ``healthy`` output will be composed of one or more of the
    following strings:

    */failed_active_hc*: The host has failed an :ref:`active health check
    <config_cluster_manager_cluster_hc>`.

    */failed_outlier_check*: The host has failed an outlier detection check.

.. http:get:: /cpuprofiler

  Enable or disable the CPU profiler. Requires compiling with gperftools.

.. _operations_admin_interface_healthcheck_fail:

.. http:get:: /healthcheck/fail

  Fail inbound health checks. This requires the use of the HTTP :ref:`health check filter
  <config_http_filters_health_check>`. This is useful for draining a server prior to shutting it
  down or doing a full restart. Invoking this command will universally fail health check requests
  regardless of how the filter is configured (pass through, etc.).

.. _operations_admin_interface_healthcheck_ok:

.. http:get:: /healthcheck/ok

  Negate the effect of :http:get:`/healthcheck/fail`. This requires the use of the HTTP
  :ref:`health check filter <config_http_filters_health_check>`.

.. http:get:: /hot_restart_version

  See :option:`--hot-restart-version`.

.. _operations_admin_interface_logging:

.. http:get:: /logging

  Enable/disable different logging levels on different subcomponents. Generally only used during
  development.

.. http:get:: /quitquitquit

  Cleanly exit the server.

.. http:get:: /reset_counters

  Reset all counters to zero. This is useful along with :http:get:`/stats` during debugging. Note
  that this does not drop any data sent to statsd. It just effects local output of the
  :http:get:`/stats` command.

.. _operations_admin_interface_routes:

.. http:get:: /routes?route_config_name=<name>

  This endpoint is only available if envoy has HTTP routes configured via RDS.
  The endpoint dumps all the configured HTTP route tables, or only ones that
  match the ``route_config_name`` query, if a query is specified.

.. http:get:: /server_info

  Outputs information about the running server. Sample output looks like:

.. code-block:: none

  envoy 267724/RELEASE live 1571 1571 0

The fields are:

* Process name
* Compiled SHA and build type
* Health check state (live or draining)
* Current hot restart epoch uptime in seconds
* Total uptime in seconds (across all hot restarts)
* Current hot restart epoch

.. _operations_admin_interface_stats:

.. http:get:: /stats

  Outputs all statistics on demand. This includes only counters and gauges. Histograms are not
  output as Envoy currently has no built in histogram support and relies on statsd for
  aggregation. This command is very useful for local debugging. See :ref:`here <operations_stats>`
  for more information.

  .. http:get:: /stats?format=json

  Outputs /stats in JSON format. This can be used for programmatic access of stats.

  .. http:get:: /stats?format=prometheus

  Outputs /stats in `Prometheus <https://prometheus.io/docs/instrumenting/exposition_formats/>`_
  v0.0.4 format. This can be used to integrate with a Prometheus server. Currently, only counters and
  gauges are output. Histograms will be output in a future update.

.. _operations_admin_interface_runtime:

.. http:get:: /runtime

  Outputs all runtime values on demand in a human-readable format. See
  :ref:`here <arch_overview_runtime>` for more information on how these values are configured
  and utilized.

  .. http:get:: /runtime?format=json

  Outputs /runtime in JSON format. This can be used for programmatic access of runtime values.
