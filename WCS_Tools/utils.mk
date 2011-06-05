################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

MAKE_START_TIME:=$(shell echo $$(( $$(date +%s) )))
GET_TIME = $$(date +%s)

# ------------------------------------------------------------------------------
# utilities
# ------------------------------------------------------------------------------

PATCH=patch -N
REM_PATCH=patch -R -N
COPY=/bin/cp
MOVE=/bin/mv
DEL=/bin/rm
LINK=/bin/ln
SYMLINK=/bin/ln -s
CHMOD=/bin/chmod
MKDIR=/bin/mkdir
RMDIR=/bin/rmdir
ECHO=/bin/echo
TAR=/bin/tar
FIND=/usr/bin/find
SED=/bin/sed


# ------------------------------------------------------------------------------
# functions
# ------------------------------------------------------------------------------

print = $(ECHO) -e "\033[7m$1\033[0m"
echo-to-file = $(ECHO) $(1) > $(2)

