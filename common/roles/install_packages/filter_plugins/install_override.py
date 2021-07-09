class FilterModule(object):
    def filters(self):
        return {
            "install_overrides_by_name": self.overrides_by_name,
            "install_override_is_package": self.is_package,
            "install_override_is_role": self.is_role,
        }

    def overrides_by_name(self, overrides, os_family, distribution):
        result = dict()
        for key, value in overrides.items():
            r = {}
            try:
                r["package"], os_or_dist = key.split(".")
                if os_family != os_or_dist and distribution != os_or_dist:
                    continue
                r["os_or_dist"] = os_or_dist
            except ValueError:
                r["package"] = key

            for i, v in value.items():
                r[i] = v

            if "install" not in r:
                r["install"] = "package"

            i = r.pop("package")
            result[i] = r

        return result

    def is_package(self, package, package_info):
        return package not in package_info or (
            package in package_info and package_info[package]["install"] == "package"
        )

    def is_role(self, package, package_info):
        # return True
        return package in package_info and package_info[package]["install"] == "role"
