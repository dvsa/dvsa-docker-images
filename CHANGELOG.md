# Changelog

## [0.8.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.7.0...v0.8.0) (2025-02-17)


### Features

* add logstash image ([#53](https://github.com/dvsa/dvsa-docker-images/issues/53)) ([dd63dc3](https://github.com/dvsa/dvsa-docker-images/commit/dd63dc3ea57d134247a46ec2982894f36f425a3d))
* create repo action ([#56](https://github.com/dvsa/dvsa-docker-images/issues/56)) ([ac20cb9](https://github.com/dvsa/dvsa-docker-images/commit/ac20cb91b9045d81837ee24bec8d2a36512ab651))


### Bug Fixes

* update trivy action ([#54](https://github.com/dvsa/dvsa-docker-images/issues/54)) ([c8552a9](https://github.com/dvsa/dvsa-docker-images/commit/c8552a9ed24a36812223a5ac8c59032b7dfeed2d))

## [0.7.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.6.0...v0.7.0) (2024-09-23)


### Features

* BL-17333 - Dockerfile and resources for Apache PHP 8.2, base image only ([#42](https://github.com/dvsa/dvsa-docker-images/issues/42)) ([8545e46](https://github.com/dvsa/dvsa-docker-images/commit/8545e467e0da5e22bc31f3fc4408332c18f0c3dc))


### Bug Fixes

* remove duplicate FPM config ([#52](https://github.com/dvsa/dvsa-docker-images/issues/52)) ([cbbe46b](https://github.com/dvsa/dvsa-docker-images/commit/cbbe46b2a5bb2a388bf293aa1c1c4cfa3ee031a9))
* Remove PHP CLI 8.0 from workflows ([#51](https://github.com/dvsa/dvsa-docker-images/issues/51)) ([c6dff15](https://github.com/dvsa/dvsa-docker-images/commit/c6dff15220fa77b4c10855c983fded1ab2adf433))

## [0.6.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.5.0...v0.6.0) (2024-08-05)


### Features

* remove PHP 7.4 & 8.0 ([#44](https://github.com/dvsa/dvsa-docker-images/issues/44)) ([35c5d95](https://github.com/dvsa/dvsa-docker-images/commit/35c5d9544d5f64fb0803632014510ef42fa1515a))

## [0.5.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.4.0...v0.5.0) (2024-07-11)


### Features

* bump Alpine version in PHP 8.2 & PHP 8.3 images ([#38](https://github.com/dvsa/dvsa-docker-images/issues/38)) ([c178d2a](https://github.com/dvsa/dvsa-docker-images/commit/c178d2a973857618f0b493ac235ef447873bbc05))

## [0.4.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.3.0...v0.4.0) (2024-05-09)


### Features

* refactor supervisord config to be extensible ([#27](https://github.com/dvsa/dvsa-docker-images/issues/27)) ([5f65792](https://github.com/dvsa/dvsa-docker-images/commit/5f657928996eae0e5e433b1b18213c889174eaa3))

## [0.3.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.2.0...v0.3.0) (2024-04-30)


### Features

* optimise Dockerfile and tweak logging levels ([#25](https://github.com/dvsa/dvsa-docker-images/issues/25)) ([928bc41](https://github.com/dvsa/dvsa-docker-images/commit/928bc41f256bcf5b7b544406e0ef6b5cf609f366))

## [0.2.0](https://github.com/dvsa/dvsa-docker-images/compare/v0.1.2...v0.2.0) (2024-04-26)


### Features

* add PHP 8.2/8.3 base images ([#22](https://github.com/dvsa/dvsa-docker-images/issues/22)) ([3f768ed](https://github.com/dvsa/dvsa-docker-images/commit/3f768edaa7e4786b625bca39a7a750d4baa92fde))


### Bug Fixes

* set `decorate_workers_output` to `no` ([#24](https://github.com/dvsa/dvsa-docker-images/issues/24)) ([a052aa3](https://github.com/dvsa/dvsa-docker-images/commit/a052aa311ac4dd323587b46c5ad403fb4a23c5a4))

## [0.1.2](https://github.com/dvsa/dvsa-docker-images/compare/v0.1.1...v0.1.2) (2024-04-18)


### Bug Fixes

* fix the CD workflow syntax ([#20](https://github.com/dvsa/dvsa-docker-images/issues/20)) ([8b6615c](https://github.com/dvsa/dvsa-docker-images/commit/8b6615cb48bd87f98f8b003fc7f6cc086a3c4a5f))

## [0.1.1](https://github.com/dvsa/dvsa-docker-images/compare/v0.1.0...v0.1.1) (2024-04-18)


### Bug Fixes

* fix CD release workflow ([#17](https://github.com/dvsa/dvsa-docker-images/issues/17)) ([3b2333d](https://github.com/dvsa/dvsa-docker-images/commit/3b2333d26373eb6aabbf66dc9c65419d7fa23e06))

## 0.1.0 (2024-04-18)


### Features

* add productionised base PHP-CLI 8.0 image ([#11](https://github.com/dvsa/dvsa-docker-images/issues/11)) ([d091336](https://github.com/dvsa/dvsa-docker-images/commit/d091336842280df96b8551c01a8d2d58392b1af2))
* create productionised base dockerfile ([#2](https://github.com/dvsa/dvsa-docker-images/issues/2)) ([d94000b](https://github.com/dvsa/dvsa-docker-images/commit/d94000b44af842665f3492c089b742dffc99f60f))
* mirror images to GHCR ([#14](https://github.com/dvsa/dvsa-docker-images/issues/14)) ([258d227](https://github.com/dvsa/dvsa-docker-images/commit/258d227a3a7a1d0a37cec1863323c2e52696894a))
* productionised base PHP-FPM 8.0 image ([#8](https://github.com/dvsa/dvsa-docker-images/issues/8)) ([640fcc4](https://github.com/dvsa/dvsa-docker-images/commit/640fcc441723ec632ba4bd5b664b10c7d3d56262))
* productionised base PHP-FPM 8.2 image ([#10](https://github.com/dvsa/dvsa-docker-images/issues/10)) ([69e5b74](https://github.com/dvsa/dvsa-docker-images/commit/69e5b747c8bb2c8720b6609b7a048287045e1947))


### Miscellaneous Chores

* release 0.1.0 ([#16](https://github.com/dvsa/dvsa-docker-images/issues/16)) ([a676210](https://github.com/dvsa/dvsa-docker-images/commit/a67621057f15b572c2f9b30639555f9f31d5a0a9))
