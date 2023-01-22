# Make macros for the ncrc4 site

MPICC := nvc

CFLAGS_FULL := -fast -acc -Minfo=accel -gpu=managed

CLIBS_SITE :=
FLIBS_SITE :=

NETCDF_HOME := $(shell nc-config --prefix)

NOPARALLEL := t
