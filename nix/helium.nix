{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  cups,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libpulseaudio,
  libva,
  libxkbcommon,
  nss,
  pipewire,
  systemd,
  vulkan-loader,
  wayland,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "helium";
  version = "0.18.2.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
    hash = "sha256-RJPXVrmK++P9fUXA7CFcI/WgVR+ucVWG/mzjsimLFVw=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cups
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nss
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  # Chromium dlopen()s these at runtime, so autoPatchelf can't see them.
  runtimeLibs = lib.makeLibraryPath [
    libGL
    libpulseaudio
    libva
    pipewire
    systemd
    vulkan-loader
    wayland
  ];

  installPhase = ''
    runHook preInstall

    # Qt shims would pull in Qt5+Qt6; Chromium falls back to GTK without them.
    rm -f libqt5_shim.so libqt6_shim.so

    mkdir -p $out/opt/helium $out/bin
    cp -r . $out/opt/helium
    makeWrapper $out/opt/helium/helium $out/bin/helium \
      --prefix LD_LIBRARY_PATH : "$out/opt/helium:${runtimeLibs}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    install -Dm644 helium.desktop $out/share/applications/helium.desktop
    install -Dm644 product_logo_256.png $out/share/icons/hicolor/256x256/apps/helium.png

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and honest web browser based on ungoogled-chromium";
    homepage = "https://helium.computer";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "helium";
  };
}
