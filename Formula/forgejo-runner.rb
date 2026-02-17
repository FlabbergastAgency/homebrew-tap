class ForgejoRunner < Formula
  desc "Self-hosted runner for Forgejo Actions (macOS native)"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v12.6.2.tar.gz" # Update version as needed
  sha256 "1dc29651a447678ddb992b7a00d6359f56a31ace3d7f1893f5419b838291bbd9" # Use 'curl -L [url] | shasum -a 256'
  license "GPL-3.0-or-later"
  varsion 0.0.1
  revision 1

  depends_on "go" => :build

  def install
    # Compile the binary for Apple Silicon
    system "go", "build", "-o", bin/"forgejo-runner", "."

    # Create a default config directory
    (etc/"forgejo-runner").mkpath
  end

  service do
    run [opt_bin/"forgejo-runner", "daemon", "--config", etc/"forgejo-runner/config.yaml"]
    keep_alive true
    log_path var/"log/forgejo-runner.log"
    error_log_path var/"log/forgejo-runner.log"
    working_dir var/"forgejo-runner"
  end

  def caveats
    <<~EOS
      Before starting the service, you must register the runner:
        forgejo-runner register --instance [URL] --token [TOKEN]
        mv .runner #{var}/"forgejo-runner"

      Then, generate the config file:
        forgejo-runner generate-config > #{etc}/forgejo-runner/config.yaml
    EOS
  end
end
