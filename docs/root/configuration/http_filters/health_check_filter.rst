.. _config_http_filters_health_check:

Health check
============

* Health check filter :ref:`architecture overview <arch_overview_health_checking_filter>`
* :ref:`v1 configuration <config_http_filters_health_check_v1>`
* :ref:`v2 configuration <envoy_api_msg_filter.http.HealthCheck>`

.. note::

  Note that the filter will automatically fail health checks and set the
  :ref:`x-envoy-immediate-health-check-fail
  <config_http_filters_router_x-envoy-immediate-health-check-fail>` header if the
  :ref:`/healthcheck/fail <operations_admin_interface_healthcheck_fail>` admin endpoint has been
  called. (The :ref:`/healthcheck/ok <operations_admin_interface_healthcheck_ok>` admin endpoint
  reverses this behavior).
