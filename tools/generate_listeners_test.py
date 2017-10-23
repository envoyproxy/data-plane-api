"""Tests for generate_listeners."""

import generate_listeners

if __name__ == "__main__":
  generate_listeners.GenerateListeners(
      "examples/service_envoy/listeners.pb", "/dev/stdout", "/dev/stdout",
      iter(["examples/service_envoy/http_connection_manager.pb"]))
