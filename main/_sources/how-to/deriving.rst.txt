.. _deriving:

Derive your own container image
===============================

Each developer is free to derive their own container image if they have
specific requirements e.g.

- Additional system libraries
- Additional command line or GUI tools
- Any other OS configuration that they prefer

.. note::
    If the changes you need are likely to be useful to all developers then
    you should consider contributing to the base image for dev-c7.
    See `../reference/contributing`

To make your own derived container.

- Create a folder (this is your container context folder)
- Make a Dockerfile in that folder
- Drop in any files that you want to copy into the container
- cd into the folder
- ``podman build --tag my-dev-c7 .``
- c7.sh -i my-dev-c7

Below is an example Dockerfile derived from dev-c7 that adds a package with
yum, sets an environment variable and copies a script into /usr/bin. Note
that the build is running as root inside the container so it is allowed
to write to a system folder.

.. literalinclude:: Dockerfile
   :language: docker