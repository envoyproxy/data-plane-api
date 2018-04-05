Role Based Access Control (RBAC) provides service-level and method-level access control for a service.
It features:
* Simple Role-Based semantics.
* service-to-service and endUser-to-service authorization.
* Allows users to apply control on any attributes, which provides a lot of flexibility.

## Architecture Overview

The typical configuration flow of RBAC has three steps:

1. The user enters RBAC policies into a configuration store.
2. The Control Plane fetches RBAC policies and distributes them to Envoy proxies.
3. An Envoy proxy caches the RBAC policies, and the policies will be used for access control at runtime.

The Envoy proxy runs an RBAC engine, which is implemented as a C++ library. The RBAC engine authorizes
requests at runtime. When a request comes, the RBAC engine evaluates the request context, which is expressed
as a bag of attributes, against the RBAC policies, and returns the authorization result (ALLOW or DENY).

## Attributes

Attributes are the set of name-value pairs that describe the environment and the requests. The request
context can be expressed using [a bag of attributes](envoy_api_msg_service.auth.v2alpha.AttributeContext).
The attributes are used by RBAC engine (and the external authorization engine) to do access control,
and can potentially be used by any other modules that consumes request context.

Some examples of the attributes are:
```
  source.principal (string)
  destination.principal (string)
  request.method (string)
  request.headers (string map)
```

## User-Facing RBAC Policies

The RBAC policies have ServiceRole and ServiceRoleBinding objects.
* ServiceRole defines a role for access to services.
* ServiceRoleBinding grants a role to subjects (e.g., a user, a group, a service).

The storage of ServiceRole and ServiceRoleBinding objects are platform specific. For example,
 In [Istio](https://istio.io/docs/concepts/security/rbac.html), they are stored as [Kubernetes
 CustomResourceDefinition (CRD)](https://kubernetes.io/docs/concepts/api-extension/custom-resources/)
 objects. In the following document, we will see ServiceRole and ServiceRoleBinding examples
 expressed in Kubernetes CRD format.

`rbac.proto` defines the protos for user-facing RBAC policies.

### ServiceRole

A ServiceRole specification includes a list of rules (permissions). Each rule has
the following standard fields:
 * services: a list of services.
 * verbs: HTTP verbs. In the case of gRPC, this field is ignored because the value is always
 "POST".
 * paths: HTTP paths or gRPC methods. Note that gRPC methods should be
   presented in the form of "packageName.serviceName/methodName".

Here is an example of a ServiceRole "service-admin", which has full access to all services.

```
  kind: ServiceRole
  metadata:
    name: service-admin
  spec:
    rules:
    - services: [simple:"*"]
      verbs: ["*"]
```

Here is another role "product-viewer", which has read ("GET" and "HEAD") access to service that has prefix
"products".

```
  kind: ServiceRole
  metadata:
    name: products-viewer
  spec:
    rules:
    - services: [prefix:"products"]
      verbs: ["GET", "HEAD"]
```

In ServiceRole, the combination of ”services”+”paths”+”methods” defines “how a service (services) is
allowed to be accessed”. In some situations, you may need to specify additional constraints that a
rule applies to. For example, a rule may only applies to a certain “version” of a service, or only
applies to services that are labeled “foo”. You can easily specify them in the "constraints" section.
The `key` of a constraint is the name of an attribute. The `values` specifies the allowed values for
the given attribute.

For example, you may add a "constraint" to the above "product-viewer" role that the service version
must be "v1" or "v2".
```
  kind: ServiceRole
  metadata:
    name: products-viewer
  spec:
    rules:
    - services: [prefix:"products"]
      verbs: ["GET", "HEAD"]
      constraints:
      - key: request.headers["version"]
        values: [simple:"v1", simple:"v2"]
```

### ServiceRoleBinding

A ServiceRoleBinding specification includes two parts:
 * "role_ref" refers to a ServiceRole object.
 * A list of "subjects" that are assigned the roles.

 A subject can be a "user" or a "group", or represented with a set of attributes. Specifically,
 "user" is mapped to "source.principal" attribute. "group" is currently undefined. It is reserved
 to be used in the future.

 Below is an example of ServiceRoleBinding object "test-binding-products", which binds two
 subjects to ServiceRole "product-viewer":
   * User (service account) "cluster.local/ns/default/sa/bookinfo-reviews"
   * Service "reviews.default.svc.cluster.local" at version "v1".

```
     kind: ServiceRoleBinding
     metadata:
       name: test-binding-products
     spec:
       subjects:
       - user: cluster.local/ns/default/sa/bookinfo-reviews
       - attributes:
           source.service: "reviews.default.svc.cluster.local"
           source.labels["version"]: "v1"
       role_ref:
         name: "products-viewer"
```

The control plane processes the RBAC policies and distributes them to the Envoy proxies.

## RBAC Filter Configuration

RBAC policies are passed from the control plane to Envoy proxies in the original ServiceRole/ServiceRoleBinding
specification. The RBAC policies are distributed to Envoy in the filter configuration via Listerner Discovery
 Service or Route Discovery Service. Note that only the RBAC policies that apply to the target services will be
 in the filter configuration.

 RBAC filter configuration contains a list of ServicePolicies. Each ServicePolicy contains RBAC policies
 for a single service. A ServicePolicy includes a list of ServiceRoles specification, and for each
  ServiceRole, the associated ServiceRoleBindings. The ServicePolicies are used by the RBAC engine running
  on an Envoy proxy to do access control at runtime.

Here is an example of RBAC filter configuration, which contains policies for a single service.

```
   "products.default.svc.cluster.local":
     policies:
       "service-admin":
         spec:
           rules:
           - services: [simple:“*”]
             verbs: [“*”]
         bindings:
           "bind-service-admin":
             subjects:
             - user: “cluster.local/ns/default/sa/admin”
       "product-viewer":
         spec:
           rules:
           - services: [prefix:“products”]
             paths: [prefix:“/products”, suffix:“/reviews”]
             verbs: [“GET”, “HEAD”]
         bindings:
           "bind-product-viewer":
             subjects:
             - user: “alice@yahoo.com”
```

 `local_rbac.proto` defines the protos for RBAC filter configuration.
