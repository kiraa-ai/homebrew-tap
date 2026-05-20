# kiraa-ai/homebrew-tap

Homebrew formulae for [kiraa-ai](https://github.com/kiraa-ai) command-line tools.

## What's here

| Formula | Description | Upstream |
|---|---|---|
| `swiftpandas` | Fast CSV transformation tool with resident-memory daemon | [kiraa-ai/kiraa-swift-pandas](https://github.com/kiraa-ai/kiraa-swift-pandas) |

## Install

### swiftpandas

```bash
brew install kiraa-ai/tap/swiftpandas

# Or two-step if you prefer:
brew tap kiraa-ai/tap
brew install swiftpandas
```

Start the resident-memory daemon (auto-restart on login, survives reboots):

```bash
brew services start swiftpandas
swiftpandas load sales.csv --name sales
swiftpandas pipe --from sales --name big -c "filter(revenue > 10000)"
swiftpandas server status        # pid, uptime, dataframes, memory
brew services stop  swiftpandas
```

See [docs/SERVER.md](https://github.com/kiraa-ai/kiraa-swift-pandas/blob/main/docs/SERVER.md) for the full CLI surface and [docs/INSTALL.md](https://github.com/kiraa-ai/kiraa-swift-pandas/blob/main/docs/INSTALL.md) for non-Homebrew install paths (source build, SwiftPM library, GitHub Releases ZIP).

## Build from source

If no stable release is available yet (or you want bleeding-edge):

```bash
brew install --HEAD kiraa-ai/tap/swiftpandas
```

This clones the `main` branch of `kiraa-swift-pandas`, runs `swift build -c release --arch arm64 --arch x86_64`, and installs the resulting universal binary. Requires Xcode command-line tools.

## How the formula stays current

`Formula/swiftpandas.rb` is **auto-updated** by a GitHub Actions workflow in [kiraa-swift-pandas/.github/workflows/release.yml](https://github.com/kiraa-ai/kiraa-swift-pandas/blob/main/.github/workflows/release.yml). Whenever a release is published with a `swiftpandas-*-macos*-universal.zip` asset attached, the workflow:

1. Downloads the asset.
2. Computes its SHA-256.
3. Rewrites this tap's `Formula/swiftpandas.rb` (only the `url`, `sha256`, and `version` lines).
4. Commits to `main`.

Do not hand-edit those three fields in the formula — your changes will be clobbered on the next release.

## Security

- Binaries distributed via the formula's `url` field are **signed** with Developer ID `ERROL J BRANDT (VVH38B9225)` and **Apple-notarized**. Verify manually if you want:

  ```bash
  codesign -dv --verbose=2 $(brew --prefix)/bin/swiftpandas
  spctl -a -vv               $(brew --prefix)/bin/swiftpandas
  shasum -a 256              $(brew --prefix)/bin/swiftpandas
  ```

- The formula's `install` block also runs `xattr -dr com.apple.quarantine` as a belt-and-suspenders measure; the notarization staple itself is preserved by the Homebrew copy.

## Reporting issues

- **Tool bugs**: open them on [kiraa-ai/kiraa-swift-pandas](https://github.com/kiraa-ai/kiraa-swift-pandas/issues).
- **Formula / installation bugs**: open them here (this repo).

## License

Apache 2.0 — same as the swiftpandas tool itself.
