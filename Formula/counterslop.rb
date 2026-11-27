class Counterslop < Formula
  desc "Browser parody shooter: game server and web client in one binary"
  homepage "https://github.com/GiGurra/counterslop"
  url "https://github.com/GiGurra/counterslop/archive/refs/tags/v0.1.174.tar.gz"
  sha256 "db199bc9fb4c6329ea2a6b259bc5e1e4e094680e31d4b11a61f0c7e6f858464b"
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
