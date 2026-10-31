#!/bin/sh
# Installs the locqa CLI with uv: curl -fsSL <url>/install.sh | sh
# LOCQA_VERSION pins a release. LOCQA_PACKAGE overrides the spec (e.g. a local wheel).
# LOCQA_INDEX=testpypi is for dry runs before the first PyPI release: PyPI is searched first.
set -eu

UV_VERSION=0.9.2

main() {
    case "$(uname -s)" in
        Linux | Darwin) ;;
        *)
            echo "locqa: this installer supports Linux and macOS; run: uv tool install locqa" >&2
            exit 1
            ;;
    esac

    user_path=$PATH
    if ! command -v uv >/dev/null 2>&1; then
        echo "Installing uv $UV_VERSION..."
        curl -LsSf "https://astral.sh/uv/$UV_VERSION/install.sh" | sh
        PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
        if ! command -v uv >/dev/null 2>&1; then
            echo "locqa: uv install failed; see https://docs.astral.sh/uv/" >&2
            exit 1
        fi
    fi

    package=${LOCQA_PACKAGE:-locqa${LOCQA_VERSION:+==$LOCQA_VERSION}}
    set -- --python 3.12 --upgrade
    if [ "${LOCQA_INDEX:-}" = testpypi ]; then
        set -- "$@" --index https://pypi.org/simple/ --default-index https://test.pypi.org/simple/
    fi
    uv tool install "$@" "$package"

    bin_dir=$(uv tool dir --bin)
    case ":$user_path:" in
        *":$bin_dir:"*) ;;
        *) echo "Add $bin_dir to PATH: run 'uv tool update-shell' and open a new terminal." ;;
    esac
    "$bin_dir/locqa" --version
}

main
