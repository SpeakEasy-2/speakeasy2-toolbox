# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Pin libSE2 to tagged release v0.1.8 from development branch.

### Fixed

- Edgemap was always assuming graph's were in a MATLAB builtin graph type form.
- Add check for graph weights before passing into SE2.

## [0.1.4] 2024-09-06

### Added

- Ability to interrupt SE2 and ordering.
- Dependency on igraph toolbox to enable use of igutils for argument validation and parsing.

### Changed

- Update to libspeakeasy2 0.1.7 (performance improvements and tracks memory to reduce leaks if methods stopped early).

## [0.1.3] 2024-07-16

### Added

- `knnGraph` function.

### Fixed

- Allow `edgemap` to handle negative numbers.

## [0.1.2] 2024-04-01

### Added

- SE2 namespace.
- Subclustering.
- Hierarchical ordering.
- Order by degree within communities.

### Changed

- Update to matlab-igraph 0.1.13 (changes to how datatypes are converted).
- Update to libspeakeasy2 0.1.2 (adds subclustering).

### Fixed

- Calling version from speakeasy2.

## [0.1.1] 2024-03-16

### Added

- SpeakEasy2.
- Node ordering.
- GitHub actions for building toolbox.
- Getting Started.
