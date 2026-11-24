{ pkgs, ... }:
{
  home.username = "derik";
  home.shellAliases = {
    zed = "zeditor";
  };
  home.homeDirectory = "/home/derik";
  home.packages = with pkgs; [
    awscli2
    bat
    bruno
    claude-code
    codex
    dbeaver-bin
    discord
    fd
    fnm
    gh
    google-chrome
    (callPackage ./helium.nix { })
    jdk25
    libreoffice-qt
    obsidian
    poetry
    signal-desktop
    sqlite
    uv
    vscode
    zed-editor
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.sessionVariables.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  home.stateVersion = "26.05";

  programs.fzf = {
    changeDirWidget.command = "fd --type d --hidden --exclude .git";
    changeDirWidget.options = [
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
    fileWidget.command = "fd --type f --hidden --exclude .git";
    fileWidget.options = [
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
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };
}
