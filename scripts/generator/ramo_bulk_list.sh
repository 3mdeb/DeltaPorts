#!/bin/sh
#
# Accept an origin as an argument (e.g editors/joe)
# produce a list of ports that depend on that origin so they can build.
# suitable for passing to poudriere's bulk -f function

CONFFILE=/usr/local/etc/dports.conf
TMPFILE=/tmp/pre-bulk.list
FINALFILE=/tmp/ramo.list

if [ ! -f ${CONFFILE} ]; then
   echo "Configuration file ${CONFFILE} not found"
   exit 1
fi

checkdir ()
{
   eval "MYDIR=\$$1"
   if [ ! -d ${MYDIR} ]; then
     echo "The $1 directory (${MYDIR}) does not exist."
     rm -f ${BUSYFILE}
     exit 1
  fi
}

confopts=`grep "=" ${CONFFILE}`
for opt in ${confopts}; do
   eval $opt
done

AWKCMD='{ print $1 }'
AWKCMD2='{ print substr($2,12) }'

checkdir MERGED

[ -z "${1}" ] && echo "argument 1 must be port origin" && exit 1
FULLLINE=$(grep "|/usr/ports/${1}|" ${INDEX} 2>/dev/null)
[ -z "${FULLLINE}" ] && "origin: ${1} not present in ${INDEX}" && exit 1

PKGNAME=$(echo ${FULLLINE} | awk -F \| "${AWKCMD}")

grep ${PKGNAME} ${INDEX} | \
   awk -F \| -v pkgname="${PKGNAME}" "${AWKCMD2}" | sort > ${TMPFILE}

cd ${MERGED}
rm -f ${FINALFILE}
while read line; do
   echo $line
   if [ -d ${line} ]; then
      echo ${line} >> ${FINALFILE}   
   fi
done < ${TMPFILE}

rm ${TMPFILE}
