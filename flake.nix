{
  description = "gnome framework nixos root flake";
  # inputs are an attribute set
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixos-24.05;
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
    };

  };
  #outputs is a function of one argument that takes an attribute set of all the realized inputs
  outputs = { self, nixpkgs,nixpkgs-stable,...}@inputs: {
    # replace 'joes-desktop' with your networking.hostname here.
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      
      modules = [ 
          {
            nixpkgs.overlays = [
              (final: prev: {
                stable = nixpkgs-stable.legacyPackages.${prev.system};
                # use this variant if unfree packages are needed:
                #stable = import nixpkgs-stable {
                #   inherit system;
                #   config.allowUnfree = true;
                # };
              })
            ];
          }
        ./configuration.nix 
      ];
    };
  };
}
