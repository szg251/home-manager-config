with import <nixpkgs> {};

{
  environment.systemPackages = [
    (python.withPackages [ python27Packages.pynvim ])
    (python3-3.8.withPackages [ python38Packages.pynvim ])
  ];

  allowUnfree = true;
}
