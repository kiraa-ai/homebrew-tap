# frozen_string_literal: true

# swiftpandas — fast CSV transformation tool with resident-memory daemon
#
# This formula is auto-updated by the release.yml workflow in
# kiraa-ai/kiraa-swift-pandas whenever a new release is published. The
# `url`, `sha256`, and `version` fields below are rewritten by that
# workflow; do NOT edit them by hand or your change will be clobbered
# on the next release.
#
# Manual install while we wait for the first auto-update:
#   brew tap kiraa-ai/tap
#   brew install --HEAD swiftpandas       # builds from source on `main`
#
# Once a release with the CLI ZIP exists:
#   brew install kiraa-ai/tap/swiftpandas
#   brew services start swiftpandas        # daemon up now + at login
class Swiftpandas < Formula
  desc "Fast CSV transformation tool with resident-memory daemon"
  homepage "https://github.com/kiraa-ai/kiraa-swift-pandas"
  license "Apache-2.0"

  # ── Stable release ────────────────────────────────────────────────────
  # PLACEHOLDER: the release workflow in kiraa-swift-pandas rewrites these
  # three fields when a tagged release with a CLI ZIP is published. Until
  # then, `brew install kiraa-ai/tap/swiftpandas` will fail with a 404.
  # Use `--HEAD` to build from source against `main` instead.
  url     "https://github.com/kiraa-ai/kiraa-swift-pandas/releases/download/PENDING/swiftpandas-PENDING-macosXX-universal.zip"
  sha256  "0000000000000000000000000000000000000000000000000000000000000000"
  version "0.0.0"

  # ── Head (build from source) ──────────────────────────────────────────
  head "https://github.com/kiraa-ai/kiraa-swift-pandas.git", branch: "main"

  depends_on macos: :ventura
  depends_on xcode: ["15.0", :build] => :head

  def install
    if build.head?
      # HEAD path: build from source. Requires Xcode CLT.
      system "swift", "build", "-c", "release", "--arch", "arm64", "--arch", "x86_64"
      bin.install ".build/apple/Products/Release/swiftpandas"
    else
      # Bottle path: signed + notarized binary downloaded as a ZIP. Strip
      # quarantine in case Gatekeeper attached it; the signature itself is
      # preserved.
      bin.install "swiftpandas"
      system "xattr", "-dr", "com.apple.quarantine", bin/"swiftpandas"
    end
  end

  # ── brew services integration ─────────────────────────────────────────
  # Translates to a LaunchAgent plist under
  # $(brew --prefix)/etc/LaunchAgents/. Daemon survives reboots and
  # restarts on crash. Runtime files live under
  # $(brew --prefix)/var/swiftpandas/ so they don't collide with users
  # running `swiftpandas server start` manually against the default
  # ~/.swiftpandas/ path.
  service do
    run [opt_bin/"swiftpandas", "server", "start", "--foreground"]
    keep_alive true
    working_dir var
    log_path        var/"log/swiftpandas.log"
    error_log_path  var/"log/swiftpandas.err"
    environment_variables(
      SWIFTPANDAS_RUNTIME_DIR: var/"swiftpandas",
    )
  end

  test do
    # `swiftpandas --help` should mention the binary name and at least one
    # subcommand surface. Doesn't require the daemon to be running.
    output = shell_output("#{bin}/swiftpandas --help")
    assert_match "swiftpandas", output
    assert_match "server",      output
  end
end
