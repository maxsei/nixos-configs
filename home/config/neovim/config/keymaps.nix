{ ... }:
{
  keymaps = [
    {
      mode = "n";
      key = ";";
      action = ":";
    }

    {
      mode = "n";
      key = "<leader>N";
      action = "<cmd>Ex<CR>";
    }

    # # Move visual selections up and down.
    # { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }
    # { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }

    # Joined lines then go to start of line.
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
    }

    # Centered C-d/C-u.
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }

    # Match jumps centered.
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }

    # In paste in visual block mode without overwriting what you pasted.
    {
      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
    }

    # visual indent keeping selection
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }

    # window resizing
    {
      mode = "n";
      key = "<C-w><C-h>";
      action = ":vertical resize +5<CR>";
    }
    {
      mode = "n";
      key = "<C-w><C-l>";
      action = ":vertical resize -5<CR>";
    }
    {
      mode = "n";
      key = "<C-w><C-j>";
      action = ":resize +5<CR>";
    }
    {
      mode = "n";
      key = "<C-w><C-k>";
      action = ":resize -5<CR>";
    }

    # Clipboard.
    {
      mode = "v";
      key = "<Leader>y";
      action = "\"+ygv";
    }
    {
      mode = "v";
      key = "<Leader>d";
      action = "\"+dgv<Esc>";
    }
    {
      mode = "n";
      key = "<Leader>p";
      action = "\"+p";
    }
    {
      mode = "n";
      key = "<Leader>P";
      action = "\"+P";
    }
    {
      mode = "n";
      key = "<Leader>yy";
      action = "V\"+y";
    }
    {
      mode = "n";
      key = "<Leader>dd";
      action = "V\"+d";
    }
    {
      mode = "i";
      key = "<S-Insert>";
      action = "<C-R>+";
    }

    # Delete without overwriting default register.
    {
      mode = "n";
      key = "<leader>d";
      action = "\"_d";
    }
    {
      mode = "v";
      key = "<leader>d";
      action = "\"_d";
    }

    # { mode = "n"; key = "<C-f>"; action = "<cmd>silent !tmux neww tmux-sessionizer<CR>"; }

    # TODO: move to lsp configuration.
    {
      mode = "v";
      key = "<leader>f";
      action.__raw = ''
        function()
            vim.lsp.buf.format()
        end
      '';
    }

    # Toggle netrw in vim's cwd.
    {
      mode = "n";
      key = "<leader>n";
      options.silent = true;
      action.__raw = ''
        function()
          if vim.b.new_window_id then
            vim.fn.win_execute(vim.b.new_window_id, ':q')
          else
            vim.cmd('vs .')
            vim.b.new_window_id = vim.fn.win_getid()
            vim.fn.win_execute(vim.b.new_window_id, 'vertical resize 40')
            vim.fn.win_execute(vim.b.new_window_id, 'wincmd H')
          end
        end
      '';
    }

    # TODO: move loclist and qfix configuration. I wanna make this epic.
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>cnext<CR>zz";
    }
    {
      mode = "n";
      key = "<C-p>";
      action = "<cmd>cprev<CR>zz";
    }
    {
      mode = "n";
      key = "<C>j";
      action = "<cmd>lnext<CR>zz";
    }
    {
      mode = "n";
      key = "<C>k";
      action = "<cmd>lprev<CR>zz";
    }

    # Toggle highlight search
    {
      mode = "n";
      key = "<leader>h";
      action = ":set hlsearch! hlsearch?<CR>";
    }

    # # TODO: make search and replace better e.g. lsp, visual, case insensitive etc.
    # {
    #   mode = "n";
    #   key = "<leader>s";
    #   action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
    # }
  ];
}
