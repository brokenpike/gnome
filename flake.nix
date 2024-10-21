{
  description = "gnome framework nixos root flake";
  # inputs are an attribute set
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixos-24.05;
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  #outputs is a function of one argument that takes an attribute set of all the realized inputs
  outputs = { self,nixos-hardware, nixpkgs,nixpkgs-stable,home-manager,...}@inputs: {
    # replace 'joes-desktop' with your networking.hostname here.
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        
        modules = [ 
            {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = nixpkgs-stable.legacyPackages.${prev.system};
                  # use this variant if unfree packages are needed:
                  #stable = import nixpkgs-stable {
                  #   inherit ${prev.system};
                  #   config.allowUnfree = true;
                  # };
                })
              ];
            }
          ./configuration.nix 
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
           {
            # enables use of stable overlay in home-manger
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.scott = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
           }
        ];
      };
   };
  };
}
