.. _staticitics:

Statistics
==========

A few statistics are emitted to report statistics system behavior:

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

  stats.overflow, Counter, Total number of times Envoy enters a degreted state due to shortage of shared memory

Server
------

Server related statistics are rooted at *server.* with following statistics:

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

  uptime, Gauge, Current server uptime in seconds
  memory_allocated, Gauge, Current amount of allocated memory
  memory_heap_size, Gauge, Current reserved heap size
  live, Gauge, *1* if the server is running
  parent_connections, Gauge, Total connections of the old Envoy process on hot restart
  total_connections, Gauge, Total connections of both new and old Envoy processes
  version, Gauge, Integer represented version number based on SCM revision
  days_until_first_cert_expiring, Gauge, Number of days until the next certificate being managed will expire

File system
-----------

Statistics related with file system are emitted in the *filesystem.* namespace.

.. csv-table::
  :header: Name, Type, Description
  :widths: 1, 1, 2

  write_buffered, Counter, Total number of times file data are moved to Envoy's internal flush buffer
  write_completed, Counter, Total number of times files are wrote
  flushed_by_timer, Counter, Total number of times internal flush buffers are wrote to file descriptors with write(2)
  reopen_failed, Counter, Total number of times failed to open files
  write_total_buffered, Gauge, Current total size of internal flush buffer
