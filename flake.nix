{
  description = "gnome framework nixos root flake";
  # inputs are an attribute set
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    

  };
  #outputs is a function of one argument that takes an attribute set of all the realized inputs
  outputs = { self, nixpkgs,nixpkgs-stable,home-manager,determinate,...}@inputs: {
    # replace 'joes-desktop' with your networking.hostname here.
    packages."x86_64-linux".default = 
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            modules = [ ./nvf-configuration.nix];
          }).neovim;
    
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };    
        modules = [ 
          determinate.nixosModules.default
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
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          #nvf.nixosModules.default
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
