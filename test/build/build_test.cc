#include "api/cds.pb.h"
#include "api/eds.pb.h"
#include "api/hds.pb.h"
#include "api/lds.pb.h"
#include "api/rlds.pb.h"
#include "api/rds.pb.h"

// Basic C++ build/link validation for the v2 xDS APIs.
int main(int argc, char *argv[]) {
  envoy::api::v2::ClusterDiscoveryService::descriptor();
  envoy::api::v2::EndpointDiscoveryService::descriptor();
  envoy::api::v2::HealthDiscoveryService::descriptor();
  envoy::api::v2::ListenerDiscoveryService::descriptor();
  envoy::api::v2::RateLimitDiscoveryService::descriptor();
  envoy::api::v2::RouteDiscoveryService::descriptor();
}
