import re
from typing import List


class FilterModule(object):
    def filters(self):
        return {
            "proxmox_remove_subscription_notice": self.proxmox_remove_subscription_notice,
        }

    def proxmox_remove_subscription_notice(self, file_contents: str) -> str:
        prev_line_re = re.compile(r"\s+.data.status.toLowerCase\(\) !== \'active\'\) {")
        line_re = re.compile(r"(\s+)Ext.Msg.show\({")

        _contents = file_contents.split("\n")
        lines = _contents[:2]

        for idx, line in enumerate(_contents[1:]):
            match_prev_line = prev_line_re.search(lines[0])
            match_line = line_re.search(lines[1])
            if match_prev_line and match_line:
                _contents[idx] = f"{match_line.group(1)}void({{"
                break

            lines[0] = lines[1]
            lines[1] = line

        return _contents.join('\n')
