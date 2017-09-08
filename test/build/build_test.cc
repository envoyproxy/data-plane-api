#include <iostream>
#include <cstdlib>

#include "google/protobuf/descriptor.h"

// Basic C++ build/link validation for the v2 xDS APIs.
int main(int argc, char *argv[]) {
  const auto methods = {
    "envoy.api.v2.AggregatedDiscoveryService.StreamAggregatedResources",
    "envoy.api.v2.ClusterDiscoveryService.FetchClusters",
    "envoy.api.v2.ClusterDiscoveryService.StreamClusters",
    "envoy.api.v2.EndpointDiscoveryService.FetchEndpoints",
    "envoy.api.v2.EndpointDiscoveryService.StreamEndpoints",
    "envoy.api.v2.HealthDiscoveryService.FetchHealthCheck",
    "envoy.api.v2.HealthDiscoveryService.StreamHealthCheck",
    "envoy.api.v2.ListenerDiscoveryService.FetchListeners",
    "envoy.api.v2.ListenerDiscoveryService.StreamListeners",
    "envoy.api.v2.RouteDiscoveryService.FetchRoutes",
    "envoy.api.v2.RouteDiscoveryService.StreamRoutes",
    "envoy.api.v2.RateLimitService.ShouldRateLimit",
  };

  for (const auto& method : methods) {
    if (google::protobuf::DescriptorPool::generated_pool()->FindMethodByName(method) == nullptr) {
      std::cout << "Unable to find method descriptor for " << method << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
