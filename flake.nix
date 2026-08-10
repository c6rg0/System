{
  description = "c6rg0/nix-config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mactahoe-themes.url = "github:c6rg0/mactahoe-themes-flake";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    home-manager,
    mactahoe-themes, 
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {

      desktop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/desktop
          inputs.home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabriel = import ./dotfiles/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };

      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/laptop
          inputs.home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabriel = import ./dotfiles/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };
    };
  };
}
