{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    my-home.url = "path:/home/gabriel/.config/home-manager";
    my-home.flake = false;
    my-modules.url = "path:/home/gabriel/.config/modules";
    my-modules.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, my-home, my-modules, ... }: {
    nixosConfigurations = {
      gabriel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.permittedInsecurePackages = [
                "ventoy-1.1.10"
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabriel = "${my-home}/home.nix";
              home-manager.extraSpecialArgs = { inherit my-modules; };
            }
        ];
      };
    };
  };
}
