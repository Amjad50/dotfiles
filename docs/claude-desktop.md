# Claude Desktop on Fedora

`update-claude` downloads Anthropic's official **Linux** `.deb`, verifies it, and
packages its existing application files into a native RPM. It runs no Debian
maintainer scripts and applies no application patches.

It runs only on standard DNF-managed Fedora Linux, on x86_64 or aarch64.
Fedora Atomic/rpm-ostree systems and other distributions are rejected before
downloads or installation. Chezmoi installs the command on Fedora machines only.

Installed command: `~/.local/bin/update-claude`

```sh
update-claude              # install or update in one command
update-claude --check      # check without installing
update-claude --build-only # verify/download/build without sudo
update-claude --force      # rebuild and reinstall the current release
```

If Claude is absent, the same command installs it. Missing build tools are
installed automatically on the first normal run. `--check` and `--build-only`
do not install prerequisites or use sudo.

Only prerequisite installation and the final DNF install use sudo. Both resolve
dependencies from Fedora's `fedora` and `updates` repositories. No additional repository or background
update timer is installed. Existing sessions should be closed and reopened
after an update.

The verification chain is the fingerprint Anthropic publishes in its Linux
documentation → signed, unexpired `InRelease` → SHA256 of the package index →
SHA256 and size of the `.deb`. Both the primary key fingerprint and the actual
signature signer are checked. Older versions are not installed over newer ones.

RPM stripping and other build postprocessing are disabled. The RPM file digests
and symlink targets are compared with the extracted payload before installation.
The Chromium sandbox's original setuid permission is preserved. Fedora desktop
integration uses the MIME and search-provider files shipped in the official
package. Fedora supplies Cowork's QEMU, firmware, and virtiofsd dependencies.

Downloads, the generated RPM, provenance JSON, payload hashes, and build logs
are under `~/.cache/claude-desktop-rpm/`. The RPM is locally generated and
unsigned; its source `.deb` is authenticated through Anthropic's signed index.
Only local-package signature checking is disabled for its DNF transaction;
Fedora repository signature checking stays enabled.

Anthropic currently supports the desktop app on Ubuntu and Debian. This is a
local Fedora packaging adapter, not an Anthropic-supported Fedora release.

Chezmoi manages the command at `dot_local/bin/executable_update-claude`.
After applying your dotfiles on Fedora, run `update-claude` to install the app.

Remove the app with `sudo dnf remove claude-desktop`. Remove the updater by
deleting `~/.local/bin/update-claude`. Your Claude profile is separate at
`~/.config/Claude/`.
Official instructions and signing fingerprint:
https://code.claude.com/docs/en/desktop-linux
