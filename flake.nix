{
  description = "Nix flake for vector-quantize-pytorch (upstream: lucidrains/vector-quantize-pytorch)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      packages.${system}.default = pkgs.python3Packages.buildPythonPackage {
        pname = "vector-quantize-pytorch";
        version = "pyproject.toml:1.28.0";
        pyproject = true;
        src = ./.;
        build-system = [ pkgs.python3Packages.hatchling ];
        dependencies = with pkgs.python3Packages; [ torch ];
        pythonRelaxDeps = true;
        doCheck = false;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ (pkgs.python3.withPackages (ps: with ps; [ torch ])) ];
      };
    };
}
