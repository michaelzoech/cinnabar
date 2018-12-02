#!/usr/bin/env python3
# Parses the output of 'hg status', writes new output with file numbering
# and appends all paths in one line for cinnabar.sh to use for creating
# the environment numbers.
import os
import subprocess
import sys

#modifiers = ['M', 'A', 'R', 'C', '!', '?', 'I', ' ']

blue_color = '\033[36m'
green_color = '\033[32m'
red_color = '\033[31m'

light_magenta_color = '\033[95m'
light_red_color = '\033[91m'
light_yellow_color = '\033[93m'

reset_color = '\033[0m'
bold_color = ''  # '\033\e[1m'
underline_color = ''  # '\033\e[4m'

colors = {
    'M': blue_color,
    'A': green_color,
    'R': red_color,
    'C': blue_color,
    '!': light_yellow_color + bold_color + underline_color,
    '?': light_magenta_color + bold_color + underline_color,
    'I': light_yellow_color + bold_color,
    ' ': light_yellow_color + bold_color,
}


def hg_status():
    process = subprocess.run(
        ["hg", "--color", "never", "status"], check=True, stdout=subprocess.PIPE)
    s = process.stdout.decode()
    paths = []
    lines = s.split("\n")
    counter = 0
    for line in lines:
        line = line.strip()
        if line is "":
            continue
        counter += 1
        path = line[1:].strip()
        mod = line[:1]
        paths.append(path)
        if os.environ.get('COLOR') is "0":
            print("{} [{}] {}".format(mod, counter, path))
        else:
            print("{}{} [{}] {}{}".format(
                colors[mod], mod, counter, path, reset_color))
    print('|'.join(paths))


def main(argv):
    hg_status()


if __name__ == '__main__':
    main(sys.argv)
