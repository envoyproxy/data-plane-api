#include <iostream>
#include <cstdlib>

// We don't use all the headers in the test below, but including them anyway as
// a cheap way to get some C++ compiler sanity checking.
#include "api/bootstrap.pb.validate.h"
#include "api/protocol.pb.validate.h"
#include "api/cluster/cluster.pb.validate.h"
#include "api/discovery/eds.pb.validate.h"
#include "api/lds.pb.validate.h"
#include "api/rds.pb.validate.h"
#include "api/rds.pb.validate.h"
#include "api/filter/accesslog/accesslog.pb.validate.h"
#include "api/filter/http/buffer.pb.validate.h"
#include "api/filter/http/fault.pb.validate.h"
#include "api/filter/http/health_check.pb.validate.h"
#include "api/filter/http/lua.pb.validate.h"
#include "api/filter/http/router.pb.validate.h"
#include "api/filter/http/squash.pb.validate.h"
#include "api/filter/http/transcoder.pb.validate.h"
#include "api/filter/network/http_connection_manager.pb.validate.h"
#include "api/filter/network/mongo_proxy.pb.validate.h"
#include "api/filter/network/redis_proxy.pb.validate.h"
#include "api/filter/network/tcp_proxy.pb.validate.h"

#include "google/protobuf/text_format.h"

template <class Proto> struct TestCase {
  void run() {
    std::string err;
    if (Validate(invalid_message, &err)) {
      std::cerr << "Unexpected successful validation of invalid message: "
                << invalid_message.DebugString() << std::endl;
      exit(EXIT_FAILURE);
    }
    if (!Validate(valid_message, &err)) {
      std::cerr << "Unexpected failed validation of valid message: " << valid_message.DebugString()
                << ", " << err << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  Proto& invalid_message;
  Proto& valid_message;
};

// Basic protoc-gen-validate C++ validation header inclusion and Validate calls
// from data-plane-api.
int main(int argc, char* argv[]) {
  envoy::api::v2::Bootstrap invalid_bootstrap;
  // This is a baseline test of the validation features we care about. It's
  // probably not worth adding in every filter and field that we want to valid
  // in the API upfront, but as regressions occur, this is the place to add the
  // specific case.
  const std::string valid_bootstrap_text = R"EOF(
  node {}
  cluster_manager {}
  admin {
    access_log_path: "/dev/null"
    address {}
  }
  )EOF";
  envoy::api::v2::Bootstrap valid_bootstrap;
  if (!google::protobuf::TextFormat::ParseFromString(valid_bootstrap_text, &valid_bootstrap)) {
    std::cerr << "Unable to parse text proto: " << valid_bootstrap_text << std::endl;
    exit(EXIT_FAILURE);
  }
  TestCase<envoy::api::v2::Bootstrap>{invalid_bootstrap, valid_bootstrap}.run();

  exit(EXIT_SUCCESS);
}
