# Changelog

## 0.1.0 (2026-10-05)


### Features

* **First release.** Runs horopter's ingress and egress daemons against an existing Postgres, whose URI comes from a Secret you name (`database.existingSecret`, key `uri`, as CloudNativePG generates it). A pre-install and pre-upgrade hook runs the migrations. Optional resources, all off by default: a ServiceMonitor scraping both daemons, and egress exposed through either an HTTPRoute or an Ingress. Pods run non-root on a read-only filesystem with every capability dropped. The chart refuses image tags below `v0.2.0`, and defaults to horopter `v0.3.0` ([#1](https://github.com/horopter-dev/helm-charts/pull/1))
