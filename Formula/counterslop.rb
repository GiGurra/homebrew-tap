class Counterslop < Formula
  desc "Browser parody shooter: game server and web client in one binary"
  homepage "https://github.com/GiGurra/counterslop"
  url "https://github.com/GiGurra/counterslop/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "4c3e2a19b6f6c3b6398e729bac0ab2b42ec3b194d3468b7f58601eb4a2947d45"
  license "MIT"
  head "https://github.com/GiGurra/counterslop.git", branch: "main"

  depends_on "go" => :build

  def install
    # -X main.version stamps the release tag into the binary (served at /version).
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
  end

  def caveats
    <<~EOS
      Start a server (the web client is built in), then open it in a browser:

        counterslop                      # http://localhost:8080
        counterslop --addr 127.0.0.1:9000 --bots 4

      With no admin password set, every player is admin. Set one with
      COUNTERSLOP_ADMIN_PASSWORD or --admin-password-file. See: counterslop --help
    EOS
  end

  test do
    port = free_port
    pid = spawn bin/"counterslop", "--addr", "127.0.0.1:#{port}"
    begin
      sleep 3
      assert_match "v#{version}", shell_output("curl -fsS http://127.0.0.1:#{port}/version")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
