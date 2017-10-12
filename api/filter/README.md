## NOTE

The list of filters here is incomplete. There are no proto specifications for Fault filter, Redis filter, CORS filter, etc.
These specifications will be added in the near future. In the interim, you can still supply plain JSON configuration objects
for these missing filters by setting

```json
"deprecated_v1": true
```
in the JSON configuration for the filter. Today, this field is automatically set for missing filters.
