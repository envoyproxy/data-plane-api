#include <iostream>
#include <cstdlib>

#include "google/protobuf/descriptor.h"

// Basic C++ build/link validation for the v2 xDS APIs.
int main(int argc, char* argv[]) {
  const auto methods = {
      "envoy.service.discovery.v2.AggregatedDiscoveryService.StreamAggregatedResources",
      "envoy.service.discovery.v2.ClusterDiscoveryService.FetchClusters",
      "envoy.service.discovery.v2.ClusterDiscoveryService.StreamClusters",
      "envoy.service.discovery.v2.EndpointDiscoveryService.FetchEndpoints",
      "envoy.service.discovery.v2.EndpointDiscoveryService.StreamEndpoints",
      "envoy.service.discovery.v2.HealthDiscoveryService.FetchHealthCheck",
      "envoy.service.discovery.v2.HealthDiscoveryService.StreamHealthCheck",
      "envoy.service.discovery.v2.ListenerDiscoveryService.FetchListeners",
      "envoy.service.discovery.v2.ListenerDiscoveryService.StreamListeners",
      "envoy.service.discovery.v2.RouteDiscoveryService.FetchRoutes",
      "envoy.service.discovery.v2.RouteDiscoveryService.StreamRoutes",
      "envoy.service.accesslog.v2.AccessLogService.StreamAccessLogs",
      "envoy.api.v2.monitoring.MetricsService.StreamMetrics",
      "envoy.service.ratelimit.v2.RateLimitService.ShouldRateLimit",
  };

  for (const auto& method : methods) {
    if (google::protobuf::DescriptorPool::generated_pool()->FindMethodByName(method) == nullptr) {
      std::cout << "Unable to find method descriptor for " << method << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
