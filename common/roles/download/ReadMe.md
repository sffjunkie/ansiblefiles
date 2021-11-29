# download (and cache)

Checks in a cache bfore downloading a file

cache:
  directory: ''
  packages:
    - url:
      datetime: "{{ lookup('pipe', 'date') }}"
