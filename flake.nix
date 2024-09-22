{
  description = "android apk build nix";
  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    {
      self,
      flake-compat,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: p: {
            processing' = p.processing.overrideAttrs (_: {
              dontWrapGApps = false;
            });
          })
        ];
        config = {
          allowUnfreePredicate =
            pkg:
            builtins.elem (pkgs.lib.getName pkg) [
              "android-sdk-cmdline-tools"
              "android-sdk-tools"
            ];
          android_sdk.accept_license = true;
        };
      };
    in
    {
      devShells.${system} = rec {
        default = pkgs.mkShellNoCC {
          # see https://discourse.nixos.org/t/user-environments-direnv-lorri-bazel-buildfhsuserenv/12798/20
          shellHook = ''
            nix develop .#ci
          '';
          inputsFrom = [ lint ];
        };
        lint = pkgs.mkShell {
          packages = [ pkgs.nixfmt-rfc-style ];
        };
        studio = pkgs.mkShell {
          packages = with pkgs; [
            android-studio
            processing'
          ];
        };
        # TODO: build without androidstudio
        # see https://github.com/processing/processing-android/pull/772
        ci =
          let
            jdk = pkgs.jdk17_headless;
            # note: can use pkgs.androidenv.androidPkgs.androidsdk
            # but it pulls in lots of toolchains see https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/mobile/androidenv/default.nix#L18
            androidSdk' =
              (pkgs.androidenv.composeAndroidPackages {
                platformVersions = [ "33" ];
                includeEmulator = false;
                includeSystemImages = false;
                includeNDK = false;
              }).androidsdk;
          in
          (pkgs.buildFHSUserEnv {
            name = "android-sdk";
            targetPkgs =
              pkgs:
              (with pkgs; [
                androidSdk'
                glibc
              ]);
            runScript = pkgs.writeScript "init.sh" ''
              export JAVA_HOME=${jdk}
              export PATH="${jdk}/bin:$PATH"
              export ANDROID_SDK=${androidSdk'}/libexec/android-sdk
              exec bash
            '';
          }).env;
      };
    };
}
