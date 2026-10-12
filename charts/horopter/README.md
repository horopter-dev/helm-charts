# horopter

Installs Horopter's ingress and egress daemons against a Postgres you already run, and migrates
its schema before each install and upgrade.

## Install

<!-- x-release-please-start-version -->

    helm install horopter oci://ghcr.io/horopter-dev/charts/horopter \
      --version 0.7.0 \
      --set database.existingSecret=<secret holding the Postgres URI>

<!-- x-release-please-end -->

The chart creates no Secret. `database.existingSecret` must name a Secret whose `uri` key (or
`database.key`) holds the connection string; CloudNativePG's generated application Secret has
exactly that shape. Private images need `imagePullSecrets` naming an existing
`kubernetes.io/dockerconfigjson` Secret.

## Supported versions

The chart refuses to render an image tag below `v0.2.0`: earlier tags have no egress
authentication. A digest or a non-semver tag is not checked, so pinning one below the floor is
the installer's responsibility.

## Credentials

The workload holds no credentials, so the chart issues none. Issue them once with `horoctl`
against the same database:

    kubectl run horoctl --rm -it --restart=Never \
      --image=ghcr.io/horopter-dev/horoctl:<tag> \
      --overrides='{"spec":{"imagePullSecrets":[{"name":"<pull secret>"}],"containers":[{"name":"horoctl","image":"ghcr.io/horopter-dev/horoctl:<tag>","args":["admin","tenant","create","--display-name","<name>"],"env":[{"name":"DATABASE_URL","valueFrom":{"secretKeyRef":{"name":"<db secret>","key":"uri"}}}]}]}}'

Then `admin keys issue --tenant <id> --role producer --source <source> --locus <locus>`, and the
same with `--role reader`, by the same command with different `args`. Each key is printed once.
Do not use `horoctl admin bootstrap` outside development: its explicit-key flags are documented
as development only.

## Exposure

Both daemons get a ClusterIP Service. Each can also be exposed by a Gateway API `HTTPRoute`
(`<daemon>.httpRoute`: `parentRefs` required, `hostnames` optional) or an `Ingress`
(`<daemon>.kubernetesIngress`: `host` required, `className` and `tls` optional), at most one
per daemon. Ingress is the write endpoint, so expose it only for producers outside the
cluster, such as CI runners.

## Values

| value | default | meaning |
| --- | --- | --- |
| `image.registry` | `ghcr.io/horopter-dev` | registry holding `horopter-{ingress,egress,migrate}` |
| `image.tag` | the chart's `appVersion` | one tag for all three images |
| `imagePullSecrets` | `[]` | existing pull Secrets, on every pod |
| `database.existingSecret` | — (required) | Secret holding the Postgres URI |
| `database.key` | `uri` | key in that Secret |
| `telemetry.tracesEndpoint` | `""` | full OTLP/HTTP traces URL, e.g. `http://collector:4318/v1/traces`; empty disables tracing |
| `metrics.port` | `9464` | Prometheus scrape port, named `metrics` |
| `ingress.replicaCount`, `egress.replicaCount` | `1` | replicas per daemon |
| `ingress.resources`, `egress.resources` | requests 10m CPU, 32Mi | per daemon; no limits |
| `ingress.httpRoute.*`, `egress.httpRoute.*` | off | a Gateway API `HTTPRoute` to that daemon |
| `ingress.kubernetesIngress.*`, `egress.kubernetesIngress.*` | off | an `Ingress` to that daemon; not with its `httpRoute` |
| `serviceMonitor.enabled` | `false` | a `ServiceMonitor` over both daemons |
| `migrate.backoffLimit` | `0` | retries of the migrate Job |
| `migrate.activeDeadlineSeconds` | `600` | migrate Job timeout |
