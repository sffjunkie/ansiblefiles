# config_files

The `laptop` playbook writes a JSON file to `build/configfiles.json` which
inlcudes information on what config files to create and their contents.

This file is then read by the `config_files` playbook and is used to create
the actual config files from a set of files and templates.

The config file templates can be found in a
[separate repository](https://github.com/sffjunkie/configfiles-templates)

The output config files can be [found here](https://github.com/sffjunkie/configfiles)
