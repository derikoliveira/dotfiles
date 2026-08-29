{ pkgs, ... }:
{
  home.username = "cossen";
  home.homeDirectory = "/home/cossen";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    discord
    librewolf
    google-chrome
    steam
  ];

  programs.home-manager.enable = true;
}
