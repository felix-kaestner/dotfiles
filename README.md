# dotfiles

This is a collection of my system configuration files I use on several Linux machines and my personal computer, shared here for your and my convenience.
These files are strongly opinionated. 
While being a *nix user I currently use a Windows 11 machine with [WSL](https://docs.microsoft.com/de-de/archive/blogs/wsl/windows-subsystem-for-linux-overview). 
This allows me to use things like Windows Hello or the Windows Precision Drivers that are both supported from my machine while still enjoying Linux.

## WSL

- [Install WLS2](https://docs.microsoft.com/de-de/windows/wsl/wsl2-install)

## Docker

- [Install Docker Desktop](https://docs.docker.com/docker-for-windows/wsl-tech-preview/)

I personally like to leverage a lot of features introduced by the [buildkit](https://github.com/moby/buildkit) project, which I enable by either setting a environment
variable `DOCKER_BUILDKIT=1` or by inserting  
```json
  ...
  "features": {
    "buildkit": true
  }
  ...
```
inside the docker deamon configuration.
I also use the new [experimental syntax](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md) provided by the `buildkit` project.

## Usage

```bash
$ ./script/bootstrap
```
