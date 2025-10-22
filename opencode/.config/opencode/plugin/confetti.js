export const ConfettiPlugin = async ({ project, client, $, directory, worktree }) => {

  return {
    event: async ({ event }) => {
      // Send notification on session completion
      if (event.type === "session.idle") {
        await $`open raycast://extensions/raycast/raycast/confetti?emojis=🤖🤖🔥🔥`
      }
    },
  }
}
