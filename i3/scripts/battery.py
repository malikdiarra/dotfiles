#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import subprocess

# Battery 0: Discharging, 97%, 04:23:00 remaining
# Battery 0: Full, 100%


def parse(output):
    fragments = list(map(str.strip, output.decode('utf-8')
                     .split(':', 1)[1].split(',')))
    return fragments[0].strip(), int(fragments[1].strip()[:-1]), None


icons = [(8, ''),
         (30, ''),
         (90, ''),
         (101, '')]

colors = [(20, '#FF0000'),
          (40, '#FFAE00'),
          (60, '#FFF600'),
          (85, '#A8FF00')]


def print_status():
    status, charge, remaining = parse(subprocess.check_output("acpi"))
    for icon in icons:
        if charge < icon[0]:
            i = icon[1]
            break
    short_text = "{}%".format(charge)
    full_text = i + short_text
    if status == 'Discharging':
        full_text += ' DIS{}'.format('' if remaining is None else remaining)
    if status == 'Charging':
        full_text += ' CHR{}'.format('' if remaining is None else remaining)
    print(full_text)
    print(short_text)
    if status == 'Discharging':
        for color in colors:
            if charge < color[0]:
                print(color[1])
                break


if __name__ == "__main__":
    print_status()
