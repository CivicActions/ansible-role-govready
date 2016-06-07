# ansible-role-govready

Role to install [GovReady](https://github.com/GovReady/govready/).

GovReady is a super easy to use commandline toolkit for running security scans on open source servers and software. Technically, GovReady is a bash wrapper around [OpenSCAP](https://www.open-scap.org/), a NIST certified SCAP toolkit.

GovReady depends upon:
- [OpenSCAP role](https://galaxy.ansible.com/CivicActions/openscap) must be installed on all instances
- [SCAP Security Guide role](https://galaxy.ansible.com/CivicActions/scap-security-guide) must be installed on the GovReady "dashboard" instance.

## Testing

Change to the `tests` directory to run tests locally.

```ShellSession
$ cd tests
```

The `tests` directory contains tests for this role in the form of a Vagrant environment. See the [tests README](https://github.com/CivicActions/ansible-role-govready/blob/master/tests/README.md) for instructions.

## Work in Progress
This role is a work in progress (WIP). It has been used in production, but it is not considered "production ready". Please use at your own risk.

### License
GovReady is copyright (C) GovReady PBC. and licensed under the GPL v3.0
