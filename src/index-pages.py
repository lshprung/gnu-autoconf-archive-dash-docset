#!/usr/bin/env python3

import os
import re
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "..", "..", "..", "scripts"))
from create_table import create_table
from get_title import get_title
from insert import insert

class Index_pages:
    def __init__(self, db_path):
        self.db_path = db_path

    def get_type(self, html_path):
        html_path = os.path.basename(html_path)
        macro_pattern = re.compile("^ax_")

        if re.search(macro_pattern, html_path):
            return "Macro"
        else:
            return "Guide"

    def insert_page(self, html_path):
        base_html_path = os.path.basename(html_path)

        page_name = get_title(html_path)
        page_name = page_name.replace('(Autoconf Archive)', '')

        page_type = self.get_type(html_path)

        insert(self.db_path, page_name, page_type, base_html_path)

if __name__ == '__main__':
    db_path = sys.argv[1]

    main = Index_pages(db_path)

    create_table(db_path)
    for html_path in sys.argv[2:]:
        main.insert_page(html_path)
