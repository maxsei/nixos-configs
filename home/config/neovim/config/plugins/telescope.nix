{ ... }:
{
  plugins.telescope = {
    enable = true;
    keymaps = {
      # # TODO: I want grep over git files as well as grepping git files. I
      # don't want ctrl+p as this mapping though.
      # "<C-p>" = "git_files";
    };
  };

  # TODO: move to plugins.telescope
  keymaps = [
    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope<CR>";
    }
    {
      mode = "n";
      key = "<leader>//";
      action.__raw = "function() require('telescope.builtin').live_grep() end";
    }
    {
      mode = "n";
      key = "<leader>/f";
      action.__raw = "function() require('telescope.builtin').git_files() end";
    }
  ];
}
