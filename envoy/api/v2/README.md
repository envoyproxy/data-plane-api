Protocol buffer definitions for core API messages.

Package group `//envoy/api/v2:friends` enumerates all consumers of the core API
messages. That includes package envoy.api.v2 itself, which contains several xDS
definitions. Default visibility for all core definitions should be set to
`//envoy/api/v2:friends`.

Additionally, packages envoy.api.v2.core and envoy.api.v2.auth are also
consumed throughout the remaining core API packages, but not by each other.
