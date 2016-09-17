# Ports Linux compatibility framework

.ifndef _INCLUDE_USES_LINUX_MK
_INCLUDE_USES_LINUX_MK=	yes

.if empty(linux_args)
linux_args=	c6
.endif

IGNORE=	Linux emulation is not supported on DragonFly

LINUX_ARCH=	x86_64
PKGNAMEPREFIX?=	linux-${linux_ARGS}-
BUILD_DEPENDS+=	linux_base-${linux_ARGS}>0:emulators/linux_base-${linux_ARGS}

.endif
