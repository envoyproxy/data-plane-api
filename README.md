# Data plane API

This repository hosts the configuration and APIs that drive [Envoy](https://www.envoyproxy.io/). The
APIs are also in some cases used by other proxy solutions that aim to interoperate with management
systems and configuration generators that are built against this standard. Thus, we consider these a
set of *universal data plane* APIs. See [this](https://medium.com/@mattklein123/the-universal-data-plane-api-d15cec7a)
blog post for more information on the universal data plane concept.

Additionally, all of the documentation for the Envoy project is built directly from this repository.
This allows us to keep all of our documentation next to the configuration and APIs that derive it.

# Further reading

* [API overview](API_OVERVIEW.md)
* [XDS protocol overview](XDS_PROTOCOL.md)
* [Contributing guide](CONTRIBUTING.md)
