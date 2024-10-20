{
  description = "gnome framework nixos root flake";
  # inputs are an attribute set
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
    };

  };
  #outputs is a function of one argument that takes an attribute set of all the realized inputs
  outputs = { self, nixpkgs,...}@inputs: {
    # replace 'joes-desktop' with your networking.hostname here.
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
