class OhShitMeeting < Formula
  desc "Obnoxious, hard-to-miss alerts before your calendar meetings start"
  homepage "https://github.com/GiGurra/oh-shit-meeting"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/GiGurra/oh-shit-meeting/releases/download/v0.0.30/oh-shit-meeting_darwin_arm64_v8.0.tar.gz"
      sha256 "9e65620f1fd253ce61f3972cf602ae04120a1d30c46f5c3ad64f4dec8f146fe4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/GiGurra/oh-shit-meeting/releases/download/v0.0.30/oh-shit-meeting_linux_amd64_v1.tar.gz"
      sha256 "c358d96210b8f130bccb74ac61e4829cbc8275de2c377757d523074a3acfb942"
    end
    on_arm do
      url "https://github.com/GiGurra/oh-shit-meeting/releases/download/v0.0.30/oh-shit-meeting_linux_arm64_v8.0.tar.gz"
      sha256 "62915037010ed67cf8bd1f40111a8ab7ff7735f97a111711fbd29e8411331764"
    end
  end

  def install
    # Release archives do not preserve the executable bit.
    chmod 0755, "oh-shit-meeting"
    bin.install "oh-shit-meeting"

    # POSIX sh launcher: start detached, append output to a known log file.
    (bin/"oh-shit-meeting-bg").write <<~SH
      #!/bin/sh
      # Start oh-shit-meeting in the background, detached from this terminal.
      # Arguments are passed through, e.g.: oh-shit-meeting-bg --fullscreen
      # Log file: $OH_SHIT_MEETING_LOG (default: ~/.oh-shit-meeting.log)
      log="${OH_SHIT_MEETING_LOG:-$HOME/.oh-shit-meeting.log}"
      if pgrep -x oh-shit-meeting >/dev/null 2>&1; then
        echo "oh-shit-meeting is already running (stop it with: pkill -x oh-shit-meeting)" >&2
        exit 1
      fi
      nohup "#{opt_bin}/oh-shit-meeting" "$@" >>"$log" 2>&1 </dev/null &
      echo "oh-shit-meeting started (pid $!), logging to $log"
    SH
    chmod 0755, bin/"oh-shit-meeting-bg"
  end

  def caveats
    <<~EOS
      Start it in the background (detached, any shell), logging to ~/.oh-shit-meeting.log:
        oh-shit-meeting-bg --fullscreen

      Override the log location with OH_SHIT_MEETING_LOG. Stop it with:
        pkill -x oh-shit-meeting

      On Linux, ALSA (libasound2) must be installed for sound.
    EOS
  end

  test do
    assert_match "Monitors your calendar", shell_output("#{bin}/oh-shit-meeting --help")
    assert_predicate bin/"oh-shit-meeting-bg", :executable?
  end
end
