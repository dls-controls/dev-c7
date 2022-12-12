.. _start:

Quick Start
===========

Setup
-----

First, if you have never used containers at DLS before, then you must 
do an initial podman setup::

    /dls_sw/apps/setup-podman/setup.sh

.. note::

    If you have previously used podman you may need to perform a migration.
    See `../how-to/podman`


Install edm fonts
-----------------

The edm display manager uses local fonts that need to be installed on your host.

Again, these should be part of the standard RHEL8 installation but early
adopters may need to install them as follows::

    bash <(curl -s https://raw.githubusercontent.com/dls-controls/dev-c7/main/edm-fonts/install-fonts.sh)


Startup Script run-dev-c7.sh
----------------------------

Next, copy the startup script to your local bin directory and make it 
executable. 

**IMPORTANT: before doing the next steps go to 'Other Versions'
at the bottom of the left side-bar and select the version you want. The
latest version is recommended.**

- cd $HOME/bin
- wget -nc |RunLink|  
- chmod +x run-dev-c7.sh

The above gets version |ProjectVersion| which was the latest release when these docs were
built. See https://github.com/dls-controls/dev-c7/releases for all releases.

Finally, launch an instance of the container by typing::

    run-dev-c7.sh

.. note::
    For the first invocation of an updated version of the container there 
    will be a 30 second delay while the filesystem user id namespace mapping 
    is cached.


How to Work
-----------

At a dev-c7 prompt you can work normally as if you were sitting at a RHEL7 
workstation. Everything should work as before although there are a few 
differences, see
`../explanations/differences`. 

If you find anything that does not work or have suggestions for improvement,
please report it 
`On GitHub Issues <https://github.com/dls-controls/dev-c7/issues>`_.

- You can launch multiple instances of dev-c7 and they will share the
  same container. 
- You can run gnome-terminal and open multiple tabs - all will be in the 
  container
- You can use module load as usual to make further software from dls_sw
  available
- You can run GUI apps as normal.
- You have full sudo rights and can install anything you need into the
  container with ``yum install``
- Do NOT run vscode inside the container. Instead run it normally and 
  feel free to launch dev-c7 inside of its integrated terminals to do 
  compilation, testing.
