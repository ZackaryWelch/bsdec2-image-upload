PROG=	bsdec2-image-upload
SRCS=	main.c
MAN	=
WARNS	?=	3
BINDIR	?=	/usr/local/bin
LDADD	+=	-lcrypto -lssl

UNAME_S	:=	$(shell uname -s)
.if (${UNAME_S},Linux)
CERTFILE	=	\"/etc/ssl/certs/ca-bundle.crt\"
CFLAGS	+=	--no-warnings
.else
CERTFILE	=	\"/usr/local/share/certs/ca-root-nss.crt\"
CFLAGS	+=	-Wno-error=\#warnings
.endif

# Fundamental algorithms
.PATH.c	:	libcperciva/alg
SRCS	+=	sha256.c
IDIRS	+=	-I libcperciva/alg

# Data structures
.PATH.c	:	libcperciva/datastruct
SRCS	+=	elasticarray.c
IDIRS	+=	-I libcperciva/datastruct

# Utility functions
.PATH.c	:	libcperciva/util
SRCS	+=	asprintf.c
SRCS	+=	entropy.c
SRCS	+=	getopt.c
SRCS	+=	hexify.c
SRCS	+=	insecure_memzero.c
SRCS	+=	rfc3986.c
SRCS	+=	warnp.c
IDIRS	+=	-I libcperciva/util

# AWS request signing
.PATH	:	libcperciva/aws
SRCS	+=	aws_readkeys.c
SRCS	+=	aws_sign.c
IDIRS	+=	-I libcperciva/aws

# SSL requests
.PATH	:	lib/util
SRCS	+=	sslreq.c
IDIRS	+=	-I lib/util

CFLAGS	+=	-g
CFLAGS	+=	${IDIRS}
CFLAGS	+=	-DCERTFILE=${CERTFILE}

.include <bsd.prog.mk>
