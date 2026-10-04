class Bork < Formula
  desc "A pragmatic backend language of guarantees, compiled to Go"
  homepage "https://gigurra.github.io/bork/"
  url "https://github.com/GiGurra/bork/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "03ac1aa9889486f53df4cbd235d10bc8b90a79c6758c19a490b4d6ecdb2a4764"
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
