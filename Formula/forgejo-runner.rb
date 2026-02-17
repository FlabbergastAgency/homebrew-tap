class ForgejoRunner < Formula
  desc "Self-hosted runner for Forgejo Actions (macOS native)"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v12.6.2.tar.gz"
  sha256 "1dc29651a447678ddb992b7a00d6359f56a31ace3d7f1893f5419b838291bbd9"
  license "GPL-3.0-or-later"
  revision 2 # Increment this to force Machine 2 to see your changes!

  depends_on "go" => :build

  def install
    # Build the binary
    system "go", "build", *std_go_args(output: bin/"forgejo-runner")

    # Ensure the config and working directories exist
    (etc/"forgejo-runner").mkpath
    (var/"forgejo-runner").mkpath
  end

  service do
    run [opt_bin/"forgejo-runner", "daemon", "--config", etc/"forgejo-runner/config.yaml"]
    keep_alive true
    log_path var/"log/forgejo-runner.log"
    error_log_path var/"log/forgejo-runner.err.log" # Separate error log for easier debugging
    working_dir var/"forgejo-runner"
  end

  def caveats
    <<~EOS
      1. Register your runner (run this from any folder):
         forgejo-runner register --instance [URL] --token [TOKEN]

      2. Move the generated registration file to the service's working directory:
         mv .runner #{var}/forgejo-runner/

      3. Generate the required configuration file:
         forgejo-runner generate-config > #{etc}/forgejo-runner/config.yaml

      4. Start the service:
         brew services restart forgejo-runner
    EOS
  end
end