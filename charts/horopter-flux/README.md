# horopter-flux

Installs `horopter-flux` beside Flux. It watches GitRepositories, Kustomizations, HelmReleases
and their Events read-only, and records every commit Flux applies and every HelmRelease rollout
as a Horopter change. Nothing is configured per release.

## Install

Issue one producer key per cluster, with no subject pattern, and put it in a Secret in the
namespace you install into. The chart creates no Secret.

    horoctl admin keys issue --dsn "$DATABASE_URL" --tenant <tenant-id> --role producer \
      --source flux-<cluster>
    kubectl create secret generic horopter-flux --namespace flux-system \
      --from-literal=key="$KEY"

Then install the chart against Horopter's ingress:

<!-- x-release-please-start-version -->

    helm install horopter-flux oci://ghcr.io/horopter-dev/charts/horopter-flux \
      --version 0.6.0 --namespace flux-system \
      --set ingress.url=http://horopter-ingress.horopter.svc.cluster.local:8080 \
      --set ingress.existingSecret=horopter-flux

<!-- x-release-please-end -->

Installed as a HelmRelease, its own rollouts are recorded too. To rotate the key, update the
Secret and restart the pod.

## Access

One replica, under its own ServiceAccount, bound to a ClusterRole that grants `get`, `list` and
`watch` on `gitrepositories`, `kustomizations`, `helmreleases` and core `events`, and `get` on
the `kube-system` Namespace, whose uid prefixes every idempotency key. It reads no Secrets and
writes nothing to the cluster.

## Values

| value | default | meaning |
| --- | --- | --- |
| `image.registry` | `ghcr.io/horopter-dev` | registry holding `horopter-flux` |
| `image.tag` | the chart's `appVersion` | a tag, or a `sha256:` digest |
| `image.pullPolicy` | `IfNotPresent` | |
| `imagePullSecrets` | `[]` | existing pull Secrets |
| `ingress.url` | — (required) | Horopter ingress's base URL |
| `ingress.existingSecret` | — (required) | Secret holding the producer key |
| `ingress.key` | `key` | key in that Secret |
| `resources` | requests 10m CPU, 64Mi | no limits |
