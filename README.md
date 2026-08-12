<div align="center">
<h1>
<img width="72" src="https://r2.jervw.dev/nixos.svg"></img> <br>
  jervw's dotfiles
</h1>
</div>

## :spiral_notepad: Features

- [NNN-stack](https://the-nnn-stack.github.io/). (NixOS + Niri + Noctalia)
- Opt-in impermanence
- Full-disk encryption and Secure Boot
- Agenix for secrets management
- Built with [Snowfall-lib](https://github.com/snowfallorg/lib)
- Podman containers managed with [quadlet-nix](https://github.com/SEIAROTg/quadlet-nix)
- Linted and styled with [alejandra](https://github.com/kamadorueda/alejandra), [deadnix](https://github.com/astro/deadnix), and [statix](https://github.com/nerdypepper/statix)

## Hosts

- **loki** — desktop
- **fenrir** — T2 MacBook Air
- **thor** — homelab

## Layout

- `systems/` — host configurations
- `homes/` — home-manager configurations
- `modules/` — reusable NixOS and home-manager modules
- `secrets/` — Agenix-encrypted secrets

Most self-hosted services live in `modules/nixos/services`. Services that do not have a NixOS module are run as rootless Podman containers through Quadlet.

## Applying a configuration

For example, to deploy `loki`:

```sh
nixos-rebuild switch --flake .#loki
```

## Contributing

Contributions and issues are welcome. These are personal dotfiles, though, so I cannot provide support for problems specific to your setup.

## :bulb: Acknowledgments

people who've inspired me and have stolen stuff from

<p align="center">
  <a href="https://github.com/fufexan">Fufexan</a> •
  <a href="https://github.com/sioodmy">Sioodmy</a> •
  <a href="https://github.com/NotAShelf">NotAShelf</a> •
  <a href="https://github.com/notohh">Notohh</a> •
  <a href="https://github.com/Misterio77">Misterio77</a> •
  <a href="https://github.com/Mic92">Mic92</a> •
  <a href="https://github.com/viperml">ViperML </a> •
  <a href="https://github.com/hlissner">Hlissner</a>
  <a href="https://github.com/khaneliman">Khaneliman</a>
</p>
<p align="center">
  and many others...
</p>
