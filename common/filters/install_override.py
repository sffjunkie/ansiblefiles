class FilterModule(object):
    def filters(self):
        return {
            "install_overrides_by_name": self.overrides_by_name,
            "install_override_packages": self.is_package,
            "install_override_roles": self.is_role,
            "packages": self.packages,
            "roles": self.roles,
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

    def packages(self, package_list, package_info):
        return [package for package in package_list if self.is_package(package, package_info)]

    def is_role(self, package, package_info):
        # return True
        return package in package_info and package_info[package]["install"] == "role"

    def roles(self, package_list, package_info):
        return [package for package in package_list if self.is_role(package, package_info)]
