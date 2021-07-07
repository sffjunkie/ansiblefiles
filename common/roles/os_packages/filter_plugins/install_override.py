class FilterModule(object):
    def filters(self):
        return {"_install_types": self.install_types}

    def install_types(self, overrides, os_family, distribution):
        result = dict(package=[], role=[], compile=[])
        for key, value in overrides.items():
            r = {}
            try:
                r["package"], os_or_dist = key.split(".")
                if os_family != os_or_dist and distribution != os_or_dist:
                    continue
            except ValueError:
                r["package"] = key

            for i, v in value.items():
                r[i] =  v

            i = r.pop("install")
            result[i].append(r)

        return result
