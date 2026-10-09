# Changelog

## [0.4.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.3.2...horopter-0.4.0) (2026-10-09)


### Features

* **horopter:** default to horopter v0.7.2 ([#13](https://github.com/horopter-dev/helm-charts/issues/13)) ([5967c18](https://github.com/horopter-dev/helm-charts/commit/5967c183fb2a51670473cc3786e424ce044346b4))

## [0.3.2](https://github.com/horopter-dev/helm-charts/compare/horopter-0.3.1...horopter-0.3.2) (2026-10-08)


### Bug Fixes

* **horopter:** default to horopter v0.7.1 ([#10](https://github.com/horopter-dev/helm-charts/issues/10)) ([c0f870c](https://github.com/horopter-dev/helm-charts/commit/c0f870c2cd7d453277d2b73b82c17df36cc6c836))

## [0.3.1](https://github.com/horopter-dev/helm-charts/compare/horopter-0.3.0...horopter-0.3.1) (2026-10-08)


### Bug Fixes

* **horopter:** request cpu and memory for both daemons by default ([#8](https://github.com/horopter-dev/helm-charts/issues/8)) ([8ca6a4d](https://github.com/horopter-dev/helm-charts/commit/8ca6a4d7f56d8ebb4657f9a64ad1bb78fbc30629))

## [0.3.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.2.0...horopter-0.3.0) (2026-10-06)


### Features

* **horopter:** default to horopter v0.7.0 ([#6](https://github.com/horopter-dev/helm-charts/issues/6)) ([274e71b](https://github.com/horopter-dev/helm-charts/commit/274e71b9998597dbdb82c82ed6b4d49a631eb678))

## [0.2.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.1.0...horopter-0.2.0) (2026-10-06)


### Features

* **horopter:** default to horopter v0.6.0 ([#4](https://github.com/horopter-dev/helm-charts/issues/4)) ([e8ce736](https://github.com/horopter-dev/helm-charts/commit/e8ce73650b445c2a932711ba0a96ee90f81c176c))

## 0.1.0 (2026-10-05)


### Features

* **First release.** Runs horopter's ingress and egress daemons against an existing Postgres, whose URI comes from a Secret you name (`database.existingSecret`, key `uri`, as CloudNativePG generates it). A pre-install and pre-upgrade hook runs the migrations. Optional resources, all off by default: a ServiceMonitor scraping both daemons, and egress exposed through either an HTTPRoute or an Ingress. Pods run non-root on a read-only filesystem with every capability dropped. The chart refuses image tags below `v0.2.0`, and defaults to horopter `v0.3.0` ([#1](https://github.com/horopter-dev/helm-charts/pull/1))
