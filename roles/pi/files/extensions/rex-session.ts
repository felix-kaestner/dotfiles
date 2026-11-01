import type {ExtensionAPI} from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  if (!process.env.REX_BLOCK) return;

  const script = `${process.env.HOME}/.config/rex/session.lua`;

  let registered = false;

  async function record(action: string, args: Record<string, string>) {
    const result = await pi.exec("rex", [
      "do", script,
      "--action", action,
      "--args", JSON.stringify(args),
    ], { timeout: 500 });

    if (result.code !== 0 || result.killed) {
      throw new Error(result.stderr || `Rex ${action} failed`);
    }
  }

  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    await record("on_agent_start", {
      agent: "pi",
      conversation: ctx.sessionManager.getSessionId(),
      cwd: ctx.cwd,
    });
    registered = true;
  });

  pi.on("session_shutdown", async () => {
    if (!registered) return;

    await record("on_agent_stop", {});
    registered = false;
  });
}
