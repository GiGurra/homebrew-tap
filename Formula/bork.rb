class Bork < Formula
  desc "A pragmatic backend language of guarantees, compiled to Go"
  homepage "https://gigurra.github.io/bork/"
  url "https://github.com/GiGurra/bork/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "77d77941cef3100e0f4f571f2c70b0337ad0d150fc8a9d30f0af1c05f5f4522c"
  license "MIT"

  # The installed compiler invokes Go when building programs.
  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.releaseVersion=v#{version}"), "./cmd/bork"
  end

  test do
    assert_match "bork v#{version}", shell_output("#{bin}/bork version")
    (testpath/"hello.bork").write('fn main() { println("hello") }')
    assert_equal "hello\n", shell_output("#{bin}/bork run hello.bork")
  end
end
