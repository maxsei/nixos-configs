{ ... }:
{
  opts = {
    number = true;
    relativenumber = true;

    swapfile = false;
    backup = false;
    undodir.__raw = ''os.getenv("XDG_DATA_HOME") .. "/nvim/undo"'';
    undofile = true;

    hlsearch = false;
    incsearch = true;
    smartcase = true;

    termguicolors = true;

    scrolloff = 3;
    sidescrolloff = 20;

    updatetime = 50;

    infercase = true;
    wildmode = "longest,list,full";
    wildignorecase = true;

    mouse = "n";

    list = true;
    listchars = "tab:>-,trail:~,extends:>,precedes:<";

    # Arrow keys also wrap in normal and insert mode.
    whichwrap = "<,>,[,],b,s";

    backspace = "indent,eol,start";

    textwidth = 80;
    wrap = false;
  };

  globals.mapleader = " ";

  # Check for file changes.
  autoCmd = [
    {
      event = [
        "BufEnter"
        "FocusGained"
        "VimResume"
      ];
      pattern = [ "*" ];
      command = "checktime";
    }
  ];
}
