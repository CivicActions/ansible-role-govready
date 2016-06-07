# Example Playbook for ansible-role-govready

## Requirements

- ansible v1.9.1 or higher
- vagrant v1.7.4 or higher

This directory contains tests for the CivicActions.govready role in the form of a Vagrant environment.

## Test setup

Install the `govready` role into a newly created `roles/` directory and add two supporting roles: the openscap scanner and the scap-security-guide content:

```bash
$ ansible-galaxy install CivicActions.govready -p .
$ cd CivicActions.govready/tests
$ mkdir roles
$ ansible-galaxy install CivicActions.openscap CivicActions.scap-security-guide -p roles
$ ln -fs ../../../CivicActions.govready roles/CivicActions.govready
```

You may want to change the base box into one that you like. The current one is based on geerlingguy's [CentOS 7 box](https://atlas.hashicorp.com/geerlingguy/boxes/centos7).

The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting role variables.

## Run the commands below on the indicated machine
Key:

- *Host* - the machine which is hosting your Vagrant virtual machines (VMs)
- *Dashboard* - the VM that will be running scans on a remote server (IP=192.168.56.101)
- *Server* - the VM that will be scanned and hardened (IP=192.168.56.102)

### Host: Provision two vagrant machines: dashboard and server:

First create an SSH key pair to be used by oscap-user, then create and provision the two vagrant test servers.

```bash
$ ./create_keys.sh
$ vagrant up
```

### Dashboard: Run the first scan of 'server'
_Note: The myfisma/GovReadyfile was set up during provisioning._

```bash
$ vagrant ssh dashboard
[vagrant@localhost ~]$ cd myfisma
[vagrant@localhost myfisma]$ govready scan
```

Since this is the first time that the Dashboard is connecting to the Server, you will be asked:

`Are you sure you want to continue connecting (yes/no)? `_yes_

### Dashboard: Interpreting results

- This profile identifies 23 high severity selected controls. OpenSCAP says 16 passing, 5 failing, and 2 notchecked.
- This profile identifies 96 medium severity selected controls. OpenSCAP says 34 passing, 60 failing, and 2 notchecked.
- This profile identifies 60 low severity selected controls. OpenSCAP says 12 passing, 43 failing, and 5 notchecked.

### Host: `./scans/` directory

Look in the newly created `./scans/` directory for the results of the OpenSCAP scan of the `server` instance.

### Dashboard: Scan your own sites

By setting the environment variables `GOVREADY_OSCAP_USER` (must have sudo capability) and `GOVREADY_OSCAP_HOST` you can scan any host that has openscap installed. E.g.,

```bash
	[vagrant@localhost myfisma]$ export GOVREADY_OSCAP_USER=rootable
	[vagrant@localhost myfisma]$ export GOVREADY_OSCAP_HOST=myhost.example.com
	[vagrant@localhost myfisma]$ govready scan
```

All the variables in UPPER case in the GovReadyFile can be overridden with environment variables prefixed with `GOVREADY_`

Note that the remote sites don't need govready nor the scap-security-guide, but they will need the OpenSCAP scanner. See the README for ansible-roles-openscap for information on how to install the latest copy.

### Remediation. This section is a work in progress

_Note: The process for remediation is in flux and `govready fix` no longer works. Currently we are using the [simple-harden](https://galaxy.ansible.com/CivicActions/simple-harden/) role which is still being tested._

For testing with your vagrant boxes created above, first install the `simple-harden` role:
```bash
ansible-galaxy install CivicActions.simple-harden -p roles
```

Then create two files:

1: `harden-inventory`:
```bash
localhost      ansible_connection=local ansible_python_interpreter=/usr/bin/python2

[servers]
192.168.56.102 	ansible_ssh_user=vagrant
```

2: `harden-playbook.yml`:
```bash
- name: Harden all servers
  hosts: servers
  roles:
    - { role: CivicActions.simple-harden, become: true }
```

Then run the harden process:
```bash
ansible-playbook -i harden-inventory harden-playbook.yml
```

The results can be seen by logging into the dashboard again and re-running `govready scan`:

- This profile identifies 23 high severity selected controls. OpenSCAP says 18 passing, 3 failing, and 2 notchecked.
- This profile identifies 96 medium severity selected controls. OpenSCAP says 62 passing, 32 failing, and 2 notchecked.
- This profile identifies 60 low severity selected controls. OpenSCAP says 40 passing, 15 failing, and 5 notchecked.

## Next steps:

- Refactor, probably to Python
- Accept a (yaml) configuration file to define the dashboard and a set of servers
