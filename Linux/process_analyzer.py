#!/usr/bin/env python3
# Linux Process Analyzer v1.0.0
# Visualizes parent-child relationships of running processes

import psutil
import json
from collections import defaultdict

def get_process_tree():
    """Build a process tree with parent-child relationships"""
    processes = {}
    children = defaultdict(list)
    
    # Gather all processes
    for proc in psutil.process_iter(['pid', 'ppid', 'name', 'cmdline']):
        try:
            info = proc.info
            processes[info['pid']] = {
                'pid': info['pid'],
                'ppid': info['ppid'],
                'name': info['name'],
                'cmdline': info['cmdline'],
                'children': []
            }
            children[info['ppid']].append(info['pid'])
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue
    
    # Build tree structure
    for pid, proc in processes.items():
        proc['children'] = [processes[child] for child in children.get(pid, [])]
    
    # Find root processes (ppid = 0)
    return [proc for pid, proc in processes.items() if proc['ppid'] == 0]

def main():
    try:
        process_tree = get_process_tree()
        print(json.dumps({
            'status': 'success',
            'process_tree': process_tree
        }, indent=2))
    except Exception as e:
        print(json.dumps({
            'status': 'error',
            'message': str(e)
        }))
        exit(1)

if __name__ == '__main__':
    main()
