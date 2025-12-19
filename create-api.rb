class CreateAPI < Formula
  desc ""
  homepage "https://github.com/FlabbergastAgency/CreateAPI"
  url "https://github.com/FlabbergastAgency/CreateAPI/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  depends_on :xcode => ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/create-api"
  end

  test do
    assert_match "0.2.1", shell_output("#{bin}/create-api --version")
  end
end
