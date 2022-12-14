RHEL7 native vs dev-c7
======================

The ``dev-c7`` container attempts to emulate the same environment and file systems
that a DLS RHEL7 workstation sees. Inevitably there are a few differences
which are documented on this page.

Centos vs RHEL7
---------------

This container is based upon a Centos 7 image rather than a RHEL7 image
because of complicated licensing for RHEL7 containers. In almost all
respects this should make little difference because both OSes have the
same packages available to them.

Any code that queries the OS name will get a different answer. This affects
dls-release.py because it uses the OS name to choose the default RHEL version
to release to. However this has been patched to accept Centos 7 to mean
a release for RHEL7.

We are not aware of any other DLS tools affected by this at present.

User IDs
--------

Inside of the container there are only two interactive users. Your own user
and root. ``c7`` uses ``--userns=keep-id`` so that your same user id
is used inside and outside of the container.

Hence the container is able to see the file ownership of mounted file systems
as long as they belong to root or to you.

No other users are known to it and when listing the contents of
a shared directory any files that have unknown user group membership will
show up as uid or gid 65534.

This does not affect your ability to write to files that have permission for
your secondary group. So files with group write for the dcs account will
be writeable. Unfortunately you will not be able to tell they are writeable
by using ls -l because the dcs group is unknown inside the container.

e.g.

.. raw:: html

    <pre><font color="#64BA12">(master) </font>[<font color="#6491CB">hgv27681@dev-c7</font> etc]$ pwd
    /dls_sw/work/R3.14.12.7/support/BL16I-BUILDER/etc
    <font color="#64BA12">(master) </font>[<font color="#6491CB">hgv27681@dev-c7</font> etc]$ &gt; giles-wrote-this.txt
    <font color="#64BA12">(master) </font>[<font color="#6491CB">hgv27681@dev-c7</font> etc]$ ls -l
    total 24
    -rw-rw-r--. 1 hgv27681 65534     0 Jun 24 10:25 giles-wrote-this.txt
    -rwxrwxr-x. 1    65534 65534  1018 Feb 21  2019 <font color="#8AE234"><b>home_pa_slits.py</b></font>
    -rw-rw-r--. 1    65534 65534   269 Feb 21  2019 Makefile
    drwxrwsr-x. 5    65534 65534 16384 Jun 13 16:41 <font color="#729FCF"><b>makeIocs</b></font>
    -rw-rw-r--. 1    65534 65534    29 Feb 21  2019 module.ini
    </pre>


No Services
-----------

By default a container runs a single process (of id 1) and terminates when
that process terminates. ``c7.sh`` launches a background process
that does nothing as process 1 and
then executes any number of interactive shells inside of it.

Although you
have the filesystem of a Centos 7 workstation inside the
container, by design it is not an entire virtual machine.

Therefore none of the usual services will be running inside of the container.
For example any apps that wish to communicate over DBus will not find the DBus
service.

So far this has not affected any DLS development workflow. It may be possible
to launch services inside the container if they prove to be essential.
