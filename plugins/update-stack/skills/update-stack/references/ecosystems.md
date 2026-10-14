# Ecosystem references

The update skill works for any stack. This file lists where each ecosystem pins versions and where
to find its latest release. When a repo uses an ecosystem that isn't here, work it out from the
ecosystem's documentation, then add a section with the same parts.

## JavaScript and TypeScript (Node)

- Versions are pinned in `package.json`, the lockfile, `packageManager`, `engines`, `.nvmrc` and
  `.node-version`.
- The latest release comes from the npm registry, such as `npm view <package> version`.

## Python

- Versions are pinned in `pyproject.toml`, `requirements*.txt`, the lockfile and `.python-version`.
- The latest release comes from PyPI's JSON at `https://pypi.org/pypi/<package>/json`.

## Java and Kotlin

- Versions are pinned in `pom.xml`, `build.gradle*`, `gradle/libs.versions.toml`, the toolchain
  block, the compiler `release` flag, `gradle-wrapper.properties` and `.mvn/wrapper`.
- The latest release comes from Maven Central's `maven-metadata.xml`. Gradle plugins come from the
  Gradle plugin portal.

## Go

- Versions are pinned in `go.mod`, including its `go` and `toolchain` lines.
- The latest release comes from the Go module proxy, such as `go list -m -versions <module>`.

## Rust

- Versions are pinned in `Cargo.toml`, `rust-toolchain*` and `rust-version`.
- The latest release comes from crates.io.

## Ruby

- Versions are pinned in `Gemfile`, `Gemfile.lock` and `.ruby-version`.
- The latest release comes from RubyGems.

## Shared by every stack

- Runtime versions may also sit in `.tool-versions`.
- CI pins action refs, such as `uses: owner/repo@vN`, and runtime versions in setup steps. The
  latest action release comes from GitHub's `releases/latest`.
- Containers pin `FROM` lines and compose images. The latest tags come from the official image
  registry.
