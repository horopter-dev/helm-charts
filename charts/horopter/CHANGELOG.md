# Changelog

## [0.9.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.8.0...horopter-0.9.0) (2026-10-13)


### Features

* **horopter:** default to horopter v0.14.0 ([#36](https://github.com/horopter-dev/helm-charts/issues/36)) ([f98ecaf](https://github.com/horopter-dev/helm-charts/commit/f98ecaf738820a2f80bb05f57ce09d5dd25e1746))

## [0.8.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.7.0...horopter-0.8.0) (2026-10-12)


### ⚠ BREAKING CHANGES

* **horopter:** values the chart does not define, which it previously ignored, now fail the install.

### Features

* **horopter:** expose the ingress daemon through an HTTPRoute or Ingress ([#31](https://github.com/horopter-dev/helm-charts/issues/31)) ([3a6417f](https://github.com/horopter-dev/helm-charts/commit/3a6417f4e123a2f8dc5b01bb21a20897a476e8e9))
* **horopter:** print each daemon's URL and exposure after install ([#33](https://github.com/horopter-dev/helm-charts/issues/33)) ([c10262d](https://github.com/horopter-dev/helm-charts/commit/c10262d0754f26b6013b445cc3ce8a08d8cc02d5))
* **horopter:** refuse unknown and mistyped values ([#34](https://github.com/horopter-dev/helm-charts/issues/34)) ([54b48da](https://github.com/horopter-dev/helm-charts/commit/54b48da5f00ddc7d0cd68136ad6bffc1d11f05c5))

## [0.7.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.6.0...horopter-0.7.0) (2026-10-12)


### Features

* **horopter:** default to horopter v0.11.2 ([#26](https://github.com/horopter-dev/helm-charts/issues/26)) ([b1e8242](https://github.com/horopter-dev/helm-charts/commit/b1e8242f93572539a1972c288a117fbefc8d0431))
* **horopter:** default to horopter v0.13.0 ([#29](https://github.com/horopter-dev/helm-charts/issues/29)) ([38f9622](https://github.com/horopter-dev/helm-charts/commit/38f9622025012faeef19ee4e5c440ae06b8ba1d2))

## [0.6.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.5.0...horopter-0.6.0) (2026-10-12)


### Features

* **horopter:** default to horopter v0.11.1 ([#22](https://github.com/horopter-dev/helm-charts/issues/22)) ([83fee08](https://github.com/horopter-dev/helm-charts/commit/83fee08343545caba5a8cba3cef2a88e92f02108))

## [0.5.0](https://github.com/horopter-dev/helm-charts/compare/horopter-0.4.0...horopter-0.5.0) (2026-10-10)


### Features

* **horopter:** default to horopter [v0.8.0](https://github.com/horopter-dev/horopter/releases/tag/v0.8.0). That release adds `horopter-flux`, which this chart does not run: install it with the new `horopter-flux` chart. For the ingress and egress daemons it brings only minor and patch dependency updates, and no migration ([#19](https://github.com/horopter-dev/helm-charts/issues/19)) ([3d9e432](https://github.com/horopter-dev/helm-charts/commit/3d9e4323289ba52b28e0e2793a7be0fc9cce6d63))

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
