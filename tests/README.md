# Example Playbook for ansible-role-govready

This directory contains tests for the openprivacy.govready role in the form of a Vagrant environment.

## Test setup

The directory `roles/govready` is a symbolic link that should point to the root of this project in order to work. To create it, do:

```bash
$ ansible-galaxy install openprivacy.govready -p .
```

_Note: If you see_ `[DEPRECATION WARNING]: The comma separated role spec format...` _you can ignore it. There is an [ansible pull request](https://github.com/ansible/ansible/pull/14612) to resolve this._

```bash
$ cd openprivacy.govready/tests
$ mkdir roles
# govready has dependencies openscap and scap-security-guide
$ for ROLE in govready openscap scap-security-guide; do
    ln -frs ../../openprivacy.${ROLE} roles
done
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

_Note: Sometimes the server instance fails to create with lots of errors including e.g. `repomd.xml does not match metalink for epel`. If this happens, retry building the server (and it always seems to work the second time) with these two commands:_

```bash
$ vagrant destroy server
$ vagrant up server
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

You will also be asked for a password, which is "vagrant":

`root@192.168.56.102's password: `_vagrant_

### Dashboard: Interpreting results

- This profile identifies 23 high severity selected controls. OpenSCAP says 16 passing, 5 failing, and 2 notchecked.
- This profile identifies 98 medium severity selected controls. OpenSCAP says 36 passing, 60 failing, and 2 notchecked.
- This profile identifies 60 low severity selected controls. OpenSCAP says 12 passing, 43 failing, and 5 notchecked.

### Dashboard: Execute automated fixes and run a second scan of 'server'

```bash
[vagrant@localhost myfisma]$ govready fix
[vagrant@localhost myfisma]$ govready scan
```
- This profile identifies 4 high severity selected controls. OpenSCAP says 3 passing, 0 failing, and 1 notchecked.
- This profile identifies 12 medium severity selected controls. OpenSCAP says 12 passing, 0 failing, and 0 notchecked.
- This profile identifies 45 low severity selected controls. OpenSCAP says 13 passing, 30 failing, and 2 notchecked.

### Dashboard: Execute automated fixes with remediation functions and run a third scan of 'server'

```bash
$ ssh root@192.168.56.102 mkdir /usr/share/scap-security-guide
$ scp /usr/share/scap-security-guide/remediation_functions 192.168.56.102:/usr/share/scap-security-guide
```

- This profile identifies 4 high severity selected controls. OpenSCAP says 3 passing, 0 failing, and 1 notchecked.
- This profile identifies 12 medium severity selected controls. OpenSCAP says 12 passing, 0 failing, and 0 notchecke.d
- This profile identifies 45 low severity selected controls. OpenSCAP says 40 passing, 3 failing, and 2 notchecked.
