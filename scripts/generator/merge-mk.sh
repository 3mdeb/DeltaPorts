#!/bin/sh
#
# Update $MERGED directory (ports + overlay = merged)
#

CONFFILE=/usr/local/etc/dports.conf

if [ ! -f ${CONFFILE} ]; then
   echo "Configuration file ${CONFFILE} not found"
   exit 1
fi

checkdir ()
{
   eval "MYDIR=\$$1"
   if [ ! -d ${MYDIR} ]; then
     echo "The $1 directory (${MYDIR}) does not exist."
     exit 1
  fi
}

confopts=`grep "=" ${CONFFILE}`
for opt in ${confopts}; do
   eval $opt
done

checkdir DELTA
checkdir FPORTS
checkdir MERGED

WORKAREA=/tmp/merge.workarea

checkfirst=$(mount | grep ${WORKAREA})
if [ -z "${checkfirst}" ]; then
   rm -rf ${WORKAREA}
   mkdir ${WORKAREA}
   mount -t tmpfs tmpfs ${WORKAREA}
fi

rm -rf ${WORKAREA}/*

cp -a ${FPORTS}/Templates ${WORKAREA}
mkdir -p ${WORKAREA}/Mk/Uses ${WORKAREA}/Mk/Scripts
all=$(cd ${FPORTS} && find Mk -type f)
for item in ${all}; do
   cat ${FPORTS}/${item} | sed -E \
      -e 's|:L}|:tl}|g' \
      -e 's|:U}|:tu}|g' \
      -e 's|:U:(.*)}|:tu:\1}|g' \
      -e 's|:L:(.*)}|:tl:\1}|g' \
      > ${WORKAREA}/${item}
done

for k in Mk Templates; do
  diffs=$(find ${DELTA}/special/${k}/diffs -name \*\.diff)
  for difffile in ${diffs}; do
    @echo "Apply patch ${difffile}" 
    patch --quiet -d ${WORKAREA}/${k} < ${difffile}
  done
  find ${WORKAREA}/${k} -name \*\.orig -exec rm {} \;
  cpdup -i0 ${WORKAREA}/${k} ${MERGED}/${k}
done

# port tree root
cp ${FPORTS}/UIDs ${FPORTS}/GIDs ${MERGED}/
diffs=$(find ${DELTA}/special/treetop/diffs -name \*\.diff)
for difffile in ${diffs}; do
  patch --quiet -d ${MERGED} < ${difffile}
done
rm ${MERGED}/*.orig

umount ${WORKAREA}
rm -rf ${WORKAREA}

rm -rf ${MERGED}/Tools
folders=$(cd ${FPORTS} && find Tools -type d | sort)
for folder in ${folders}; do
   mkdir -p ${MERGED}/${folder}
done
all=$(cd ${FPORTS}  && find Tools -type f)
for item in ${all}; do
   cat ${FPORTS}/${item} | sed -E \
       -e 's|!/usr/bin/perl|!/usr/local/bin/perl|' \
       > ${MERGED}/${item}
done
