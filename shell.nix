let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    overlays = [
      (_: p: {
        processing' = p.processing.overrideAttrs (_: {
          dontWrapGApps = false;
        });
      })
    ];
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    android-studio
    processing'
    nixfmt-rfc-style
  ];
}
