#include <iostream>
#include <cstdlib>

#include "google/protobuf/descriptor.h"

// Basic C++ build/link validation for the v2 xDS APIs.
int main(int argc, char* argv[]) {
  const auto methods = {
      "envoy.api.v2.discovery.AggregatedDiscoveryService.StreamAggregatedResources",
      "envoy.api.v2.discovery.ClusterDiscoveryService.FetchClusters",
      "envoy.api.v2.discovery.ClusterDiscoveryService.StreamClusters",
      "envoy.api.v2.discovery.EndpointDiscoveryService.FetchEndpoints",
      "envoy.api.v2.discovery.EndpointDiscoveryService.StreamEndpoints",
      "envoy.api.v2.discovery.HealthDiscoveryService.FetchHealthCheck",
      "envoy.api.v2.discovery.HealthDiscoveryService.StreamHealthCheck",
      "envoy.api.v2.discovery.ListenerDiscoveryService.FetchListeners",
      "envoy.api.v2.discovery.ListenerDiscoveryService.StreamListeners",
      "envoy.api.v2.discovery.RouteDiscoveryService.FetchRoutes",
      "envoy.api.v2.discovery.RouteDiscoveryService.StreamRoutes",
      "envoy.api.v2.filter.accesslog.AccessLogService.StreamAccessLogs",
      "envoy.api.v2.monitoring.MetricsService.StreamMetrics",
      "envoy.api.v2.ratelimit.RateLimitService.ShouldRateLimit",
  };

  for (const auto& method : methods) {
    if (google::protobuf::DescriptorPool::generated_pool()->FindMethodByName(method) == nullptr) {
      std::cout << "Unable to find method descriptor for " << method << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
