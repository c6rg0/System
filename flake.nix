{
  description = "flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Any third party modules can be input here
    # ... 
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
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
            home-manager.users.gabriel = import ./home.nix;
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
            home-manager.users.gabriel = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
        ];
        specialArgs = { inherit inputs outputs; };
      };

    };
  };

}
