# Make macros for the ncrc4 site

MPICC := nvc

#CFLAGS_SITE := -tp haswell
#FFLAGS_SITE := -tp haswell

#CFLAGS_SITE := -Minfo=opt
#FFLAGS_SITE := -Minfo=opt

CFLAGS_FULL := -O0 -g -traceback -Minfo=opt -acc=host

CLIBS_SITE :=
FLIBS_SITE :=

NETCDF_HOME := $(shell nc-config --prefix)

NOPARALLEL := t
