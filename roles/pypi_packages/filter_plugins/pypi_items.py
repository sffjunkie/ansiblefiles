class FilterModule(object):
    """Converts a list of strings or dicts to list of dicts.

    The return value is a list of dicts of the following form

        { name: required, version: optional, env: optional }

    strings in the list are used as the name key.

    where
        version is a PEP-0440 comparison version - https://www.python.org/dev/peps/pep-0440/#id53
        env is a PEP-0508 environment marker - https://www.python.org/dev/peps/pep-0508/#id24
    """
    def filters(self):
        return {"to_pypi_dict": self.to_pypi_dict}

    def to_pypi_dict(self, items):
        pypi_items = []
        for item in items:
            if item is None:
                continue

            if isinstance(item, str):
                d = dict(name=item, version="", env="")
            elif isinstance(item, dict):
                d = dict(name=item.get("name", ""),
                    version=item.get("version", ""),
                    env=item.get("env", ""))
            pypi_items.append(d)
        return pypi_items
