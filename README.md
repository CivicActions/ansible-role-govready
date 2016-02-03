# ansible-role-govready

Role to install [GovReady](https://github.com/GovReady/govready/).

GovReady is a super easy to use commandline toolkit for running security scans on open source servers and software. Technically, GovReady is a bash wrapper around [OpenSCAP](https://www.open-scap.org/), a NIST certified SCAP toolkit.

GovReady depends upon the [OpenSCAP role](https://galaxy.ansible.com/openprivacy/openscap) being installed, which in turn depends upon the [SCAP Security Guide role](https://galaxy.ansible.com/openprivacy/scap-security-guide).

### Work in Progress
This role is a work in progress (WIP). It is not ready for general use as paths are currently hardwired, and there are likely other, non-portable issues.

### License
GovReady is copyright (C) GovReady PBC. and licensed under the GPL v3.0
