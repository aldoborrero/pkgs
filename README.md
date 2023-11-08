# (nix) pkgs

My custom repository of `(nix) pkgs` that I plan to either upstream to `nixpkgs` or keep here as they don't make sense to share.

It follows the regular conventions of `nixpkgs` (specially following the conventions defined in their [named based package directories](https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name)).

## Usage

### Flakes

You can add my `pkgs` repository as a regular flake input:

```nix
{
    inputs = {
        pkgs = {
            url = "github:aldoborrero/pkgs";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
```

And use it as a regular flake input to access it's packages by system or add them to your `nixpkgs` as an overlay.

### Niv

Thanks to `flake-compat` you can also use this repository without flakes! Make sure you import it with:

```console
$ niv add aldoborrero/pkgs
```

And add the overlay to your `nixpkgs` import with `niv`:

```console
{system ? builtins.currentSystem}: let
  sources = import ./sources.nix;

  # overlays
  pkgs = import sources.pkgs;
in
  import sources.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays =
      [
        pkgs.overlays.default
      ];
  }
```

## License

See [License](./LICENSE) for more information.
