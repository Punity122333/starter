return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki", "pdf" }, -- Add pdf here
      },
    },
    max_width = 100,
    max_height = 12,
    window_overlap_clear_enabled = true,
  },
}
