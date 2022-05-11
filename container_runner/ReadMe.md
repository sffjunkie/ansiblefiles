# container_machine

Installs container management software on a (virtual) machine_config.

* docker
* docker-compose

# Service creation

* Create service directory in /srv
* copy docker-compose.yaml file from `service_files` directory to service directory
* Copy env files to service directory

## TODO

* [ ] Add vagrant user to docker group.
    * [ ] Find out how to test if vagrant is installed
* [ ] Data - Directory alongside docker-compose or common directory
      e.g. /srv/data/service or /srv/service/data
