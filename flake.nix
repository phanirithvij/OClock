{
  description = "android apk build nix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
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
            if [ -n "$DIRENV_IN_ENVRC" ]; then
              RED='\033[0;31m'
              NC='\033[0m'
              printf "''${RED}direnv + fhsenv unsupported''${NC} run\n"
              echo nix develop .#ci
              exit 1
            else
              nix develop .#ci
            fi
          '';
          inputsFrom = [ lint ];
        };
        lint = pkgs.mkShell {
          packages = [ pkgs.nixfmt-rfc-style ];
        };
        ide = pkgs.mkShell {
          packages = with pkgs; [
            android-studio
            processing'
          ];
        };
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
          # https://discourse.nixos.org/t/how-to-convert-this-nix-shell-file-into-a-buildfhsuserenv/20651/7
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
