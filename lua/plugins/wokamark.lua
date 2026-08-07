-- plugins/wokamark.lua — per-directory workspace sessions (GitHub install, lazy spec)
-- Eager (no lazy trigger): plugin/wokamark.lua registers VimEnter/
-- BufReadPost/CursorHold hooks that must be active at startup — VeryLazy
-- would miss VimEnter auto_restore (ADR D-003, hard constraint).
-- Deps: trigger-help.nvim — wokamark's setup() calls
-- require('trigger_help').register_doc for the bilingual cheatsheet.
-- Dev mode: ~/projects/wokamark.nvim via dev.patterns (see config/lazy.lua).

return {
  'sin1111yi/wokamark.nvim',
  commit = 'ba8413784267fc19431f93972b74ba5ce032b7b2', -- GitHub HEAD (migration pin)
  dependencies = { 'sin1111yi/trigger-help.nvim' },
  config = function()
    require('wokamark').setup({ auto_mark = true })
  end,
}
