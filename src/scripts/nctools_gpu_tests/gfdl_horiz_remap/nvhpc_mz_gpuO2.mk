# Make macros for the ncrc4 site

MPICC := nvc

CFLAGS_FULL := -O2 -g -traceback -Minfo=opt

CLIBS_SITE :=
FLIBS_SITE :=

NETCDF_HOME := $(shell nc-config --prefix)

NOPARALLEL := t
