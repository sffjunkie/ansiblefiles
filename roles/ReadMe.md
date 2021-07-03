# Common Ansible Roles

* [base16_shell](#base16_shell)
* [bat](#bat)
* [copyconfig](#copyconfig)
* [docker](#docker)
* [exa](#exa)
* [font](#font)
* [git](#git)
* [ohmyzsh](#ohmyzsh)
* [os_packages_ansible](#os_packages_ansible)
* os_packages_system
* pypi_packages
* ssh
* ufw
* update
* user_add
* user_ssh
* zsh

## <span id="base16_shell">base16_shell</span>

Installs

* base16-shell
* base16-shell-preview

Adds configuration info to the configfiles fact.

## <span id="bat">bat</span>

Installs bat and adds an alias to the configfiles fact

## <span id="copyconfig">copyconfig</span>

Copies the generated configuration files to the target machine

## <span id="docker">docker</span>

Installs docker using os specific steps e.g. on Ubuntu it adds a PPA to install

## <span id="exa">exa</span>

Installs exa either from the os package repository or from Github.

Installation from Github is provided as prior to Ubuntu 20.10 there was no os
provided package.

## <span id="font">font</span>

Installs a font from a url onto the system and updates the font cache.

### Variables

* `font_url` - the url of the font to install.

## <span id="git">git</span>

Installs git and configures the global git user, email and GPG keys.

On Ubuntu it will use the PPA otherwise the os provided package is used.

### Variables

* `name` - the user name for git to use.
* `email` - the user email for git to use.
* `gpg_key` - optional GPG key for git to use.

## <span id="ohmyzsh">ohmyzsh</span>

* Installs Oh-My-Zsh and plugins.
* Adds configuration info to the configfiles fact.

## <span id="os_packages_ansible">os_packages_ansible</span>

Installs os packages needed for the Ansible playbook to run.

## <span id="pypi_packages">pypi_packages</span>

Install a list of packages from pypi using pip

## <span id="ssh">ssh</span>

Updates the SSH configuration to disable password authentication, disable root login and change the SSH port (including updating the firewall rules)

### Variables

* `ssh_port` - the SSH port number to use.
