{ ... }:
{
  plugins.fugitive.enable = true;

  keymaps = [
    { mode = "n"; key = "<leader>gs"; action = "<cmd>Git<CR>"; }
  ];
}
