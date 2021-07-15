from typing import List


class FilterModule(object):
    def filters(self):
        return {
            "vscode_extension_install_strings": self.vscode_extension_install_strings,
            "vscode_extension_settings": self.vscode_extension_settings,
        }

    def _install_info_to_str(self, extension: str, install_info: dict) -> str:
        item = extension
        if "version" in install_info:
            item += f"@{install_info['version']}"
        return item

    def vscode_extension_install_strings(self, vscode_info: dict) -> List[str]:
        install_info = []
        for extensions in vscode_info.values():
            if isinstance(extensions, dict):
                for name, value in extensions.items():
                    i = self._install_info_to_str(name, value)
                    install_info.append(i)
        return install_info

    def vscode_extension_settings(self, extension_info: dict) -> dict:
        def _process(extension_point, setting, settings):
            r = {}
            for value in extension_point.values():
                if value.get("disabled", False) == True:
                    continue

                first = setting not in settings
                if first:
                    if "id" in value:
                        settings[setting] = value["id"]

                    if "settings" in value:
                        for k,v in value["settings"].items():
                            settings[k] = v
            return r

        settings = {}
        _process(extension_info["colors"], "workbench.colorTheme", settings)
        _process(extension_info["icons"], "workbench.iconTheme", settings)
        _process(extension_info["productIcons"], "workbench.productIconTheme", settings)
        return settings
