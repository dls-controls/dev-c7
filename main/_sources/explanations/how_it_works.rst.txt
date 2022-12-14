How the dev-c7 Container Works
==============================


Podman
------

Podman is a daemonless, rootless container engine developed by RedHat,
designed as an alternative to Docker.

Using containers allows us to package up all the dependencies of an
application and execute it in an isolated fashion.

In the case of ``dev-c7`` we use podman to package up everything required
by the DLS controls developer workflow. This is essentially a set
of system libraries and tools plus mounted shared file systems such
as ``/dls_sw`` and ``/home``.

Containers
----------

A quote from docker.com:

.. tip::

    A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.

An image is a layered snapshot of a file system. Images adhere to the
`Open Container Initiative <https://opencontainers.org/release-notices/v1-0-2-image-spec/>`_
standard and therefore images built by Docker and Podman are interchangeable.

Images are stored in a container registry such as DockerHub or GitHub Container
Registry https://ghcr.io. The image for ``dev-c7`` is stored alongside its source
code here:

    https://ghcr.io/dls-controls/dev-c7:latest

The ``c7`` script uses ``podman run`` to create a container based on
the above image. The container is an isolated execution environment with
its own file system based upon the above image. Any changes to the
file system are added in a layered fashion.

The container's file system changes are lost when the container is deleted.
However with ``c7`` we arrange for that to happen only if
the user explicitly deletes ``dev-c7``.


Container lifetime
------------------

The script ``c7`` launches a container in the background using
podman. It then executes an interactive bash shell inside of that
container.

This means that when you exit the bash prompt the container continues to
run in the background.

Further invocations of ``c7`` will execute further interactive bash
shells in the same container.

If the container is stopped (via ``podman stop dev-c7`` or due to a host
reboot) then the next invocation of ``c7`` will detect this and
restart it.

Because of this the ``dev-c7`` container is not ephemeral like most containers,
it persists changes that you make in the OS until it is explicitly deleted.

File Systems
------------

The system partition in which the operating system is installed resides
inside the container. However ``c7`` mounts a number of host and
shared file systems. This is how the container is made to look very
similar to a RHEL7 workstation. The mounted file systems are as follows::

    /dls_sw/prod:/dls_sw/prod
    /dls_sw/work:/dls_sw/work
    /dls_sw/epics:/dls_sw/epics
    /dls_sw/targetOS/vxWorks/Tornado-2.2:/dls_sw/targetOS/vxWorks/Tornado-2.2
    /dls_sw/apps:/dls_sw/apps
    /dls_sw/etc:/dls_sw/etc
    /scratch:/scratch
    /home:/home
    /tmp:/tmp
    /dls/science/users/:/dls/science/users/

User Profile
------------

``c7`` executes ``bash -l`` in order to create an interactive
shell in the container. The following features make this work:

- The home directories folder /home is mounted
- the HOME environment variable is passed into the container
- the user namespace is mapped into the container namespace

The above points mean that bash is able to run ``.bash_profile`` from your
home directory under your account. Hence all the usual DLS profile
features are loaded.
