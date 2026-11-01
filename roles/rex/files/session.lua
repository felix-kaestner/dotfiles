-- Agent session recording and restoration.
-- rex do ~/.config/rex/session.lua --action on_agent_start --args '{"agent":"pi","conversation":"/path/to/session.jsonl","cwd":"/path/to/project"}'
-- rex do ~/.config/rex/session.lua --action restore_agents

local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local directory = state_home .. "/rex/sessions"

rex.action({
    name = "on_agent_start",
    title = "Record Agent Start",
    args = { agent = "string", conversation = "string", cwd = "string" },
    run = function(ctx, args)
        local record = {
            session_id = ctx.session_id,
            block_id = ctx.block_id,
            agent = args.agent or "claude",
            conversation = args.conversation or args.session_id,
            cwd = args.cwd,
        }

        rex.exec({ "mkdir", "-p", directory })

        local file, err = io.open(directory .. "/" .. ctx.block_id .. ".json", "w")
        if not file then
            error(err, 0)
        end

        _, err = file:write(rex.json.encode(record))
        if err ~= nil then
            error(err, 0)
        end

        _, err = file:close()
        if err ~= nil then
            error(err, 0)
        end
    end,
})

rex.action({
    name = "on_agent_stop",
    title = "Record Agent Stop",
    run = function(ctx)
        os.remove(directory .. "/" .. ctx.block_id .. ".json")
    end,
})

rex.action({
    name = "restore_agents",
    title = "Restore Agent Sessions",
    run = function()
        local result = rex.exec({ "find", directory, "-name", "*.json", "-maxdepth", "1" })
        if not result or not result.ok or result.stdout == "" then
            return
        end

        for path in result.stdout:gmatch("[^\n]+") do
            local file = io.open(path, "r")
            if file then
                local record = rex.json.decode(file:read("*a"))
                file:close()

                result = rex.exec({ "rex", "block", "call", "-s", record.session_id, "-b", record.block_id, "process" })
                if result and result.ok then
                    local process = rex.json.decode(result.stdout)

                    -- Only resume if the shell is idle (login shell is in the foreground)
                    if
                        process
                        and process.foreground
                        and process.foreground.argv0
                        and process.foreground.argv0:sub(1, 1) == "-"
                    then
                        local cmd
                        if record.agent == "pi" then
                            cmd = "pi --session '" .. record.conversation .. "'"
                        elseif record.agent == "claude" then
                            cmd = "claude --resume '" .. record.conversation .. "'"
                        end
                        if cmd then
                            rex.exec({ "rex", "send", "-s", record.session_id, "-b", record.block_id, cmd })
                            rex.exec({ "rex", "send-key", "-s", record.session_id, "-b", record.block_id, "enter" })
                        end
                    end
                end
            end
        end
    end,
})
