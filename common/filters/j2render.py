from typing import List, Union
import jinja2


class FilterModule(object):
    """Renders a jinja2 template with values"""

    def filters(self) -> dict:
        return {
            "j2render": self.j2render,
            "j2render_list": self.j2render_list
        }

    def j2render(self, template: Union[str, List[str]], values: dict) -> str:
        if isinstance(template, str):
            return jinja2.Template(template).render(values)

    def j2render_list(self, templates: List[str], values: dict) -> List[str]:
        return [self.j2render(template, values) for template in templates]
