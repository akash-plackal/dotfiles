-- UI related plugins
return {
	-- Colorscheme
  {
    "echasnovski/mini.hues",
    lazy = false,
    priority = 1000,
    config = function()
      require("mini.hues").setup({
        background = "#181f19",
        foreground = "#e7ebdc",
        accent = "green",
        saturation = "medium",
        --n_hues = 8
      })
    end,
  },

	-- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		config = function()
			require("git-conflict").setup()
		end,
	},

	-- Treesitter configuration

{
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    version = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      local ensure_installed = {
        "bash",
        "c",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "python",
        "regex",
        "ruby",
        "rust",
        "sql",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "xml",
        "yaml",
        "zsh",
      }

      local ignore_filetype = {
        "checkhealth",
        "lazy",
        "mason",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_win",
        "snacks_input",
        "snacks_picker_input",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "spectre_panel",
        "NvimTree",
        "undotree",
        "Outline",
        "sagaoutline",
        "copilot-chat",
        "vscode-diff-explorer",
      }

      local treesitter_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
      ts.setup({})

      local installed = ts.get_installed()
      local to_install = vim
        .iter(ensure_installed)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()

      if #to_install > 0 then
        ts.install(to_install)
      end

      local import_fold_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
      }

      function _G.custom_import_foldexpr(lnum)
        local function is_import_start(text)
          return text:match("^%s*import%s") ~= nil
        end

        local function is_blank(text)
          return text:match("^%s*$") ~= nil
        end

        local function is_import_related_line(target_lnum)
          local text = vim.fn.getline(target_lnum)
          if is_import_start(text) then
            return true
          end

          local scan = target_lnum - 1
          while scan >= 1 do
            local prev_text = vim.fn.getline(scan)
            if is_blank(prev_text) then
              return false
            end
            if is_import_start(prev_text) then
              return not prev_text:match(";%s*$")
            end
            if prev_text:match(";%s*$") then
              return false
            end
            scan = scan - 1
          end

          return false
        end

        if not is_import_related_line(lnum) then
          return "0"
        end

        local prev_related = lnum > 1 and is_import_related_line(lnum - 1) or false
        local next_related = is_import_related_line(lnum + 1)

        if not prev_related and next_related then
          return ">1"
        end
        if prev_related and not next_related then
          return "<1"
        end
        if prev_related or next_related then
          return "1"
        end

        return "0"
      end

      local function enable_treesitter(buf)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local ft = vim.bo[buf].filetype
        if ft == "" or vim.bo[buf].buftype ~= "" or vim.tbl_contains(ignore_filetype, ft) then
          return
        end

        if not pcall(vim.treesitter.start, buf) then
          return
        end

        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          if import_fold_filetypes[ft] then
            vim.wo[win].foldmethod = "expr"
            vim.wo[win].foldexpr = "v:lua.custom_import_foldexpr(v:lnum)"
            vim.wo[win].foldenable = true
            vim.wo[win].foldlevel = 0
          else
            vim.wo[win].foldmethod = "manual"
            vim.wo[win].foldexpr = "0"
            vim.wo[win].foldlevel = 99
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = treesitter_group,
        desc = "Enable tree-sitter highlighting, folds, and indent",
        callback = function(ev)
          enable_treesitter(ev.buf)
        end,
      })

      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          enable_treesitter(buf)
        end
      end)
    end,
  },
},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 1,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				--separator = "-",
				zindex = 20,
				on_attach = nil,
			})
		end,
	},
}
