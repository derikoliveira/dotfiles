{ pkgs, ... }:
{
  home.username = "derik";
  home.shellAliases = {
    zed = "zeditor";
  };
  home.homeDirectory = "/home/derik";
  home.packages = with pkgs; [
    bat
    claude-code
    codex
    fd
    gh
    uv
    zed-editor
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "26.05";

  programs.fzf = {
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'lsd -la --color=always {}'"
    ];
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border=rounded"
      "--info=inline"
      "--cycle"
    ];
    enable = true;
    enableZshIntegration = true;
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };
  programs.home-manager.enable = true;
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };
    initContent = ''
      fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      autoload -U promptinit && promptinit
      prompt pure
    '';
  };
}
