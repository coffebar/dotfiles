local function context_dir(state)
  -- return the directory of the current neo-tree node
  local node = state.tree:get_node()
  if node.type == "directory" then
    return node.path
  end
  return node.path:gsub("/[^/]*$", "") -- go up one level
end

return {
  source_selector = {
    winbar = true,
    content_layout = "center",
    sources = {
      { source = "filesystem", display_name = "Files" },
      { source = "buffers", display_name = "Buff" },
      { source = "git_status", display_name = "Git" },
      { source = "diagnostics", display_name = "Diagn" },
    },
  },
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
        --"node_modules",
      },
      hide_by_pattern = {
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db",
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
  },
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- ["<space>"] = {
      --   "toggle_node",
      --   nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      -- },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<esc>"] = "revert_preview",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",

      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["C"] = "close_node",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = {
        "add",
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none", -- "none", "relative", "absolute"
        },
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",

      -- custom mapping ---

      -- open in the Thunar file manager
      ["t"] = {
        function(state)
          local node = state.tree:get_node()
          vim.fn.jobstart({ "thunar", node.path }, { detach = true })
          -- close neo-tree
          vim.cmd("Neotree close")
        end,
        desc = "thunar",
        nowait = true,
      },
      -- copy absolute path to clipboard
      ["Y"] = {
        function(state)
          local node = state.tree:get_node()
          local content = node.path
          vim.fn.setreg('"', content)
          vim.fn.setreg("1", content)
          vim.fn.setreg("+", content)
        end,
        desc = "copy abs path",
        nowait = true,
      },
      -- open in telescope live grep
      ["<c-f>"] = {
        function(state)
          require("telescope.builtin").live_grep({ cwd = context_dir(state) })
          -- close neo-tree
          vim.cmd("Neotree close")
        end,
        desc = "live grep",
        nowait = true,
      },
      -- paste from the system clipboard
      ["<c-p>"] = {
        function(state)
          local dest_dir = context_dir(state)
          local files = vim.split(vim.fn.getreg("+"), "\n")
          for _, file in ipairs(files) do
            local filename = file:gsub("^.*/", "")
            local dest = dest_dir .. "/" .. filename
            -- run `git add` afterwards if the file will not be overwriten and `.git` dir found in CWD
            local git_add = vim.fn.filereadable(file) == 1
              and vim.fn.filereadable(dest) == 0
              and vim.fn.isdirectory(".git") == 1

            if vim.fn.isdirectory(file) == 1 or vim.fn.filereadable(file) == 1 then
              vim.fn.jobstart({ "cp", "-r", file, dest_dir }, {
                detach = true,
                on_exit = function()
                  vim.notify("Paste " .. vim.fn.shellescape(filename), vim.log.levels.INFO, {
                    title = "neo-tree",
                    timeout = 500,
                  })
                  -- if file is not in the ignored path and not overwriten, then `git add`
                  if git_add then
                    vim.fn.jobstart({ "git", "add", dest }, {
                      on_exit = function()
                        state.commands["refresh"](state)
                      end,
                    })
                  else
                    state.commands["refresh"](state)
                  end
                end,
                on_stderr = function(_, data)
                  if data[1] ~= "" then
                    vim.notify(data[1], vim.log.levels.ERROR)
                  end
                end,
              })
            end
          end
        end,
        desc = "paste from clipboard",
        nowait = true,
      },
      -- open in Spectre to replace here
      ["<c-r>"] = {
        function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            require("spectre").open({
              cwd = node.path,
              is_close = true, -- close an exists instance of spectre and open new
              is_insert_mode = false,
              path = "",
            })
          else
            require("spectre").open({
              cwd = context_dir(state),
              is_close = true, -- close an exists instance of spectre and open new
              is_insert_mode = false,
              path = node.path:match("^.+/(.+)$"),
            })
          end
          -- close neo-tree
          vim.cmd("Neotree close")
        end,
        desc = "replace here",
        nowait = true,
      },
      -- git add
      ga = {
        function(state)
          local node = state.tree:get_node()
          vim.fn.jobstart({ "git", "add", node.path }, {
            on_exit = function()
              state.commands["refresh"](state)
            end,
          })
        end,
        desc = "git add",
        nowait = true,
      },
      -- upload (sync files)
      uu = {
        function(state)
          vim.cmd("TransferUpload " .. state.tree:get_node().path)
        end,
        desc = "upload file or directory",
        nowait = true,
      },
      -- download (sync files)
      ud = {
        function(state)
          vim.cmd("TransferDownload" .. state.tree:get_node().path)
        end,
        desc = "download file or directory",
        nowait = true,
      },
      -- diff directory with remote
      uf = {
        function(state)
          vim.cmd("TransferDirDiff " .. context_dir(state))
          vim.cmd("Neotree close")
        end,
        desc = "diff with remote",
      },
    },
  },
}
