class FilterModule(object):
    """Converts a string to a list with one element or does nothing"""
    def filters(self):
        return {"listify": self.listify}

    def listify(self, item):
        return [item] if isinstance(item, str) else item
