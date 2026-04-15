{
  lib,
  pkgs,
  ...
}:
{
  plugins.lsp = {
    enable = true;
    inlayHints = false;
    keymaps = {
      diagnostic = {
        # "<leader>E" = "open_float";
        # "[" = "goto_prev";
        # "]" = "goto_next";
        "<leader>l" = "setloclist";
      };
      lspBuf = {
        "K" = "hover";

        # TODO:  combine these into a single keybind.
        "gD" = "declaration";
        "gd" = "definition";
        "gy" = "type_definition";

        "g*" = "references";
        "gi" = "implementation";
        # "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
      };
    };
    # preConfig = ''
    #   vim.diagnostic.config({
    #     virtual_text = false,
    #     severity_sort = true,
    #     float = {
    #       border = 'rounded',
    #       source = 'always',
    #     },
    #   })
    #
    #   vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    #     vim.lsp.handlers.hover,
    #     {border = 'rounded'}
    #   )
    #
    #   vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    #     vim.lsp.handlers.signature_help,
    #     {border = 'rounded'}
    #   )
    # '';
    # postConfig = ''
    #         vim.diagnostic.config({
    #     signs = {
    #       text = {
    #         [vim.diagnostic.severity.ERROR] = "✘",
    #         [vim.diagnostic.severity.WARN]  = "▲",
    #         [vim.diagnostic.severity.HINT]  = "⚑",
    #         [vim.diagnostic.severity.INFO]  = "",
    #       }
    #     },
    #     virtual_text = true,
    #     underline = true,
    #     update_in_insert = false,
    #   })
    # '';
    servers = {
      # pylsp = {
      #   enable = true;
      #   # enable = false;
      #   # settings.plugins = {
      #   #   black.enabled = true;
      #   #   flake8.enabled = true;
      #   #   isort.enabled = true;
      #   #   jedi.enabled = true;
      #   #   pycodestyle.enabled = true;
      #   #   pydocstyle.enabled = true;
      #   #   pyflakes.enabled = true;
      #   #   mccabe.enabled = true;
      #   #   rope.enabled = true;
      #   #   yapf.enabled = true;
      #   # };
      # };
      lua_ls.enable = true;
      cssls.enable = true;
      html.enable = true;
      # pyright.enable = true;
      nil_ls.enable = true;
      bashls.enable = true;
      yamlls = {
        enable = true;
        filetypes = [ "yaml" ];
      };
      terraformls = {
        enable = true;
        filetypes = [
          "terraform"
          "tf"
        ];
      };
      ts_ls.enable = true;
      clangd.enable = true;
      zls.enable = true;
      rust_analyzer = {
        enable = true;
        installRustc = true;
        installCargo = true;
      };
    };
  };

  plugins.cmp = {
    enable = true;
    settings = {
      autoEnableSources = true;
      preselect = "cmp.PreselectMode.None";
      completion.autocomplete = false;
      performance = {
        debounce = 150;
      };
      sources = [
        {
          name = "nvim_lsp";
          keywordLength = 1;
          entry_filter = ''
            function(entry, ctx)
              return require('cmp').lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end
          '';
        }
        {
          name = "buffer";
          keywordLength = 3;
        }
        { name = "path"; }
      ];

      sorting = {
        comparators = [
          "require('cmp.config.compare').sort_text"
          "require('cmp.config.compare').kind"
          "require('cmp.config.compare').offset"
          "require('cmp.config.compare').exact"
          "require('cmp.config.compare').score"
          "require('cmp.config.compare').recently_used"
          "require('cmp.config.compare').locality"
          "require('cmp.config.compare').length"
          "require('cmp.config.compare').order"
        ];
      };

      snippet.expand = "function(args) end";
      formatting = {
        fields = [
          "menu"
          "abbr"
          "kind"
        ];
        format = lib.mkForce ''
          function(entry, item)
            local menu_icon = {
              nvim_lsp = '[LSP]',
              luasnip = '[SNIP]',
              buffer = '[BUF]',
              path = '[PATH]',
              spell = '[SPELL]',
            }

            item.menu = menu_icon[entry.source.name]
            return item
          end
        '';
      };

      mapping = lib.mkForce {
        # "<Up>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        # "<Down>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";

        "<C-p>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
            else
              cmp.complete()
            end
          end, {"i", "c"})
        '';
        "<C-n>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
            else
              cmp.complete()
            end
          end, {"i", "c"})
        '';

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-e>" = "cmp.mapping.abort()";
        "<C-y>" = "cmp.mapping.confirm({select = true})";
        "<CR>" = "cmp.mapping.confirm({select = false})";
      };
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          maxHeight = 20;
        };
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.dap.enable = true;
  plugins.trouble = {
    enable = true;
    settings = { };
  };
  plugins.none-ls = {
    enable = true;
    sources.formatting = {
      black.enable = true;
      alejandra.enable = true;
      hclfmt.enable = true;
      opentofu_fmt.enable = true;
      prettier = {
        enable = true;
        package = pkgs.prettier;
        disableTsServerFormatter = true;
      };
      sqlformat.enable = true;
      stylua.enable = true;
      yamlfmt.enable = true;
    };
    sources.diagnostics = {
      trivy.enable = true;
      yamllint.enable = true;
    };
  };

  # plugins.lint = {
  #   enable = true;
  #   lintersByFt = {
  #     text = ["vale"];
  #     json = ["jsonlint"];
  #     markdown = ["prettier"];
  #     #ruby = ["rubyfmt"];
  #     dockerfile = ["hadolint"];
  #     terraform = ["tofu_fmt"];
  #     tf = ["tofu_fmt"];
  #     bash = ["shellcheck"];
  #     yaml = ["yamlfmt"];
  #     nix = ["alejandra"];
  #     go = ["golangci-lint"];
  #     python = ["flake8"];
  #     haskell = ["hlint"];
  #     lua = ["selene"];
  #   };
  #   linters = {
  #     hadolint = {
  #       cmd = "${pkgs.hadolint}/bin/hadolint";
  #     };
  #   };
  # };
}
