{ pkgs ? import <nixpkgs> { config = { allowBroken = true; }; }
}:
let
  fonts = with pkgs; [ source-sans-pro iosevka ];
in pkgs.stdenv.mkDerivation {
  name = "slides";
  src = ./.;
  installPhase = ''
    cp -r target $out
  '';
  buildInputs = with pkgs; [
    nixfmt
    pandoc
    python3
    texlive.combined.scheme-full
  ];
  FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = fonts; };
}
