# Contributing

## Before you open a pull request

`mise install` provides helm, kubeconform, kind and task, and `task setup` installs the
helm-unittest plugin. The hooks run under [prek][prek], which `mise.toml` does not pin, so
install it separately. Install the hooks once, then run the checks:

    prek install
    task check

`task check` runs `helm lint --strict`, the unit tests, and a render with every optional
resource on, schema-checked.

## Pull requests and releases

Pull requests are squash-merged; it is the only merge button. The squash commit takes the
**pull request's title** as its subject, and that title is the only line Release Please reads,
so give it a [Conventional Commits][cc] type and write it as the changelog entry it will
become. Nothing checks the title, so check it yourself before merging:

    fix(horopter): keep generated names within 63 characters
    feat(horopter): add an optional HTTPRoute for egress

The type picks the chart's next version. While a chart is below 1.0, `feat:` and a breaking
change (`!` or a `BREAKING CHANGE:` footer) bump the minor version and `fix:` the patch.
`docs:`, `chore:`, `ci:`, `test:`, `build:` and `style:` stay out of the changelog.

Because each pull request becomes one changelog entry under one type, keep pull requests
small and open them often:

- **One user-visible change per pull request.** A change that is both a fix and a feature is
  two pull requests; squashed together, one of them disappears from the changelog.
- **Open it when that change is ready**, rather than carrying the next change on the same
  branch. Review fixes for the change belong in its pull request; they squash away.

Release Please keeps a release pull request open per chart. Merging it tags the release as
`<chart>-<version>`, such as `horopter-0.1.0`.

[cc]: https://www.conventionalcommits.org/
[prek]: https://github.com/j178/prek
