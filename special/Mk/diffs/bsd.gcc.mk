#-*- tab-width: 4; -*-
# ex:ts=4
#
# bsd.gcc.mk - Support for smarter USE_GCC usage.
#
# Created by: Edwin Groothuis <edwin@freebsd.org>
#
# To request the use of a current version of GCC, specify USE_GCC=yes in
# your port/system configuration.  This is the preferred use of USE_GCC.
# It uses the canonical version of GCC defined in bsd.default-versions.mk.
#
# USE_GCC=any is similar, except that it also accepts the old GCC 4.2-
# based system compiler in older versions of FreeBSD.
# 
# If your port needs a specific (minimum) version of GCC, you can easily
# specify that with a USE_GCC= statement.  Unless absolutely necessary
# do so by specifying USE_GCC=X.Y+ which requests at least GCC version
# X.Y.  To request a specific version omit the trailing + sign.
#
# Examples:
#   USE_GCC=	yes			# port requires a current version of GCC
#							# as defined in bsd.default-versions.mk.
#   USE_GCC=	any			# port requires GCC 4.2 or later.
#   USE_GCC=	4.9+		# port requires GCC 4.9 or later.
#   USE_GCC=	4.9			# port requires GCC 4.9.
#
# If you are wondering what your port exactly does, use "make test-gcc"
# to see some debugging.
#
# $FreeBSD$

GCC_Include_MAINTAINER=		gerald@FreeBSD.org

.include "${PORTSDIR}/Mk/bsd.default-versions.mk"

# All GCC versions supported by the ports framework.  Keep them in
# ascending order and in sync with the table below. 
GCCVERSIONS=	040200 040600 040700 040800 040900 050000

# The first field if the OSVERSION in which it appeared in the base.
# The second field is the OSVERSION in which it disappeared from the base.
# The third field is the version as USE_GCC would use.
GCCVERSION_040200=	     0       0 4.2 42
GCCVERSION_040600=	     0       0 4.6 43
GCCVERSION_040700=	300400  400102 4.7 47
GCCVERSION_040800=	     0       0 4.8 48
GCCVERSION_040900=	     0       0 4.9 49
GCCVERSION_050000=	400103 9999999 5   50

# No configurable parts below this. ####################################
#

# Extract the fields from GCCVERSION_...
.for v in ${GCCVERSIONS}
. for j in ${GCCVERSION_${v}}
.  if !defined(_GCCVERSION_${v}_L)
_GCCVERSION_${v}_L=	${j}
.  elif !defined(_GCCVERSION_${v}_R)
_GCCVERSION_${v}_R=	${j}
.  elif !defined(_GCCVERSION_${v}_V)
_GCCVERSION_${v}_V=	${j}
.  elif !defined(_GCCVERSION_${v}_VV)
_GCCVERSION_${v}_VV=	${j}
.  endif
. endfor
.endfor

.if ${DFLYVERSION} >= ${_GCCVERSION_050000_L}
LASTBASE=		5
DFLY_DEFAULT_VERSION=	50
.else
LASTBASE=		4.7
DFLY_DEFAULT_VERSION=	47
.endif

.if ${USE_GCC:Myes}
USE_GCC=	${LASTBASE}
.endif

.if defined(USE_GCC) && !defined(FORCE_BASE_CC_FOR_TESTING)

. if ${USE_GCC} == any

# Enable the clang-is-cc workaround.  Default to the last GCC imported
# into base.
_USE_GCC:=	${LASTBASE}
_GCC_ORLATER:=	true

. else # ${USE_GCC} == any

# See if we can use a later version or exclusively the one specified.
_USE_GCC:=	${USE_GCC:S/+//}
.if ${USE_GCC} != ${_USE_GCC}
_GCC_ORLATER:=	true
.endif

. endif # ${USE_GCC} == any

# Initialize _GCC_FOUND${v}.  In parallel, check if USE_GCC points to a
# valid version to begin with.
.for v in ${GCCVERSIONS}
. if ${DFLY_DEFAULT_VERSION} >= ${_GCCVERSION_${v}_VV}
_GCC_FOUND${v}=	base
. elif exists(${LOCALBASE}/bin/gcc${_GCCVERSION_${v}_V:S/.//})
_GCC_FOUND${v}=	port
. endif
. if ${_USE_GCC}==${_GCCVERSION_${v}_V}
_GCCVERSION_OKAY=	true
. endif
.endfor

.if !defined(_GCCVERSION_OKAY)
IGNORE=	Unknown version of GCC specified (USE_GCC=${USE_GCC})
.endif

# If the GCC package defined in USE_GCC does not exist, but a later
# version is allowed (for example 4.7+), see if there is a later.
# First check if the base installed version is good enough, otherwise
# get the first available version.
#
.if defined(_GCC_ORLATER)
. if ${_USE_GCC:M5} && ${DFLY_DEFAULT_VERSION:M50}
#  _USE_GCC is already correct
. elif ${_USE_GCC:N5} && (${_USE_GCC:S/.//} <= ${DFLY_DEFAULT_VERSION})
_USE_GCC= ${LASTBASE}
. else # HEAD ORIG - run on 4.0 and below
. for v in ${GCCVERSIONS}
.  if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
_GCC_MIN1:=	true
.  endif
.  if defined(_GCC_MIN1) && defined(_GCC_FOUND${v}) && ${_GCC_FOUND${v}}=="base" && !defined(_GCC_FOUND)
_GCC_FOUND:=	${_GCCVERSION_${v}_V}
.  endif
. endfor
. for v in ${GCCVERSIONS}
.  if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
_GCC_MIN2:=	true
.  endif
.  if defined(_GCC_MIN2) && defined(_GCC_FOUND${v}) && !defined(_GCC_FOUND)
_GCC_FOUND:=	${_GCCVERSION_${v}_V}
.  endif
. endfor

. if defined(_GCC_FOUND)
_USE_GCC:=	${_GCC_FOUND}
. elif ${_USE_GCC} < ${GCC_DEFAULT}
_USE_GCC:=	${GCC_DEFAULT}
. endif
. endif   # TAIL ORIG
.else  # defined(_GCC_ORLATER)
. if ${_USE_GCC:M4.[67]}
_USE_GCC=		4.7
DFLY_DEFAULT_VERSION=	47
. endif
.endif # defined(_GCC_ORLATER)

.endif # defined(USE_GCC)


.if defined(_USE_GCC)
# A concrete version has been selected.  Determine if the installed OS 
# features this version in the base, and if not then set proper ports
# dependencies, CC, CXX, CPP, and flags.
.for v in ${GCCVERSIONS}
. if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
.  if (${_GCCVERSION_${v}_L} == 0 && ${_GCCVERSION_${v}_R} == 0) || \
      ${DFLYVERSION} < ${_GCCVERSION_${v}_L}
V:=			${_GCCVERSION_${v}_V:S/.//}
_GCC_PORT_DEPENDS:=	gcc${V}
.   if ${_USE_GCC} == ${LANG_GCC_IS}
_GCC_PORT:=		gcc
.   else
_GCC_PORT:=		gcc${V}
.   endif
CC:=			gcc${V}
CXX:=			g++${V}
CPP:=			cpp${V}
_GCC_RUNTIME:=		${LOCALBASE}/lib/gcc${V}
CFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME}
CXXFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME}
LDFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME} -L${_GCC_RUNTIME}
.  else # Use GCC in base.
CC:=			gcc
CXX:=			g++
CPP:=			cpp
CONFIGURE_ENV+=		CCVER=gcc${DFLY_DEFAULT_VERSION}
MAKE_ENV+=		CCVER=gcc${DFLY_DEFAULT_VERSION}
.  endif # Use GCC in base.
. endif # ${_USE_GCC} == ${_GCCVERSION_${v}_V}
.endfor
.undef V

.if defined(_GCC_PORT_DEPENDS)
BUILD_DEPENDS+=	${_GCC_PORT_DEPENDS}:${PORTSDIR}/lang/${_GCC_PORT}
RUN_DEPENDS+=	${_GCC_PORT_DEPENDS}:${PORTSDIR}/lang/${_GCC_PORT}
# Later GCC ports already depend on binutils; make sure whatever we
# build leverages this as well.
USE_BINUTILS=	yes
.endif
.endif # defined(_USE_GCC) && !defined(FORCE_BASE_CC_FOR_TESTING)


test-gcc:
	@echo USE_GCC=${USE_GCC}
.if defined(IGNORE)
	@echo "IGNORE: ${IGNORE}"
.else
.if defined(USE_GCC)
.if defined(_GCC_ORLATER)
	@echo Port can use later versions.
.else
	@echo Port cannot use later versions.
.endif
.for v in ${GCCVERSIONS}
	@echo -n "GCC version: ${_GCCVERSION_${v}_V} "
.if defined(_GCC_FOUND${v})
	@echo -n "(${_GCC_FOUND${v}}) "
.endif
	@echo "- OSVERSION from ${_GCCVERSION_${v}_L} to ${_GCCVERSION_${v}_R}"
#	@echo ${v} - ${_GCC_FOUND${v}} - ${_GCCVERSION_${v}_L} to ${_GCCVERSION_${v}_R} - ${_GCCVERSION_${v}_V}
.endfor
	@echo Using GCC version ${_USE_GCC}
.endif
	@echo CC=${CC} - CXX=${CXX} - CPP=${CPP} - CFLAGS=\"${CFLAGS}\"
	@echo LDFLAGS=\"${LDFLAGS}\"
	@echo CONFIGURE_ENV=${CONFIGURE_ENV}
	@echo MAKE_ENV=${MAKE_ENV}
	@echo "BUILD_DEPENDS=${BUILD_DEPENDS}"
	@echo "RUN_DEPENDS=${RUN_DEPENDS}"
.endif
