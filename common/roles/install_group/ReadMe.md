# `install_group` Role

Installs a group of packages.

Should be passed a `group` dictionary which defines what gets installed.
Under the `group` dictionary can be any of the following keys

* `packages`
* `pypi`
* `pipx`
* `git`
* `npm`

These keys contain a list of items to install.

For items under the packages key unless they are overriden they will be installed using the system package manager

By adding an override this can be changed to using a role.

[Overrides](#Overrides) are specified by passing as an `overrides` dictionary to the `install_group` role

If a key `name` is included in the `group` dictionary then a message will be printed to stdout beforfe installing the packages

## Overrides

Each key is of the form

    <package>

or

    <package>.<osfamily_or_distribution>

where `osfamily_or_distribution` is the ansible `ansible_os_family` or `ansible_distribution` fact.

Under this key should be a subkey '`install`' that signifies which override method is to be used.
Currently only the value 'role' is recognized.

e.g.

* When using the first form, if the key '`alacritty`' is included as an override with an install key of '`role`'
then a role named 'alacritty' will be used.

* When using the second form, if the key '`inkscape.ubuntu`' is included then Inkscape will be installed using a role
on Ubuntu and with the system package manager on other operating systems/distributions.

## Install location override

The group can also contain a key `location` with a value of either '`user`', '`system`' or '`global`'
that determines where the package types are installed.

### `pypi`

For `pypi` if the location override is '`user`' then the '`--user`' flag will be passed to the `pip` command.
Using the value '`system`' is the same as omitting the key and packages will be installed into
the global `PYTHONPATH`.

### `npm`

For `npm` if the location override is '`global`' then packages will be installed in the global NPM packages directory.
An additional override can be specified using the
