{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt-tree;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            # k8s
            kubectl
            fluxcd
            # encryption
            sops
            age
            # terraform
            opentofu
          ];
          # language=bash
          shellHook = ''
            rbw_get() { command -v rbw >/dev/null 2>&1 && rbw get "$1" 2>/dev/null; }
            val="$(rbw_get yukulab-cf-api-token)"              && export TF_VAR_cloudflare_api_token="$val"
            val="$(rbw_get yukulab-infra-tf-state-passphrase)" && export TF_VAR_state_encryption_passphrase="$val"
            unset -f rbw_get
            unset val
          '';
        };
      }
    );
}
