# GiGurra Homebrew tap

```sh
brew install gigurra/tap/bork
brew install gigurra/tap/oh-shit-meeting
```

Formulas here are updated automatically by the release workflows of
[GiGurra/bork](https://github.com/GiGurra/bork) and
[GiGurra/oh-shit-meeting](https://github.com/GiGurra/oh-shit-meeting).

## oh-shit-meeting

Besides the `oh-shit-meeting` CLI, the formula installs `oh-shit-meeting-bg`, a
POSIX `sh` launcher that works from any shell (bash, zsh, fish, ...). It starts
oh-shit-meeting detached from the terminal and appends its output to
`~/.oh-shit-meeting.log` (override with `OH_SHIT_MEETING_LOG`). Arguments are
passed through:

```sh
oh-shit-meeting-bg --fullscreen
tail -f ~/.oh-shit-meeting.log   # follow the log
pkill -x oh-shit-meeting          # stop it
```

Prebuilt binaries are available for macOS arm64 and Linux amd64/arm64. On Linux,
ALSA (`libasound2`) must be installed.

To point the formula at a release manually:

```sh
scripts/update-oh-shit-meeting.sh          # latest release
scripts/update-oh-shit-meeting.sh v0.0.30  # specific tag
```
