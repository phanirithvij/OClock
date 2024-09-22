{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    android-studio
    processing
    nixfmt-rfc-style
  ];
}
