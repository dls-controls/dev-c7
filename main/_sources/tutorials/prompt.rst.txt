Bash Prompt in dev-c7
=====================

It is useful to have a way to tell you are inside of the developer
container. By default your bash prompt will look exactly the
same inside and out of the container.

You can fix this in one of two ways.

Modify .bashrc_local
~~~~~~~~~~~~~~~~~~~~

**Preferred Solution**

The file $HOME/.bashrc_local is sourced by bash for each shell that you
launch and it is a place to put your personal settings.

Add the following to the end of the file in order to have an indicator
that you are inside the developer container.

.. code-block:: bash

    if [[ -f /etc/centos-release ]] ; then
        export PS1="[C7] ${PS1}"
    fi

This updates the PS1 prompt that you see on the command line with a prefix
of ``[C7]``.

Change the hostname
~~~~~~~~~~~~~~~~~~~

Typically the PS1 prompt shows you which host you are on. You can change
the name of the host inside the container to give you an indicator that
you are in the developer container.

When using the launch script for initial creation of the container you
can pass a hostname of your choice as follows.

.. code-block:: bash

    c7.sh -s my-hostname

.. warning::

    If you are working remotely and launching the container from an
    ssh session changing the hostname will cause X11 apps to fail.

