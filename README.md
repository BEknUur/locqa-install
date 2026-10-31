# locqa installer

Installs the `locqa` CLI (quality checks for Flutter ARB localizations) on Linux and macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/BEknUur/locqa-install/main/install.sh | sh
```

The script installs [uv](https://docs.astral.sh/uv/) if it's missing, then runs
`uv tool install locqa`. Run it again to upgrade. Options:

- `LOCQA_VERSION=0.3.0` pins a release.
- `LOCQA_INDEX=testpypi` installs from TestPyPI (dry runs only).

On Windows, or if you prefer: `uv tool install locqa` or `pipx install locqa`.
