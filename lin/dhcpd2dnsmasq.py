#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import os
import threading
import re
import argparse


class Options():
    _instance = None
    _lock = threading.Lock()

    @staticmethod
    def get_instance():
        if Options._instance is None:
            with Options._lock:
                Options._instance = Options()
        return Options._instance

    def __init__(self):
        parser = argparse.ArgumentParser(prog=os.path.basename(__file__), add_help=True)
        parser.add_argument('dhcpd_conf',
                            help='path to dhcpd config file')

        self.options = parser.parse_args()

    def __call__(self):
        return self.options


def cmp_by_addr(s1, s2):
    a1 = int(s1.split(',')[-1].split('.')[-1])
    a2 = int(s2.split(',')[-1].split('.')[-1])
    return a1 - a2


def main():
    options = Options.get_instance()()
    dhcpd_conf = options.dhcpd_conf

    re_host = re.compile(r'^\s*host\s+(?P<host>[\w_-]+)', re.IGNORECASE)
    re_mac = re.compile(r'^\s*hardware ethernet\s+(?P<mac>[\w:]{17})', re.IGNORECASE)
    re_addr = re.compile(r'^\s*fixed-address\s+(?P<addr>[\d.]{7,15})', re.IGNORECASE)

    dnsmasq = {}
    dnsmasq_a = []
    host = ''
    with open(dhcpd_conf, 'r') as dhcpd_obj:
        for line in dhcpd_obj:
            try:
                _m = re_host.search(line)
                if _m:
                    host = _m.group('host')
                    if host:
                        dnsmasq[host] = {'host': host}
                _m = re_mac.search(line)
                if _m and host:
                    dnsmasq[host]['mac'] = _m.group('mac')
                _m = re_addr.search(line)
                if _m and host:
                    dnsmasq[host]['addr'] = _m.group('addr')
            except Exception as e:
                print e

    for h in dnsmasq:
        dnsmasq_a.append('dhcp-host={mac},{host},{addr}'.format(**dnsmasq[h]))

    dnsmasq_a = sorted(dnsmasq_a, cmp=cmp_by_addr)

    print '\n'.join(dnsmasq_a)


if __name__ == '__main__':
    main()
