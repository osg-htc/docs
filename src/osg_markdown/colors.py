import re

from markdown.postprocessors import Postprocessor
from markdown.extensions import Extension

class ColorPostprocessor(Postprocessor):
    """ Take care of twiki-like colors """

    colors = ['blue', 'gray', 'purple', 'fuchsia', 'aqua', 'maroon', 'olive',
              'black', 'yellow', 'teal', 'navy', 'green', 'white', 'silver',
              'red', 'lime']

    def __init__(self):
        pass

    def run(self, text):
        for color in self.colors:
            text = text.replace("%%%s%%" % color.upper(), '<span style="color:%s">' % color)
        text = text.replace("%ENDCOLOR%", '</span>')
        return text

class ColorExtension(Extension):
    """ Allow colors to be added to Markdown """

    def __init__(self, *args, **kw):
        self.processor = ColorPostprocessor()

    def extendMarkdown(self, md, md_globals):
        md.postprocessors.add('color', self.processor, '_end')

def makeExtension(*args, **kwargs):
    return ColorExtension(*args, **kwargs)
