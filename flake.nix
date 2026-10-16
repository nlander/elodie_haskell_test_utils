{
  description = "Utilidades para ejecutar pruebas de Tasty en ghci";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bazel-rules.url = "github:nlander/elodie_bazel_rules";
  };
  outputs = {self, nixpkgs, flake-utils, bazel-rules}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellEnv = bazel-rules.packages.${system}.ghc-env;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.bazel_9
          ];
          shellHook = ''
            exec fish
          '';
        };
        packages = {
          ghc-env = haskellEnv;
        };
      }
    );
}
