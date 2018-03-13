# JWT Authentication envoy HTTP filter config

## Overview

1. The proto file in this folder defines a HTTP filter config for "jwt_authn" filter. This filter will be implemented in Envoy.

2. This filter will verify the JWT in the HTTP request as:
    - The signature should be valid
    - JWT should not be expired
    - Issuer (and audience) should be valid and are specified in the config.

3. In order to verify JWT, [JWKS](https://tools.ietf.org/html/rfc7517#appendix-A) can be fetched from a remote server by the filter. JWKS will be cached by Envoy.
    
3. If JWT is valid, the user is authenticated and the request will be passed to the backend server. Verified JWT payload will be added as a new HTTP header to be passed to the backend server, and original JWT will be removed. If JWT is not valid, the request will be rejected with an error message.
   
## The locations to extract JWT

JWT will be extracted from the HTTP headers or query parameters. If not extract location specified, the default location is the HTTP header:
```
Authorization: Bearer <token>
```
The next location is in the query parameter as:
```
?access_token=<TOKEN>
```

2. The custom location is desired, "jwt_headers" and "jwt_params" can be used to specify custom location to extract JWT. Please see config proto for detail.

## HTTP header to pass sucessfully verified JWT

If a JWT has been suceessfully verified, its payload will be passed to the backend in the new HTTP header "sec-istio-auth-userinfo". Its value is base64 encoded JSON.

## Fetch remote JWKS.

JWKS are needed to verify JWT.  They can be fetched from remote servers by HTTP/HTTPS.  Before Envoy can support dynamic cluster, users need to create a dedicated cluster in the "cluster_manager" Envoy config section for each remote JWKS server and specify jwks_uri in the format as:
```
jwks_uri: JWKS_URI?cluster=cluster_name
```

## Example config.

Here is the cluster config example:
```
"clusters": [
  {
    "name": "jwks_cluster",
    "connect_timeout_ms": 5000,
    "type": "strict_dns",
    "circuit_breakers": {
     "default": {
      "max_pending_requests": 10000,
      "max_requests": 10000
     }
    },
    "lb_type": "round_robin",
    "hosts": [
      {
        "url": "tcp://account.example.com:8080"
      }
    ]
  },
  ...
]
```

Here is the Envoy HTTP filter config example:
```
 "filters": [
  {
    "type": "decoder",
    "name": "jwt_authn",
    "config": {
       "jwt_rules": [
         {
           "issuer": "628645741881-noabiu23f5a8m8ovd8ucv698lj78vv0l@developer.gserviceaccount.com",
           "jwks_uri": "http://localhost:8081/?cluster=jwks_cluster",
         }
       ]
    }
  },
  ...
  ]
```
