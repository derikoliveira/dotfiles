{ pkgs, config, ... }:
let
  mysqlDir = "${config.home.homeDirectory}/.local/share/mysql";
  # Runs on every start (idempotent): derik logs in via unix socket (auth_socket), no password; no root.
  mysqlInit = pkgs.writeText "mysql-init.sql" ''
    CREATE USER IF NOT EXISTS 'derik'@'localhost' IDENTIFIED WITH auth_socket;
    GRANT ALL PRIVILEGES ON *.* TO 'derik'@'localhost' WITH GRANT OPTION;
    DROP USER IF EXISTS 'root'@'localhost';
  '';
  mysqldArgs = "--basedir=${pkgs.mysql84} --datadir=${mysqlDir}/data";
in
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
    mysql84
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
  home.stateVersion = "26.05";

  home.file.".my.cnf".text = ''
    [client]
    socket=${mysqlDir}/mysql.sock
  '';

  # MySQL server, runs as derik only. Not started at login: `systemctl --user start mysql`.
  systemd.user.services.mysql = {
    Unit.Description = "MySQL server";
    Service = {
      ExecStartPre = "${pkgs.writeShellScript "mysql-initdb" ''
        [ -d ${mysqlDir}/data ] && exit 0
        mkdir -p ${mysqlDir}
        exec ${pkgs.mysql84}/bin/mysqld ${mysqldArgs} --initialize-insecure
      ''}";
      ExecStart = "${pkgs.mysql84}/bin/mysqld ${mysqldArgs} --socket=${mysqlDir}/mysql.sock --bind-address=127.0.0.1 --plugin-load-add=auth_socket.so --init-file=${mysqlInit}";
    };
  };

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
      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };
}
