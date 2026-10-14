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
          default = pkgs.stdenv.mkDerivation {
            pname = "elodie-haskell-test-utils";
            version = "0.1.0";
            src = ./.;
            buildInputs = [ haskellEnv ];
            buildPhase = ''
              mkdir elodie_haskell_test_utils
              ghc -c -O2 -odir elodie_haskell_test_utils -hidir elodie_haskell_test_utils Elodie/Test/Utils.hs
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp -a elodie_haskell_test_utils $out/lib/
            '';
          };
          ghc-env = haskellEnv;
        };
      }
    );
}
