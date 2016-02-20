# Example Playbook for ansible-role-govready

This directory contains tests for the openprivacy.govready role in the form of a Vagrant environment.

### Test setup

The directory `roles/govready` is a symbolic link that should point to the root of this project in order to work. To create it, do:

```ShellSession
$ mkdir roles
# govready has dependencies openscap and scap-security-guide
$ for ROLE in govready openscap scap-security-guide; do
    ln -frs ../../openprivacy.${ROLE} roles
done
$ ln -frs ../../geerlingguy.git roles/
```

You may want to change the base box into one that you like. The current one is based on geerlingguy's [CentOS 7 box](https://atlas.hashicorp.com/geerlingguy/boxes/centos7).

The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting role variables.

## Run the commands below on the indicated machine
Key:
- *Host* - the machine which is hosting your Vagrant virtual machines (VMs)
- *Dashboard* - the VM that will be running scans on a remote server (IP=192.168.56.101)
- *Server* - the VM that will be scanned and hardened (IP=192.168.56.102)

### Host: Provision two vagrant machines: dashboard and server:

```ShellSession
$ vagrant up
```

### Dashboard: Run the first scan of 'server'
_Note: The myfisma/GovReadyfile was set up during provisioning._
```ShellSession
vagrant ssh dashboard
cd myfisma
govready scan
```

Since this is the first time that the Dashboard is connecting to the Server, you will be asked:
`Are you sure you want to continue connecting (yes/no)? `_yes_

You will also be asked for a password, which is "vagrant":
`root@192.168.56.102's password: `_vagrant_

### Dashboard: Interpreting results
- This profile identifies 4 high severity selected controls. OpenSCAP says 3 passing, 0 failing, and 1 notchecked.
- This profile identifies 12 medium severity selected controls. OpenSCAP says 5 passing, 7 failing, and 0 notchecked.
- This profile identifies 45 low severity selected controls. OpenSCAP says 7 passing, 36 failing, and 2 notchecked.

### Dashboard: Execute automated fixes and run a second scan of 'server'

```ShellSession
govready fix
govready scan
```
- This profile identifies 4 high severity selected controls. OpenSCAP says 3 passing, 0 failing, and 1 notchecked.
- This profile identifies 12 medium severity selected controls. OpenSCAP says 12 passing, 0 failing, and 0 notchecked.
- This profile identifies 45 low severity selected controls. OpenSCAP says 13 passing, 30 failing, and 2 notchecked.
