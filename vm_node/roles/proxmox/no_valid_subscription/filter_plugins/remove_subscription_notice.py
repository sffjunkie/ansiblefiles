"""Disable 'PVE nio subscription message"""
import re


def proxmox_remove_subscription_notice(file_contents: str) -> str:
    """Replace line that displays message to skip it"""
    prev_line_re = re.compile(r"\s+.data.status.toLowerCase\(\) !== \'active\'\) {")
    line_to_replace_re = re.compile(r"(\s+)Ext.Msg.show\({")

    _contents = file_contents.split("\n")
    lines = _contents[:2]

    for idx, line in enumerate(_contents[1:]):
        match_prev_line = prev_line_re.search(lines[0])
        match_line = line_to_replace_re.search(lines[1])
        if match_prev_line and match_line:
            _contents[idx] = f"{match_line.group(1)}void({{"
            break

        lines[0] = lines[1]
        lines[1] = line

    return "\n".join(_contents)


class FilterModule:  # pylint: disable=too-few-public-methods
    """Ansible filter to remove Proxmox subscription notice"""

    def filters(self):  # pylint: disable=no-self-use
        """Return list of filters"""
        return {
            "proxmox_remove_subscription_notice": proxmox_remove_subscription_notice,
        }
