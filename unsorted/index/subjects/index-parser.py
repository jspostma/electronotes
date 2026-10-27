#!/usr/bin/python3

import yaml
from pprint import pprint


class IndexEntry:
    def __init__(self, subject, items=None, references=None, comment=None):
        self.subject = subject
        if items:
            self.items = items
        else:
            self.items = []
        
        if references:
            self.references = references
        else:
            self.references = []
        
        self.comment = comment



def load_yaml(fname):
    with open(fname, 'r') as fd:
        return yaml.safe_load(fd)


def parse_items(items):
    pass


def parse_entry(subject, data):
    pass
            
