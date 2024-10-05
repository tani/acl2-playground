{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import (inputs.nixpkgs) {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (self: super: {
              acl2 = super.acl2.overrideAttrs (old: {
                patches = old.patches ++ [ /workspace/acl2-playground/quicklisp-backport.patch ];
              });
            })
          ];
        });
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.acl2
            pkgs.rlwrap
          ];
        };
      }
    );
}
