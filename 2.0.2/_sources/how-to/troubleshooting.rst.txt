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

    