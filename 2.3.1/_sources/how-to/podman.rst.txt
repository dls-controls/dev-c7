Updating Podman Settings
========================

.. note::
    Please ensure you are using a RHEL8 workstation before continuing.

Previous users of podman may need to update their podman settings to
support features required by dev-c7. 

.. note::
    Updating your container filesystem may require deleting all images,
    containers and volumes in your cache. Make sure you are able to 
    recreate all assets you need before continuing

To update simply run the script ``/dls_sw/apps/setup-podman/setup.sh``.
If your podman config is already up to date then this will have no effect,
if it needs to delete your cache it will warn you before doing so. 

If you do not have sudo rm permission on your workstation you will be 
required to have an administrator run the script on your behalf. 


Features
--------

The additional features are:

#. the crun container runtime 
    - to support secondary groups in shared folders
#. the overlay file system
    - provide a much faster container build and run
#. put the root of podman scratch files in /scratch/<fed_id>/podman 
    - avoid loosing all scratch your files on ``podman system reset``

