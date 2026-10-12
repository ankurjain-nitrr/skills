---
name: update-stack
description: Update every pinned version in a repo to its latest stable release (dependencies, build plugins, build-tool wrappers, CI actions, container base images, language runtime), keep each version identical everywhere it appears, and verify build, tests and images still work. Use for "update the stack", "bump dependencies", "upgrade versions" or "check for outdated versions".
---

# Update the stack

Bring every pinned version up to its latest stable release without changing the project's behavior.
If the repo has its own update skill or a `CLAUDE.md` section on versions, follow it; it overrides
this one where they differ.

## 1. Inventory what is pinned

Don't work from a remembered list: versions get added. Scan the repo for every pinned version:

- Build files and lockfiles: `package.json`, `pyproject.toml`, `requirements*.txt`, `go.mod`,
  `Cargo.toml`, `pom.xml`, `build.gradle*`, `gradle/libs.versions.toml`, `Gemfile`, and so on.
- Build plugins and build-tool wrappers (`gradle-wrapper.properties`, `.mvn/wrapper`,
  `packageManager` fields).
- Language runtime and toolchain: toolchain blocks, compiler release or target flags, `.nvmrc`,
  `.python-version`, `.tool-versions`, `engines`, `rust-toolchain*`.
- CI: action refs (`uses: owner/repo@vN`), runtime versions in setup steps, job images.
- Containers: `FROM` lines, compose images, and scripts or tests that assert a runtime version.
- Docs: install and setup snippets in READMEs that repeat any of the above.

Record each version and every file and line it appears in. A version repeated in several places
must stay identical in all of them.

Skip versions a BOM, platform or parent manages (e.g. a framework's dependency management); they
move with their parent. Don't add pins the project doesn't have.

## 2. Find the latest stable release

Ask the source of truth, not memory: the package registry's metadata (Maven Central
`maven-metadata.xml`, npm, PyPI JSON, crates.io, Go proxy, the Gradle plugin portal), the tool's own
release endpoint, GitHub `releases/latest` for actions, and the official image registry for tags.

- Stable means no alpha, beta, RC, milestone, snapshot, preview, nightly or EA builds.
- Metadata lists aren't always sorted; compare versions instead of taking the last entry.
- For the language runtime, move to the latest LTS when the project is on an LTS line; otherwise
  the latest release. Confirm the matching container image tags exist.
- For CI actions, use the major tag of the latest release and confirm the tag exists
  (`git ls-remote --tags https://github.com/<owner>/<repo> refs/tags/<tag>`).
- An artifact whose line has ended (its successor renamed or redesigned the API) stays on its last
  release. Moving to the successor is a migration; do it only when the user asks.

Before editing, show the user a table of old and new versions, flagging major bumps.

## 3. Plan by risk

- Run the full verification (step 5) once before changing anything, so you know what already fails.
- Patch and minor updates can go together. Do each major update on its own, after reading its
  release notes or migration guide for breaking changes: new minimum runtime, renamed modules or
  packages, removed APIs, changed defaults.
- Keep version-coupled pieces in lockstep: a runtime and its compiler or weaver, a library and its
  agent or plugin, a framework and its plugin.
- Stop and ask before anything that changes behavior for the project's users: raising the minimum
  runtime of a published library, changing public APIs, output formats or defaults.

## 4. Apply

- Update every occurrence from the inventory, then grep the repo for each old version to catch
  copies you missed.
- Regenerate rather than hand-edit generated files: build-tool wrappers (pin the distribution
  checksum the tool publishes, and check the wrapper jar against its published checksum),
  lockfiles (use the package manager).
- Verify the checksum of anything you download. If a JSON response holds several checksums, parse
  it rather than grepping.

## 5. Verify

Run on the runtime version the project now targets; everything must pass before committing.

- Clean build and the full test suite.
- Build outputs target the intended runtime (e.g. class-file major version, compiled target).
- Container images build, start, and pass any smoke test; check the runtime version inside them.
- Steps that guard behavior (generated code, weaving, codegen, snapshot tests) still produce the
  same results.

If the target runtime isn't installed, download it from its official source into a scratch
directory, verify its checksum, and point the build at it. Don't install it system-wide without
asking.

## 6. Commit and report

- Small commits, one area each: wrapper or build tool, dependencies, plugins or framework, CI,
  container images, docs.
- Each commit should build; when a change has to span areas (e.g. the runtime version in build
  files and CI), keep it in one commit.
- Don't push unless the user asks. If the devloop plugin is installed, run its `/devloop:readme-check` skill before pushing.
- Finish with a table of old and new versions, what was skipped and why, and the verification
  results.
