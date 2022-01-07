#!/bin/bash

# Called at various stages whilst dumping the VM.
# Set script in /etc/vzdump.conf file
# Script needs executable bit set

# Parameters passed to script

# $1 = stage name = backup-start | backup-end | backup-abort | log-end |
#                   pre-stop | pre-restart | post-restart |
#                   job-start | job-end | job-abort
# $2 = backup mode = snapshot | stop | suspend
# $3 = virtual machine id

# Environment variables available to script

# $DUMPDIR  = Machine image dump directory
# $HOSTNAME = Name of VM
# $LOGFILE  = Dump log
# $LOGFILE  = Log files (only set in log-end stage)
# $STOREID  = storage id; local, local-lvm etc.
# $TARFILE  = (only set in backup-end stage)
# $TARGET   = Target filename
# $VMTYPE   = qemu, lxc

# Proxmox VE node name = $(hostname)

# If varable DUMPDIR is empty it might be a PBS backup
[ -z "${DUMPDIR}" ] && exit 0

cd "${DUMPDIR}" || exit 1

PVENODENAME=$(hostname)

# VM_FILENAME_NEW takes the values from the TARGET filename and inserts
# the Proxmox VE node name and the VMs name

case "${1}" in
    backup-end)
        VM_FILENAME_OLD=$(basename "${TARGET}")
        # Note: $ vars in next line are AWK fields not params passed to script
        VM_FILENAME_NEW=$(basename "${TARGET}" | \
            awk -F "-" \
            '{print $1"-"$2"-'"${PVENODENAME}"'-"$3"-'"${HOSTNAME}"'-"$4"-"$5}')
        mv "${VM_FILENAME_OLD}" "${VM_FILENAME_NEW}"
        echo "VM filename renamed from ${VM_FILENAME_OLD} to ${VM_FILENAME_NEW}" >> "${LOGFILE}"
        ;;

    log-end)
        LOG_FILENAME_OLD=$(basename "${LOGFILE}")
        LOG_FILENAME_NEW=$(basename "${LOGFILE}" | \
            awk -F "-" \
            '{print $1"-"$2"-'"${PVENODENAME}"'-"$3"-'"${HOSTNAME}"'-"$4"-"$5}')
        mv "${LOG_FILENAME_OLD}" "${LOG_FILENAME_NEW}"
        echo "Log filename renamed from ${LOG_FILENAME_OLD} to ${LOG_FILENAME_NEW}" >> "${LOGFILE}"
        ;;
esac
