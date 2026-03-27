# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible-based personal machine provisioning for Debian/RedHat Linux workstations. Manages system packages, dev tools, and app configs through ~57 Ansible roles.

## Architecture

- **`machine.yaml`** — Main playbook. Runs against localhost, gathers minimal facts, imports `vault.yaml` for secrets.
- **`roles/`** — Each role is a self-contained Ansible role (e.g., `roles/docker/tasks/main.yaml`). Multi-distro roles use `setup-Debian.yaml` / `setup-RedHat.yaml` conditional imports.
- **`Makefile`** — Orchestrates installation, updates, and first-time bootstrap (installs Bitwarden CLI, pipx, Ansible).
- **`requirements.yaml`** — External Ansible Galaxy roles (currently only `jaredhocutt.jetbrains_toolbox`).

## Conventions

- YAML files use `.yaml` extension (some legacy roles still use `.yml` for handlers).
- Roles support Debian and RedHat via `ansible_os_family` conditionals.
- `force_install` variable (default `false`) controls whether roles re-download/reinstall.
- No CI/CD or test suite — changes are validated by running `make install` on the target machine.
