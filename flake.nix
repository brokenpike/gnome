{
  description = "gnome framework nixos root flake";
  # inputs are an attribute set
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      #url = "git+file:///home/scott/Documents/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  #outputs is a function of one argument that takes an attribute set of all the realized inputs
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      determinate,
      omarchy-nix,
      ...
    }@inputs:
    {
      # replace 'joes-desktop' with your networking.hostname here.
      #packages."x86_64-linux".default =
      # (inputs.nvf.lib.neovimConfiguration {
      #   pkgs = nixpkgs.legacyPackages."x86_64-linux";
      #   modules = [ ./nvf-configuration.nix ];
      #}).neovim;

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
            omarchy-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              # Configure omarchy
              omarchy = {
                full_name = "brokenpike";
                email_address = "brokepike@garmr.org";
                theme = "tokyo-night";
              };
              # enables use of stable overlay in home-manger
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.scott.imports = [
                ./home.nix
                omarchy-nix.homeManagerModules.default
              ];

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };
    };
}
