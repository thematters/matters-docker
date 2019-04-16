#!/bin/python
import os
import sys


if __name__ == '__main__':
    current_dir = os.path.dirname(os.path.realpath(sys.argv[0]))
    raw_dict = os.path.join(current_dir, 'cilin_ex.txt')
    to = os.path.join(current_dir, 'synonyms.txt')

    with open(raw_dict) as f, open(to, 'w') as to:
        words = [l.split() for l in f.readlines()]

        # remove lines starts with @ and the first element of each line
        filtered_words = [wl[1:] for wl in words if not wl[0].endswith('@')]
        synonyms = [','.join(wl) for wl in filtered_words]

        for l in synonyms:
            to.write(l + os.linesep)
