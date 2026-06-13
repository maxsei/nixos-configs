{ ... }:
{
  plugins.navic = {
    enable = true;
    settings = {
      lsp.auto_attach = true;
      separator = " > ";
    };
  };

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "catppuccin";
        globalstatus = true;
        component_separators = {
          left = "|";
          right = "|";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = [ ];
        lualine_b = [
          { __unkeyed-1 = "branch"; }
          { __unkeyed-1 = "diff"; }
        ];
        lualine_c = [ { __unkeyed-1 = "filename"; path = 1; } ];
        lualine_x = [ { __unkeyed-1 = "diagnostics"; } ];
        lualine_y = [ { __unkeyed-1 = "filetype"; } ];
        lualine_z = [ { __unkeyed-1 = "location"; } ];
      };
      winbar = {
        lualine_c = [
          {
            __unkeyed-1.__raw = ''
              function()
                local navic = require("nvim-navic")
                return navic.is_available() and navic.get_location() or ""
              end
            '';
          }
        ];
      };
      inactive_winbar = {
        lualine_c = [
          {
            __unkeyed-1.__raw = ''
              function()
                local navic = require("nvim-navic")
                return navic.is_available() and navic.get_location() or ""
              end
            '';
          }
        ];
      };
    };
  };
}
