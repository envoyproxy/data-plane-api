## NOTE

The list of filters here is incomplete. There are no proto specifications for Fault filter, Redis filter, CORS filter, etc.
These specifications will be added in the near future. In the interim, you can still supply plain JSON configuration objects
for these missing filters by setting the `"deprecated_v1"` field to true in the filter's configuration. For example,

```json
{ 
 "name": "envoy.rate_limit",
  "config": { 
    "deprecated_v1": true,
     "value": { 
       "domain": "some_domain",
        "timeout_ms": 500 
       }
    }
 }
```
