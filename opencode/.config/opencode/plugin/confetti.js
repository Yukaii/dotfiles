export const ConfettiPlugin = async ({ project, client, $, directory, worktree }) => {

  return {
    event: async ({ event }) => {
      // Send notification on session completion
      if (event.type === "session.idle") {
        await $`open -g raycast-x://extensions/raycast/raycast/confetti`
      }
    },
  }
}
