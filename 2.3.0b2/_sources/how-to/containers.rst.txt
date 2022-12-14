Managing Containers and Images on a Workstation
===============================================

Definitions
-----------

**Images** are snapshots of a filesystem used to bootstrap a container.

**Containers** are isolated execution environments with their file system based
upon an Image.

Monitoring
----------

You can see which **Containers** are running on your system with::

    podman ps -a

The ``-a`` means it will also show stopped containers.

You can see what **Images** are cached on your system with::

    podman images

Images are usually cached from a container registry like ghcr.io. They can
usually be deleted without any consequence except waiting for the download
next time you launch a container that uses them.

Cleaning Up Space
-----------------

The container and image cache is stored in /scratch/<fed_id>/podman. If you
are short on space you can use the following.

To remove temporary images and stopped containers::

    podman system prune

To remove individual images::

    podman rmi IMAGE_ID # from third column of podman images

    OR ...

    podman rmi REPOSITORY:TAG # 1st , 2nd columns of podman images

To remove all images with wildcard on REPOSITORY::

    podman rmi $(podman images --filter=reference='*PATTERN*' -q)

    # PATTERN matches the REPOSITORY column


.. _dockerfile:

Defining a Container Image
==========================

The dev-c7 container image is built from the container context folder
``dev-c7/docker``.
The context contains a Dockerfile which details the steps to build the
container image.

To experiment with making additions to the dev-c7 project, first clone
the project and do a test build of the container::

    git clone https://dls-controls.github.io/dev-c7/main/index.html
    cd dev-c7
    ./build-dev-c7.sh

``build-dev-c7.sh`` will create a container image with the tag
``ghcr.io/dls-controls/dev-c7``. This is the same tag that ``c7.sh``
uses so it will launch a container based on your newly built image.

.. note::
    You will likely already have a dev-c7 container running and you must delete
    that before your new one will launch. Otherwise the launch script will
    just open a new bash session in the existing container.
    To do this see `deleting`.

Now you are ready to make any changes you wish to the Dockerfile and add
any additional files to the context (i.e. in the ``dev-c7/docker`` folder).

Below is the current Dockerfile, read on for an explanation of the
commands used.


.. literalinclude:: ../../docker/Dockerfile
   :language: docker



The base image is selected with the ``FROM`` command this defines what the
container file system looks like initially. Every command in the Dockerfile
then adds a layer of change to the container image.

The majority of the Dockerfile for ``dev-c7`` is using yum install to get
packages installed into the OS. Yum is executed via the ``RUN`` command.
Note that the ``RUN`` command takes a single shell command line input.

.. Note::
    It is
    common in Dockerfiles to use ``&& \`` to string multiple commands together
    in a single ``RUN``. The reason to do this is to minimize the number
    of layers
    in the container image. In particular, if you want to clean up temporary
    files, it must be done in the same layer they were created or it will not
    reduce the size of the resulting image (because there is a layer with the
    temp files and then another layer that removes them).

The ``RUN`` command may execute any command that is available inside the
container. For example the above uses a single ``RUN`` to get the source for
a new version of git and compile it.

Another command in this Dockerfile is ``ENV`` which simply sets an environment
variable for the processes the container launches.

The ``COPY`` command allows you to supply files from the context
(``dev-c7/docker`` folder in this case).
Note that the path / is the root of the context. You can only
copy files from inside the context, thus the context folder holds the entire
definition of the image generated.
