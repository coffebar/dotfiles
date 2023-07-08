#!/usr/bin/env python3
from argparse import ArgumentParser
import subprocess
import os

ssh_config_file = "~/.ssh/config"

# Returns a list of all hosts
def get_hosts():

    hosts = []

    def parse_file(filename):
        with open(os.path.expanduser(filename)) as f:
            content = f.readlines()

        for line in content:
            line = line.lstrip()
            # Ignore wildcards
            if line.startswith('Host ') and not '*' in line:
                for host in line.split()[1:]:
                    hosts.append(host)
            if line.startswith('Include ') and not '*' in line:
                filename = line.replace('Include ', '').rstrip()
                try:
                    parse_file(filename)
                except OSError as e:
                    print(e)

    parse_file(ssh_config_file)

    # Removes duplicate entries
    hosts = sorted(set(hosts))

    return hosts

# Returns a newline seperated UFT-8 encoded string of all ssh hosts
def parse_hosts(hosts):
    return "\n".join(hosts).encode("UTF-8")

# Executes wofi with the given input string
def show_wofi(hosts):

    command="wofi -p \"SSH hosts: \" -d -i --hide-scroll"
    
    process = subprocess.Popen(command,shell=True,stdin=subprocess.PIPE,stdout=subprocess.PIPE)
    ret = process.communicate(input=hosts)
    host, rest = ret
    return host

# Switches the focus to the given id
def ssh_to_host(host, terminal, ssh_command):
    command = "{terminal} \'{ssh_command} {host}\'".format(terminal=terminal, ssh_command=ssh_command, host=host)
    process = subprocess.Popen(command,shell=True)

# Entry point
if __name__ == "__main__":
    
    parser = ArgumentParser(description="Wofi based ssh launcher")
    parser.add_argument("terminal", help='Terminal command to use')
    parser.add_argument("--ssh-command", dest='ssh_command', default='ssh', help='ssh command to use (default=ssh)')
    args = parser.parse_args()

    hosts = get_hosts()
    parsed_hosts = parse_hosts(hosts)
    
    selected = show_wofi(parsed_hosts)
    
    selected_host = selected.decode('utf-8').rstrip()
    ssh_to_host(selected_host, args.terminal, args.ssh_command)
