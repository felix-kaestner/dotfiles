-- [[ Session launcher ]]
rex.action({
    name = "session_launcher",
    title = "Session Launcher",
    description = "Select a project directory with fzf, then open its existing Rex session or create one in that directory.",
    category = "Sessions",
    run = function(ctx)
        local command = {
            "/usr/bin/env",
            "REX_CLIENT=" .. ctx.client_id,
            os.getenv("HOME") .. "/.local/bin/rexs",
        }
        rex.session.new_layer({
            bounds = { 0.1, 0.1, 0.8, 0.8 },
            focus = true,
            layout = rex.layout.block({
                flavor = "com.superlogical.terminal.shell",
                options = { command = command },
            }),
        })
    end,
})

-- [[ Open GitHub repo ]]
rex.action({
    name = "open_github",
    title = "Open GitHub Repository",
    description = "Open the GitHub repository for the focused pane's working directory.",
    category = "Sessions",
    run = function(ctx)
        rex.exec({ os.getenv("HOME") .. "/.local/bin/ghopen" }, {
            env = {
                REX_SESSION = ctx.session_id,
                REX_BLOCK = ctx.block_id,
            },
        })
    end,
})

-- [[ Quick-launch sessions ]]
rex.action({
    name = "quick_session",
    title = "Quick Launch Session",
    description = "Open or switch to a Rex session in the given directory.",
    category = "Sessions",
    args = { path = "string" },
    run = function(ctx, args)
        rex.exec({ os.getenv("HOME") .. "/.local/bin/rexs", args.path }, {
            env = {
                REX_CLIENT = ctx.client_id,
            },
        })
    end,
})

-- [[ Copy mode ]]
rex.action({
    name = "copy_mode",
    title = "Copy Mode",
    description = "Capture scrollback and open in Neovim for vi-style navigation and yanking.",
    category = "Terminal",
    run = function(ctx)
        local script = [[
            tmp=$(mktemp) || exit 1
            trap 'rm -f "$tmp"' EXIT
            rex capture -s "$1" -b "$2" --trim --unwrap > "$tmp" || exit 1

            nvim -u NONE -i NONE -n -R \
                --cmd 'set nomodeline' \
                -c 'set clipboard=unnamedplus nomodifiable' \
                -c 'nnoremap <silent> q :qa!<CR>' \
                -c 'normal! Gzb' \
                "$tmp"

            rex focus -s "$1" "$2"
        ]]

        local command = { "/bin/sh", "-c", script, "copy_mode", ctx.session_id, ctx.block_id }

        rex.session.new_layer({
            bounds = { 0.1, 0.1, 0.8, 0.8 },
            focus = true,
            layout = rex.layout.block({
                flavor = "com.superlogical.terminal.shell",
                options = { command = command },
            }),
        })
    end,
})
