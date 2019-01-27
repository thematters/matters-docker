#!/usr/bin/python3
# -*- coding: utf-8 -*-
import logging
import os
import subprocess

from datetime import datetime
from urllib import request

dir_path = os.path.dirname(os.path.realpath(__file__))
log_path = os.path.join(dir_path, 'logs')
log_file = 'ipfs_cluster_%s.log' % datetime.now().strftime('%Y-%m-%d')

if not os.path.exists(log_path):
    os.mkdir(log_path)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.join(dir_path, log_path, log_file)),
        logging.StreamHandler()
    ])
logger = logging.getLogger(__name__)


def add_cluster_pin(cid):
    logger.info('pining: %s' % cid)
    q = request.Request('http://localhost:9095/api/v0/pin/add?arg=%s' % cid)
    result = request.urlopen(q).read()
    logger.info(result)


def get_daemon_cids():
    output = subprocess.check_output(
        ['docker-compose', 'exec', '-T', 'daemon', 'ipfs', 'pin', 'ls'])
    return [l.split()[0] for l in output.decode('utf-8').splitlines()]


def get_cluster_cids():
    output = subprocess.check_output([
        'docker-compose', 'exec', '-T', 'cluster', 'ipfs-cluster-ctl', 'pin',
        'ls'
    ])
    return [l.split()[0] for l in output.decode('utf-8').splitlines()]


if __name__ == '__main__':
    daemon_cids = get_daemon_cids()
    cluster_cids = get_cluster_cids()
    cids = [cid for cid in daemon_cids if cid not in cluster_cids]

    for cid in cids:
        add_cluster_pin(cid)

    logger.info('==DONE==')
