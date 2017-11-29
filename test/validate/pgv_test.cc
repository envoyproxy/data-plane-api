#include <iostream>
#include <cstdlib>

#include "test/validate/test.pb.validate.h"

// Basic protoc-gen-validate C++ validation header inclusion and Validate calls
// from data-plane-api.
// TODO(htuch): Switch to using real data-plane-api protos once we can support
// the required field types.
int main(int argc, char *argv[]) {
  {
    test::validate::Foo empty;

    std::string err;
    if (Validate(empty, &err)) {
      std::cout << "Unexpected successful validation of empty proto."
                << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  {
    test::validate::Foo non_empty;
    non_empty.mutable_baz();

    std::string err;
    if (!Validate(non_empty, &err)) {
      std::cout << "Unexpected failed validation of empty proto: " << err
                << std::endl;
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
