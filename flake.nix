{
  description = "gnome framework nixos root flake";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  outputs = { self, nixpkgs }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
