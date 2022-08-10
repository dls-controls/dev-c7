Troubleshooting
===============

EDM Fonts
---------

If you want to use edm then you will need to have the local fonts on your
host machine. These will eventually be provided by default on the standard DLS 
RHEL8 workstation. However, early adopters will need to install these
themselves.

Use ``sudo yum install`` on each of the rpms in this folder
https://github.com/dls-controls/dev-c7/tree/dev/edm-fonts


Insufficient UIDs/GIDs
----------------------

When building the container for the first time, you may come across the following:
```
Error: writing blob: adding layer with blob 
"sha256:0b2dc63a68b9b80b6e261e0c71119894a739d353f8263d6b2f1394c66a45f5af": ApplyLayer exit status 1 stdout:  
stderr: potentially insufficient UIDs or GIDs available in user namespace (requested 0:54 for /run/lock/lockdev): 
Check /etc/subuid and /etc/subgid: lchown /run/lock/lockdev: invalid argument
```

Rootless Podman uses a pause process to preserve the unprivileged namespaces, 
which locks down the user files /etc/subuid and /etc/subgid.
The following command will stop the pause process and release the files for 
editing::

    podman system migrate

subuid settings missing
-----------------------

IF you see this error::

    ERRO[0000] cannot find UID/GID for user hgv27681: No subuid ranges found for user "hgv27681" in /etc/subuid - check rootless mode in man pages.
    WARN[0000] Using rootless single mapping into the namespace. This might break some images. Check /etc/subuid and /etc/subgid for adding sub*ids if not using a network user

Then you probably have an empty /etc/subuid file. This is automatically updated by
cfengine at 11AM every day. If your workstation was recently built then you may
need to wait until the next 11AM !!

PyQt Errors
-----------

Some PyQt applications may show this error::

    libGL error: unable to load driver: swrast_dri.so
    libGL error: failed to load driver: swrast

This is benign and can be ignored. (if the application is not launching Then
this is a different issue - don't be distracted by this error)

Memory Protections Error
------------------------

If you see this on launch of podman containers::

    /bin/sh: error while loading shared libraries: libc.so.6: cannot change memory protections

Then you are missing the ``mount_program = "/bin/fuse-overlayfs"`` entry in your 
storage.conf file. See `podman`.
