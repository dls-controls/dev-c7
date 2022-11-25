Purpose of the dev-c7 Container
===============================

This project allows controls developers to continue to work on IOCs and tools
built for RHEL7, while at the same time allowing the DLS wide upgrade to
RHEL8 to continue. 

Some details of the plan to achieve this are here 
https://confluence.diamond.ac.uk/x/NY8DCQ

Previously the task of upgrading from RHEL6 to RHEL7 proved to be quite
complicated and took several years to finalize.

Hence this project is a stopgap so that we can use effort to work on replacing 
our
tools and deployment process with one based on containers and Kubernetes. 
Some details of the epics-containers approach are documented here
https://github.com/epics-containers.

With the new approach under development it would be a waste of effort to
port our legacy toolchain to RHEL8 only to replace it shortly afterward.
The container based approach decouples the tools and IOCs from the
host operating system so any future OS upgrades should be far 
smoother.