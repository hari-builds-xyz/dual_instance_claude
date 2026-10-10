# Run two Claude Desktop accounts side by side (Windows & Mac)

Claude Desktop has no account switcher, but it is an Electron app, and Electron apps accept a `--user-data-dir` flag. Launch a second copy with its own data folder and it keeps a completely separate sign-in, cache and settings. Create one shortcut per account and you can run both side by side, with no logging out and in.

## Read this first

This is an unofficial workaround, not a documented Anthropic feature, and a future update could break it.

- **Isolated:** sign-in, cache, local settings and chat history of the second instance live in its own folder.
- **Not isolated:** the app itself (one install, one update path), the `claude://` link handler, and the taskbar identity.
- **Work accounts:** if your employer manages your device or monitors usage, check that custom launch flags are acceptable before using this.
- **Test first:** try it before relying on it, and keep the original shortcut untouched so you can always go back.

## Windows

One script covers both install types. The Microsoft Store (MSIX) version ignores flags on its normal shortcut, so the script launches it through its app alias instead, which does accept them. The Store path was tested; the classic-installer path follows the same logic but was not.

1. Quit Claude completely, including the tray icon.
2. Download [`setup-claude-work.ps1`](setup-claude-work.ps1).
3. Right-click the file and choose **Run with PowerShell**, or run `powershell -ExecutionPolicy Bypass -File setup-claude-work.ps1`.
4. Open the new **Claude Work** shortcut on your Desktop and sign in with your second account.

To make a third profile, run it again with a different name, for example `-Name 'Claude Client'`. Pin the shortcut to the taskbar or Start menu for one-click access.

## Mac

This method comes from a community post and was not tested here.

1. Quit Claude completely (Cmd+Q).
2. In Terminal, run the command below. It opens a second instance with its own data folder. Sign in with the second account, then quit again.

```bash
open -n -a "Claude" --args --user-data-dir="$HOME/Library/Application Support/Claude-Work"
```

To launch it without Terminal, wrap it in an app:

1. Open **Script Editor** and paste this line:

```applescript
do shell script "open -n -a \"/Applications/Claude.app\" --args --user-data-dir=\"$HOME/Library/Application Support/Claude-Work\" > /dev/null 2>&1 &"
```

2. Choose **File > Export**, set the file format to **Application**, name it "Claude Work" and save it in Applications.
3. Drag it to the Dock.

## Known limits

The split is clean for sign-in and chats, but a few things are still shared or behave oddly.

| Issue | What happens | What to do |
| --- | --- | --- |
| `claude://` links | Sign-in redirects and connector authorizations go to whichever instance the OS picks | If an authorization seems to do nothing, check the other window |
| Taskbar and Dock | Both instances share one app identity and may group together; the pinned original icon always opens the first account | Pin the new shortcut; on Windows set taskbar buttons to never combine |
| MCP servers and extensions | Configuration may be per instance | Check Settings > Developer in each instance and add what you need to both |
| Updates | One install serves both instances | Close both before updating |
| Computer use and local folders | Each instance can be linked to your computer separately | Enable these only on the account that should have access, and respect your employer's policy |

## Troubleshooting and undoing it

- **Shortcut opens your first account:** an instance was still running. Quit every Claude process (check the tray or menu bar) and launch the new shortcut first.
- **Script says it can't find Claude:** the app may be installed somewhere unusual. Open the original shortcut's properties, copy its target path, and use it as `$exe` in the script.
- **Store version does nothing:** make sure the app alias is switched on under Settings > Apps > Advanced app settings > App execution aliases.
- **To undo:** delete the shortcut and the second profile folder (`%LOCALAPPDATA%\Claude-Work` on Windows, `~/Library/Application Support/Claude-Work` on Mac). Your original account is never touched.

## Disclaimer

Not affiliated with or endorsed by Anthropic. Use at your own risk.
