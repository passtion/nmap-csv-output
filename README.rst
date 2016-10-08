##########
csv-output
##########

STATUS: WIP

Synopsis
--------

This script outputs the data collected by nmap during the scan and outputs them to a CSV file.
Its architecture has been largely inspired by `exitnode/nmap-sqlite-output`_


Usage:

.. code:: Bash

    nmap --script csv-output --script-args=filename=myscan.csv -p 1-1000 scanme.nmap.org


.. _exitnode/nmap-sqlite-output: https://github.com/exitnode/nmap-sqlite-output 
