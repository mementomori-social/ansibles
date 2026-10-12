#!/usr/bin/env bash
# mementomori.test on this machine (macOS, Arch, Debian, Ubuntu). See README.md.
# Extra arguments go to ansible-playbook, for example -e dev_vm_seed_scale=default
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v ansible-playbook >/dev/null; then
  if command -v brew >/dev/null; then
    brew install ansible
  elif command -v pacman >/dev/null; then
    sudo pacman -S --needed --noconfirm ansible
  elif command -v apt-get >/dev/null; then
    sudo apt-get update && sudo apt-get install -y ansible
  else
    echo "Install Ansible first: https://docs.ansible.com/" >&2
    exit 1
  fi
fi

ansible-galaxy collection install -r collections/requirements.yml -p collections >/dev/null

# Asked here in plain words instead of Ansible's "BECOME password" prompt.
read -rsp "Your login password (for sudo): " DEV_SUDO_PASS
echo
printf '%s\n' "$DEV_SUDO_PASS" | sudo -S -k -p '' -v 2>/dev/null || { echo "Wrong password." >&2; exit 1; }
export DEV_SUDO_PASS

# ansible.cfg points at the production vault password, which dev never reads.
ANSIBLE_VAULT_PASSWORD_FILE=<(echo unused) \
  ansible-playbook -i inventory-dev.yml dev.yml "$@"
