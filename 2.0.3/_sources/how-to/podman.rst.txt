Updating Podman Settings
========================

.. note::
    Please ensure you are using a RHEL8 workstation before continuing.

Previous users of podman may need to update their podman settings to
support features required by dev-c7. 


Features
--------

.. note::
    Updating your container filesystem requires deleting all images,
    containers and volumes in your cache. Make sure you are able to 
    recreate all assets you need before continuing

The additional features are:

#. the crun container runtime 
    - to support secondary groups in shared folders
#. the overlay file system
    - provide a much faster container build and run
#. put the root of podman scratch files in /scratch/<fed_id>/podman 
    - avoid loosing all scratch your files on ``podman system reset``

.. warning::

    At the time of writing the podman setup script implements (3) above only.
    For the moment early adopters will need to apply (1) and (2) manually.
    The script should be updated by 11/07/2022.


Scratch Area
------------
The most important thing to do is verify if podman is using the root of 
your scratch area. Take a look in the file 
``$HOME/.config/containers/storage.conf``. There is a field called 
``graphroot``, if this is */scratch/<fed_id>* then you need to proceed with
caution and follow the rest of this section. If it is 
*/scratch/<fed_id>/podman*
then proceed to `update`.

This is a one off process only, in future your podman files will be safely in 
their own subfolder.

You have two options for proceeding:

#. move everything first
    - move all files and folders you want to keep out of /scratch/<fed>
    - execute ``podman system reset`` 
    - mkdir /scratch/<fed_id>
    - move your files back
#. use sudo (or ask SciComp) to remove podman files from */scratch/<fed_id>*
    - sudo rm -rf vfs* libpod mounts \*.lock


.. _update:

Update Settings
---------------

Before proceeding, clear out your old podman filesystem. This will delete 
all images, containers and volumes::

    podman system reset 

The next step is to update your settings with the setup script::

    /dls_sw/apps/setup-podman/setup.sh

If you want to verify that the changes were applied then check the following
files for the updates shown in $HOME/.config/containers::

    storage.conf
        driver = "overlay"
        graphroot = "/scratch/<fed_id>/podman"

    libpod.conf
        runtime = "crun"

.. note::

    If you are an early adopter then you will need to set driver and 
    runtime yourself by editing storage.conf manually. 
    (see above warning)


That's it. You should now be able to start using podman and it should 
be fully compatible with dev-c7.


