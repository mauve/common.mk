# Copyright (c) 2011, Tobii Technology AB
# Copyright (c) 2011, Mikael Olenfalk
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#
#
# YOU CAN READ THIS DOCUMENTATION NICELY FORMATTED BY INVOKING:
#
#		make manual | less -R
#		make manual-toc | less -R 
#
# OR:
#
#		make -f common.mk manual | less -R
#		make -f common.mk manual-toc | less -R
#
#
# IF YOU HAVE A TERMINAL WHICH DOESN'T SUPPORT ANSI COLORS:
#
#
#		make -f common.mk manual-plain | less
#
#
# BEGDOC <<DO NOT REMOVE THIS LINE>>
# 
# 0. DOCUMENTATION FOR COMMON MAKE FILE
# Author: Mikael Olenfalk Tobii Technology AB
#
# 1. INTRODUCTION
#
#    The end of this manual contains a list of all variables
#    which control compilation of entities.
#
# This makefile is meant to be included by other high-level
# makefiles. This makefile enables the user to write high-level
# make constructs and then from these constructs several
# targets are automatically generated:
#
#    make all
#    make clean
#    make depends
#    make clean-depends
#    make maintainer-clean
#    make check
#    make build
#    make install
#    make uninstall
#    make binary-dist
#    make describe
#
# And for your interest:
#
#    make manual
#    make manual-toc
#    make manual-plain
#
# As well as for your convenience:
#
#    make bootstrap package=helloworld
#
# 2. QUICK START
#
# 2.1. HELLO WORLD
#
# Let's say you want to build a simple program called "helloworld"
# which is built by the file "helloworld.cpp". You should then write
# a Makefile containing the following code:
#
# <<< begin >>>
# package = helloworld
#
# PROGRAMS = helloworld
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<< end   >>>
#
# Each program in the PROGRAMS variable is built automatically
# by this makefile. In order to specify which source files constitute
# a program you write:
#
#   helloworld_SRCS = helloworld.cpp
#
# In the above case the helloworld_SRCS is empty, then it defaults to
# "<programname>.cpp"
#
# 2.2. BOOTSTRAPPING
#
# The common.mk makefile (this file) can be invoked with the target
# bootstrap. It will then print a makefile to stdout which can be used
# as a starting point for writing your own makefile which uses common.mk.
#
# Invoke make as follows to generate a new makefile:
#
#   make -f common.mk bootstrap package=helloworld
#
# You MUST pass the variable 'package' to make otherwise an error will
# be printed. The bootstrapping process will create a makefile with
# the specified package name set as specified on the command line.
#
# The variable PROGRAMS will be set to $(package) and the source files
# will be searched for in the folder 'src' and assigned to $(package)_SRCS.
#
# 2.3. SPECIFYING WHAT TO BUILD
#
# 2.3.1. SPECIFYING PROGRAMS TO BUILD
#
# Programs to build can be specified either in the variable PROGRAMS
# or NODIST_PROGRAMS. The build process is the same both for programs
# listed in the PROGRAMS and NODIST_PROGRAMS variable with the difference
# that NODIST_PROGRAMS do not have install and uninstall targets.
#
# Usually NODIST_PROGRAMS is used to specify programs which are run
# as part of 'make check'.
#
# 2.3.2. SPECIFYING LIBRARIES TO BUILD
#
# If you want to build a library, you use the LIBRARIES variable instead
# of the PROGRAMS variable. Example:
#
#   LIBRARIES = helloworld
#
# Or for static libraries:
#
#   STATIC_LIBRARIES = helloworld
#
# The above statement will build the file libhelloworld.so unless you override
# the module name with the <library>_MODULE variable. During compilation of the
# source files for <library> -fPIC is automatically added to <library>_CXXFLAGS
# unless they contain '-fno-pic' explicitly.
#
# You can link the programs built with PROGRAMS and NODIST_PROGRAMS with libraries
# built by the same makefile by adding the basename of the library
# to the <program>_LIBS variable. The library will then automatically be
# made a dependency of the link step of <program>. During
# linking of <program> -rpath and -rpath-link will be set to the absolute path of
# the directory which contains the library. Example:
#
#   <program>_LIBS = helloworld
#
# 2.3.2.1. CONFIGURING NAMING OF LIBRARIES AND STATIC LIBRARIES
#
# The basename of a library is specified in the variables LIBRARIES or
# STATIC_LIBRARIES. During building this basename is then composed to yield
# the full filename for the library. Per default the full name is composed
# by concatenating the variables
#
#   <library>_MODULE_PREFIX
#   <library>_MODULE_SUFFIX
#   <library>_MODULE_EXTENSION
#
# Or for static libraries:
#
#   <static-library>_STATIC_MODULE_PREFIX
#   <static-library>_STATIC_MODULE_SUFFIX
#   <static-library>_STATIC_MODULE_EXTENSION
#
# With the basename between suffix and prefix. By default (unless they have been
# specified) these values are set to the values of the variables MODULE_PREFIX,
# MODULE_SUFFIX and MODULE_EXTENSION (default values are: 'lib', '' [empty] and
# '.so' respectively) or STATIC_MODULE_PREFIX, STATIC_MODULE_SUFFIX and
# STATIC_MODULE_EXTENSION (default values are: 'lib', '' [empty] and '.a').
#
# 2.4. PACKAGING
#
# Makefiles using common.mk support install and uninstall (DESTDIR is supported).
# Packaging is controlled using the variables:
#
#   package = <name>
#   package-version = <version>
#
# The variable 'package' MUST ALWAYS be specified, an error is printed otherwise.
#
# The variable 'package-version' default to "0.0.0" if unspecified.
#
#
# 2.5. EXTENDING COMMON MAKE
#
# You can extend common make easily by just inserting your own targets into
# your own makefile (the file which includes common.mk).
#
# 2.5.1. ADDING EXTRA FILES TO BE CLEANED
#
# By specifying the variable CLEAN_EXTRA_FILES and CLEAN_EXTRA_TARGETS you
# can specify extra files to be deleted during 'make clean' and extra targets
# run when doing 'make clean'.
#
# 2.5.2. BUILDING EXTRA TARGETS DURING TARGET 'build'
#
# By specifying the variable BUILD_EXTRA_TARGETS you can specify extra
# targets which 'build' will depend on. If you want to cleanup after those
# targets, use CLEAN_EXTRA_FILES and CLEAN_EXTRA_TARGETS (see 2.5.1.).
#
# 2.5.3. GENERATING SOURCE FILES
#
# Because this is just a makefile you can extend it by just adding more
# targets which make will pick up. For example to generate source files.
#
#
# 2.6. PROGRAM DEPENDENCIES
#
# 2.6.1. PKG-CONFIG DEPENDENCIES
#
# If your program depends on a library which supports pkg-config you can specify
# this dependency directly via the <program>_PKGCONFIG variable, like so:
#
#   <program>_PKGCONFIG = libssl
#
# And optionally:
#
#   <program>_PKGCONFIG_libssl = VERSION_REQUIREMENTS
#
# Where VERSION_REQUIREMENTS is a combination of 'atleast=VERSION', 'maxversion=VERSION'
# and 'exactversion=VERSION', for example:
#
#   <program>_PKGCONFIG_libssl = atleast=0.9.8g maxversion=0.9.9
#
# Before building of <program> pkg-config will be invoked to test if libssl is installed in the
# specified version and the CXXFLAGS, LIBS and LIBPATHS variables will be updated
# with information from pkg-config.
#
# If pkg-config is installed somewhere else than /usr/bin/pkg-config, you can
# point common.mk to the correct path by setting the variable PKGCONFIG.
#
# 2.6.2. PKG-CONFIG DEPENDENCIES PER CONFIGURATION
#
# If you specify a pkg-config dependency in the above mentioned form:
#
#   <program>_PKGCONFIG = dependency
#
# All the configurations of <program> will automatically depend on the specified
# pkg-config library. If, however, your programs different configurations has
# different dependencies, you can specify it like this:
#
#   <program>_<configuration>_PKGCONFIG = dependency
#
#
# 2.6.3. EXCLUDING LIBRARIES FOR PKG-CONFIG DEPENDENCIES
#
# When using pkg-config all libraries part of a package are automatically included.
# If not all of those libraries are actually used, we can exclude them from the
# set of libraries added to the linker invokation:
#
#   <program>_PKGCONFIG_<dependency>_EXCLUDELIBS = <libraries to exclude>
#
# For example when linking to OpenCV, the following libraries are part of OpenCV 1.0
# and all of those libraries are linked to per default:
#
#   cxcore cv highgui cvaux ml
#
# However some programs only want the base, e.g. cxcore and cv. This can be specified
# as demonstrated by the following snippet:
#
#   helloworld_PKGCONFIG = opencv
#   helloworld_PKGCONFIG_opencv_EXCLUDELIBS = highgui cvaux ml
#
#
# 2.6.4. SPECIFYING THE PATH TO PKG-CONFIG
#
# If pkg-config is located in a non-standard path (i.e. not /usr/bin/pkg-config)
# the location of the pkg-config binary can be specified with PKGCONFIG_EXEC:
#
#   PKGCONFIG_EXEC = /usr/bin/pkg-config
#   <program>_PKGCONFIG_EXEC = 
#   <configuration>_PKGCONFIG_EXEC =
#   <program>_<configuration>_PKGCONFIG_EXEC =
#
#
# 3. PROGRAM COMPILATION SETTINGS
#
# If your program requires special defines or libraries and flags
# then you can specify them as in the form <program>_VARIABLE.
# Here is an example:
#
# <<< begin >>>
# package = helloworld
#
# PROGRAMS = helloworld
#
# helloworld_LIBS = m
# helloworld_DEFINES = _REENTRANT
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<< end   >>>
#
# 3.1. COMPILATION CONFIGURATIONS
#
# The common.mk Makefile supports different configurations per program or
# library built, e.g. Debug and Release configurations. Per default each
# built entity has the configurations specified in the variable
# CONFIGURATIONS (which defaults to only 'Debug').
#
# To list the configurations for an entity, specify it like this:
#
#   <program>_CONFIGURATION = Debug Release
#
# During build all the compilation settings are gathered from variables named like:
#
#   <program>_<configuration>_SRCS = ...
#
# Which defaults to the value of the variable (if not specified):
#
#   <program>_SRCS = ...
#
#
# 3.1.1. OVERRIDING COMPILATION SETTINGS
#
# All variables which control building can be specified in the following forms:
# The following example uses CXXFLAGS, the first defined variable will be used
#
#   <program>_<configuration>_CXXFLAGS =
#   <configuration>_CXXFLAGS =
#   <program>_CXXFLAGS =
#   CXXFLAGS =
#
# That means when building program 'hello' in configuration 'Debug', the variable
# CXXFLAGS is resolved picking the first defined variable in the following list:
#
#  1. hello_Debug_CXXFLAGS
#  2. Debug_CXXFLAGS
#  3. hello_CXXFLAGS
#  4. CXXFLAGS
#
#
# 3.2. LIST OF BUILD CONFIGURATION VARIABLES
#
# 3.2.1. <program>_SRCS and <program>_<config>_SRCS
#
# Contains a list of sources files which constritute the program
# <program>. If this variable is not set, it defaults to <program>.cpp
#
# 3.2.2. <program>_CXXFLAGS, <config>_CXXFLAGS and <program>_<config>_CXXFLAGS
#
# The C++ compiler flags to use during compilation of sources for
# the program <program>. If not defined at all it defaults to the
# contents of the variable CXXFLAGS (default '-O0 -g -Wall -fmessage-length=0').
# To skip assignment from the default CXXFLAGS, define the variable to
# be empty, like this:
#
#   <program>_CXXFLAGS = 
#
# 3.2.3. <program>_CFLAGS, <config>_CFLAGS and <program>_<config>_CFLAGS
#
# The C compiler flags to use during compilation of sources for
# the program <program>. If not defined at all it defaults to the
# contents of the variable CFLAGS (default '-O0 -g -Wall -fmessage-length=0').
# To skip assignment from the default CFLAGS, define the variable to
# be empty, like this:
#
#   <program>_CFLAGS = 
#
# 3.2.4. <program>_LIBS, <config>_LIBS and <program>_<config>_LIBS
#
# Libraries to link against when building <program>. If not defined
# at all it defaults to the contents of the variable LIBS (which is
# empty per default). To skip assignment from the default LIBS, define
# the variable to be empty, like this:
#
#   <program>_LIBS = 
#
# If an entity links against a library which is being built by the
# same Makefile, this is handled automatically. Per default the library
# is linked against in the same configuration as the program. To
# change the configuration of the library to link against, write this:
#
#   <program>_<config>_LIB_<library> = <library-config>
#
# For example, when helloworld (Debug) should link against libgreeting.so
# with configuration Release, write this:
#
#   helloworld_Debug_LIB_greeting = Release
#
# 3.2.5. <program>_STATIC_LIBS, <config>_STATIC_LIBS and <program>_<config>_STATIC_LIBS
#
# Static libraries to link against when building <program>. If not defined
# at all it defaults to the contents of the variable STATIC_LIBS (which is
# empty per default). To skip assignment from the default STATIC_LIBS, define
# the variable to be empty, like this:
#
# 3.2.6. <program>_LIBPATHS, <config>_LIBPATHS and <program>_<config>_LIBPATHS
#
# Search path for libraries when linking <program>. Defaults to
# LIBPATHS if undefined.
#
# 3.2.7. <program>_DEFINES, <config>_DEFINES and <program>_<config>_DEFINES
#
# Preprocessor variables to define when compiling sources for
# <program>. If not defined defaults to DEFINES. Define the content
# like this:
#
#   <program>_DEFINES = _REENTRANT VERSION="1.0.0"
#
# The necessary '-D' is automatically prepended to the compiler
# invokation.
#
# 3.2.8. <program>_UNDEFINES, <config>_UNDEFINES and <program>_<config>_UNDEFINES
#
# Analog to <program>_DEFINES, but defines preprocessor variables
# to be undefined.
#
# 3.2.9. <program>_INCLUDES, <config>_INCLUDES and <program>_<config>_INCLUDES
#
# Paths to be searched by the compiler when looking for header
# files. Defaults to INCLUDES if undefined, specify like this:
#
#   <program>_INCLUDES = src includes
#
# The necessary '-I' is automatically prepended to the compiler
# invokation.
#
# 3.2.10. <program>_DATA_DIST, <config>_DATA_DIST and <program>_<config>_DATA_DIST
#
# Files to be included in the distribution. Those files are during
# 'make install' copied into $(DESTDIR)$(datadir). $(datadir) defaults
# to $(datarootdir)/$(package-name).
#
# See the section 6. DISTRIBUTING PROGRAMS for more information.
#
# 3.2.11. <program>_CLEANFILES
#
# Extra files to be deleted during 'make clean-<program>'. Can be used to
# clean generated source files.
#
# 3.2.12. <program>_CXX, <config>_CXX and <program>_<config>_CXX
#
# Use to override the compiler used when compiling C++ source files and
# also its configurations. <program>_<config>_CXX defaults to the value
# of <program>_CXX. And <program>_CXX defaults to the value of CXX.
#
# 3.2.13. <program>_CC, <config>_CC and <program>_<config>_CC
#
# Use to override the compiler used when compiling C source files and
# also its configurations. <program>_<config>_CC defaults to the value
# of <program>_CC. And <program>_CC defaults to the value of CC.
#
# 3.2.14. <program>_LD, <config>_LD and <program>_<config>_LD
#
# Analogous to 3.2.13 (<program>_CC), but sets which linker to use.
# If the variable is unset it will default to a predefined choice:
# Pure C projects will default to CC, C++ projects or projects 
# containing both C and C++ files will default to CXX.
#
#
# 4. INVOKATION OF THIS MAKEFILE
#
# 4.1. TARGETS AVAILABLE
#
#   all
#   clean
#   depends
#   clean-depends
#   maintainer-clean
#   check
#   build
#   install
#   uninstall
#   binary-dist
#   describe
#
# As well as for each <program> defined in NODIST_PROGRAMS:
#
#   <program>
#   clean-<program>
#   depends-<program>
#   clean-depends-<program>
#   describe-<program>
#
# And for each configuration listed in <program>_CONFIGURATIONS:
#
#   <program>-<config>
#   clean-<program>-<config>
#   depends-<program>-<config>
#   clean-depends-<program>-<config>
#   describe-<program>-<config>
#
# Programs defined in PROGRAMS have these targets in addition
# to the targets defined in NODIST_PROGRAMS:
#
#   install-<program>
#   uninstall-<program>
#
# In addition the above targets the following are also defined:
#
#   all-<config>
#   clean-<config>
#   depends-<config>
#   clean-depends-<config>
#
# Where all-<config> will build all targets which define the
# configuration named <config>
#
# 4.1.1. TARGET 'all' and 'all-<config>'
#
# The target 'all' builds all configurations for programs defined in PROGRAMS,
# NODIST_PROGRAMS and LIBRARIES, when building dependency information is also used.
#
# The target 'all-<config>' builds all programs, but only in the configuration
# <config>. Only those programs which actually have the configuration are built.
#
# 4.1.2. TARGET 'clean' and 'clean-<config>'
#
# The target 'clean' removes all object files and the programs built.
# Dependency information is not removed.
#
# The target 'clean-<config>' does the same as 'clean' but only for the programs
# which have the configuration <config>.
#
# Clean can be extented to both execute extra targets and clean extra files
# during its invokation. To execute extra targets as part of make clean you
# need to list them in:
#
#   CLEAN_EXTRA_TARGETS =
#
# If you just want to remove some files as part of make 'clean' you need to
# list them in:
#
#   CLEAN_EXTRA_FILES =
#
# The variables CLEAN_EXTRA_TARGETS and CLEAN_EXTRA_FILES only apply to
# the target 'clean' and not to entity-specific cleaning targets.
#
# If you have files generated as part of the build of a specific entity
# and want them to be automatically cleaned as part of an entity-specific
# clean, you can list them in the variable:
#
#   <entity>_<config>_CLEANFILES
#
# Upon invokation of the target clean-<entity>-<config> all files
# listed in <entity>_<config>_CLEANFILES will be removed.
#
# 4.1.3. TARGET 'depends' and 'depends-<config>'
#
# Generates dependency information for source files if not
# already up to date. Generally you never need to invoke this
# by yourself.
#
# The target 'depends-<config>' generates dependency information for all
# programs which have the configuration <config> defined.
#
# 4.1.4. TARGET 'clean-depends' and 'clean-depends-<config>'
#
# Clean dependency information for all programs.
#
# Clean dependency information for all programs which have the
# configuration named <config>.
#
# 4.1.5. TARGET 'maintainer-clean'
#
# Removes both object files and dependency data.
#
# 4.1.6. TARGET '<program>'
#
# Builds all defined configurations for the specified program.
#
# 4.1.7. TARGET 'clean-<program>', 'depends-<program>' and 'clean-depends-<program>'
#
# Invokes the appropriate target, but only for the specified program.
#
# 4.1.8. TARGET 'check'
#
# Runs all tests listed in the variable CHECKS and checks each program
# for a return value of 0 (zero). If the program requires building, it
# should be listed in the variable PROGRAMS or NODIST_PROGRAMS as well.
#
# The target 'check' depends on $(CHECKS) so if test scripts and programs
# need to be built, they will be built before running the tests.
#
# 4.1.9. TARGET 'build'
#
# For use by build servers. First invokes target 'clean', 'maintainer-clean',
# and then builds all targets and invokes target 'check'. If you want to
# run extra steps as part of build you can specify the variable
#
#   BUILD_EXTRA_DEPENDS = 
#
# Those targets will then be added to the end of the dependency list of target build.
#
# 4.1.10. TARGETS 'install' and 'uninstall'
#
# (Only for entities defined in PROGRAMS and LIBRARIES) Uses $(INSTALL) to
# install the binary, data files and documentation files to into the correct paths.
# DESTDIR is supported by the install and uninstall targets.
#
# As only one configuration can be installed at a time, as a default the
# configuration specified by <entity>_INSTALL_CONF is installed.
# <entity>_INSTALL_CONF defaults to the first configuration of
# <entity>_CONFIGURATION.
#
# 4.1.11. TARGET 'binary-dist'
#
# Invokes target 'install' and creates a tar.gz file of the result. Unless
# you know what your are doing, the variable DESTDIR should be set to its
# default during invocation of binary-dist. The tar.gz file will be named:
#
#   $(package)_$(package-version).tar.gz
#
#
# 4.2. SILENT MODE
#
# Per default compilation is done silently, so instead of printing
# the entire compiler invocation command line only "[C++] main.cpp"
# is printed.
# Errors are of course still printed as usual. For build server builds
# and for debugging compiler flags and invocation specify the variable
# VERBOSE with value 1 to get the usual make output with full compiler
# and linker command lines echoing:
#
#   make VERBOSE=1 all
#
# 4.2.1. VARIABLES THAT CONTROL SILENT MODE
#
# 4.2.2. VARIABLE 'VERBOSE'
#
# Setting VERBOSE to 1 (default 0) disables silent mode completely.
#
# 4.2.3. VARIABLE 'VERBOSE_CHECK'
#
# Setting VERBOSE_CHECK to 1 (default the same as VERBOSE) disables silent
# mode for check programs, so that the output of the check programs is printed
# to stdout instead of being discarded.
#
# 4.3. ANSI COLORS IN SILENT MODE
#
# When silent mode is enabled (default) and make is invoked from a tty, then colors
# are per default enabled in the output. To disable this, either specify VERBOSE=1
# or use the specific variable NO_COLORS=1.
# 
#
# 5. EXAMPLES
#
# Here are some example for your consideration. All those examples can be
# extracted with a simple command:
#
#   make -f common.mk extract-example example=NAME
#
# 5.1. THE SIMPLEST MAKEFILE
#
#   Extract with: make -f common.mk extract-example example=SIMPLEST
#
# A Makefile which builds a simple helloworld program with only default settings.
#
# <<BEG: SIMPLEST>>
# package = helloworld
#
# PROGRAMS = helloworld
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<END: SIMPLEST>>
#
# Explanation: The program helloworld is built by only one source file
#  helloworld.cpp, so we do not need to specify the source files. Also
#  we are content with the single default configuration 'Debug' for
#  nothing is specified in helloworld_CONFIGURATIONS (as it is omitted).
#
#
# 5.2. BUILDING TWO PROGRAMS FROM THE SAME SOURCES
#
#   Extract with: make -f common.mk extract-example example=TWO_PROGRAMS
#
# <<BEG: TWO_PROGRAMS>>
# package = greetings
#
# PROGRAMS = hello goodbye
#
# SOURCES = greeting.cpp
#
# hello_SRCS = $(SOURCES)
# hello_DEFINES = MESSAGE="Hello"
#
# goodbye_SRCS = $(SOURCES)
# goodbye_DEFINES = MESSAGE="Goodbye"
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<END: TWO_PROGRAMS>>
#
# Explanation: We specify two programs to be built, hello and goodbye. Because
#  they are both going to use the same source files, we create a variable
#  named SOURCES which contains the common source files for both programs
#  (in this case greetings.cpp). Both (imaginary) programs use a preprocessor
#  define to specify their actual message (MESSAGE=).
#
#
# 5.3. SPECIFYING COMPILER AND SETTINGS
#
#   Extract with: make -f common.mk extract-example example=COMPILER_AND_SETTINGS
#
# <<BEG: COMPILER_AND_SETTINGS>>
# package = helloworld
#
# PROGRAMS = helloworld
#
# hello_SRCS = helloworld.cpp
# hello_CXX = g++-4.1
# hello_CXXFLAGS = -g -O0 -Wall
# hello_LIBS = m
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<END: COMPILER_AND_SETTINGS>>
#
# Explanation: The program helloworld is to be compiled with a specific compiler
#  (in this case g++-4.1 instead of the default g++) and we want the CXXFLAGS
#  to be "-g -O0 -Wall" for hello. Also hello needs to link against "libm.so",
#  so we specify "hello_LIBS = m".
#
#
# 5.4. USING CONFIGURATIONS
#
#   Extract with: make -f common.mk extract-example example=USING_CONFIGS
#
# <<BEG: USING_CONFIGS>>
# package = helloworld
#
# PROGRAMS = helloworld
#
# hello_SRCS = helloworld.cpp
# hello_CXXFLAGS = -g -Wall -O0
# hello_CONFIGURATIONS = DebugLinux DebugWindows
#
# hello_DebugWindows_CXX = i586-mingw32msvc-g++
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<END: USING_CONFIGS>>
#
# Explanation: This example uses the mingw Windows crosscompiler to build a Windows executable
#  on Linux. To do this we specify two configurations: DebugLinux and DebugWindows.
#  Because DebugLinux uses only the default settings (e.g. use the system default CXX)
#  we specify no settings for that particular configuration. However DebugWindows must use
#  the correct compiler which is specified in hello_DebugWindows_CXX. Because all other
#  Settings (LIBS, CXXFLAGS, SRCS, etc.) are shared between the configurations we specify
#  nothing else besides the program specific settings (prefixed with "hello_").
#
#
# 5.5. SPECIFYING COMPILATIONS SETTINGS PER CONFIGURATION
#
#   Extract with: make -f common.mk extract-example example=CONFIG_SETTINGS
#
# <<BEG: CONFIG_SETTINGS>>
# package = helloworld
#
# PROGRAMS = hello goodbye
#
# Debug_CXX = g++-4.0
# Release_CXX = g++-4.0
#
# Debug_CXXFLAGS = -g3 -Wall
# Release_CXXFLAGS = -g0 -O3 -Wall -Werror
#
# hello_CONFIGURATIONS = Debug Release
# goodbye_CONFIGURATIONS = Debug Release
#
# ifndef COMMON_MK_INCLUDED
# include common.mk
# endif
# <<END: CONFIG_SETTINGS>>
#
# Explanation: This example defines two configurations, Release and Debug and applies
#  some settings to those (CXX and CXXFLAGS). When hello and goodbye are compiled
#  later, they will use the settings assigned to the configurations.
#
#
# 6. DISTRIBUTING PROGRAMS
#
# Common.mk includes support for the standard "make install" and "make uninstall"
# targets which install binaries and data files into the standard locations as specified
# by the follow configuration variables (listed with defaults):
#
#		prefix          = /usr/local
#		exec-prefix     = $(prefix) 
#		bindir          = $(exec-prefix)/bin
#		sbindir         = $(exec-prefix)/sbin
#		libexecdir      = $(exec-prefix)/libexec
#		datarootdir     = $(prefix)/share
#		datadir         = $(datarootdir)/$(package-name)
#		sysconfdir      = $(prefix)/etc
#		sharedstatedir  = $(prefix)/com
#		localstatedir   = $(prefix)/var
#		includedir      = $(prefix)/include
#		docdir          = $(datarootdir)/doc/$(package-name)
#		infodir         = $(datarootdir)/info
#		htmldir         = $(docdir)
#		dvidir          = $(docdir)
#		pdfdir          = $(docdir)
#		psdir           = $(docdir)
#		libdir          = $(exec-prefix)/lib
#		lispdir         = $(datarootdir)/emacs/site-lisp
#		localedir       = $(datarootdir)/locale
#		mandir          = $(datarootdir)/man
#
# Also DESTDIR is supported, unless specified DESTDIR defaults to $(package)-$(package-version).
# The above listed variables are currently global and no program or program-configuration specific
# alternatives are supported.
#
# During installation an appropriate install program is choosen from the variables:
#
#		<entity>_<config>_INSTALL
#		<entity>_INSTALL
#		INSTALL
#
# Which unless explicitly overridden defaults to /usr/bin/install. The targets which are
# defined for installation are:
#
#		install-<entity>-<config>
#		install-<entity>
#		install
#
# Where "install" depends on the all <entity>-install targets. <entity>-install is a
# phony target which itself just depends on one of <entity>-<config>-install targets
# as specified by the <entity>_INSTALL_CONF variable. Unless specified the
# <entity>_INSTALL_CONF variable defaults to the first configuration listed in
# <entity>_CONFIGURATIONS and is therefore normally 'Release'.
#
# Currently only entities listed in PROGRAMS and LIBRARIES are installed, to build
# programs which are not supposed to get distributed use NODIST_PROGRAMS. Currently
# NODIST_LIBRARIES is not supported.
#
# 6.1. KNOWN LIMITATIONS
#
# Currently only entities listed in PROGRAMS and LIBRARIES are installed, and the only
# non-compiled files which can be installed are DATA. No support has yet been added for
# documentation, header files etc.
#
#
# 7. GENERAL INFORMATION
#
# 7.1. DEPENDENCY INFORMATION
#
# Dependency information is built by invoking the compiler with the
# -M flags. This information is then saved in .deps/<program>/ in a tree
# which is parallel to the source tree for the program. Dependency info
# for each file is saved in a Makefile snippet with the extensions 
# ".cpp.o.d" for C++ files and ".c.o.d" for C files.
#
# The dependency information is then collected into a Makefile called
# Makefile.depend which saved as .deps/<program>/Makefile.depend
#
# Dependency information is built automatically but can be cleaned and
# forcefully built by building the targets:
#
#    depends
#    clean-depends
#
# 7.2. OBJECT FILES
#
# Object files are saved in .objs/<program>/
#
#
# 8. INDEX OF VARIABLES WHICH CONTROL THE BUILD PROCESS
#
# 8.1. INDEX OF GLOBAL VARIABLES
#
# 8.1.1. CXX CXXDEP CXXLD CXXFLAGS
# 
# Controls which C++ compiler to use when compiling, when generating
# dependencies, which linker to use when linking and which compiler
# flags to use.
#
# See also <entity>_CXX
# See also <entity>_CXXDEP
# See also <entity>_CXXLD
# See also <entity>_CXXFLAGS
#
# 8.1.2. CC CCDEP CCLD CFLAGS
#
# As their CXX counterparts for the C compiler.
#
# See also <entity>_CC
# See also <entity>_CCDEP
# See also <entity>_CCLD
# See also <entity>_CFLAGS
#
# 8.1.3. INSTALL
# 
# Path to the install program, defaults to /usr/bin/install
#
# 8.1.4. PKGCONFIG_EXEC
#
# Path to the pkgconfig program, defaults to /usr/bin/pkgconfig
#
# 8.1.5. MODULE_PREFIX MODULE_SUFFIX MODULE_EXTENSION
# 
# Defaults to "lib", "" and ".so" respectively.
#
# See also <entity>_MODULE_PREFIX
# See also <entity>_MODULE_SUFFIX
# See also <entity>_MODULE_EXTENSION
# See also <entity>_MODULE
#
# 8.1.6. CONFIGURATIONS
# 
# The list of default configurations for entities. Defaults to
# "Debug Release".
# 
# See also <entity>_CONFIGURATIONS
#
#
# 8.2. INDEX OF VARIABLES WHICH APPLY TO ENTITIES
#
# 8.2.1. <entity>_SRCS
# 
# Source files which should be used when building all configurations
# of <entity>.
#
# See also <entity>_<config>_SRCS 
#
# 8.2.2. <entity>_CXXFLAGS
# 
# Compiler flags to use when compiling C++ files for <entity>
#
# See also <entity>_<config>_CXXFLAGS
#
# 8.2.3. <entity>_CFLAGS
# 
# Analogous to <entity>_CXXFLAGS, but for C files.
#
# See also <entity>_<config>_CXXFLAGS
#
# 8.2.4. <entity>_LDFLAGS
# 
# Flags to be used during linking.
#
# See also <entity>_<config>_LDFLAGS
#
# 8.2.5. <entity>_DEFINES
#
# Macros to define when compiling C and C++ files of <entity>. The
# -D required when invoking the compiler should not be prepended to
# macros, instead the variable should be specified for example like this:
#
#    <entity>_DEFINES = NDEBUG MSG="SMURF"
#
# See also <entity>_<config>_DEFINES
#
# 8.2.6. <entity>_UNDEFINES
#
# Complement to <entity>_DEFINES.
#
# See also <entity>_<config>_UNDEFINES
#
# 8.2.7. <entity>_INCLUDES
#
# Include directories to use when compiling C and C++ files of <entity>.
#
# See also <entity>_<config>_INCLUDES 
#
# 8.2.8. <entity>_LIBS
#
# Dynamic libraries to link <entity> against.
#
# See also <entity>_<config>_LIBS
#
# 8.2.9. <entity>_STATIC_LIBS
#
# Static libraries to link <entity> against.
#
# See also <entity>_<config>_STATIC_LIBS
#
# 8.2.10. <entity>_LIBPATHS
# 
# Search directories when locating dynamic and static libraries.
#
# See also <entity>_<config>_LIBPATHS
#
# 8.2.11. <entity>_CONFIGURATIONS
# 
# Lists the configurations of <entity>. Defaults to "Debug Release".
#
# 8.2.12. <entity>_BINDIR
#
# Defaults to "bin".
#
# See also <entity>_<config>_BINDIR
#
# 8.2.13. <entity>_CXX
# 
# The compiler to use when compiling C++ files for <entity>.
# Defaults to $(CXX) which usually defaults to g++.
#
# See also <entity>_<config>_CXX
#
# 8.2.14. <entity>_CXXLD
# 
# The linker to use when linking <entities> which have C++ files as
# part of their sources.
#
# See also <entity>_<config>_CXXLD
#
# 8.2.15. <entity>_CXXDEP
#
# The compiler to use when generating dependency information of
# C++ files for <entity>. Defaults to <entity>_CXX.
#
# See also <entity>_<config>_CXXDEP
#
# 8.2.16. <entity>_CC <entity>_CCLD <entity>_CCDEP
#
# Analogous to their CXX counterparts but for C files.
#
# See also <entity>_<config>_CC
# See also <entity>_<config>_CCLD
# See also <entity>_<config>_CCDEP
#
# 8.2.17. <entity>_INSTALL_CONF
#
# Which configuration of entity to use during make install.
#
# 8.2.18. <entity>_DATA_DIST
# 
# Lists extraneous files to ship as data files during make install.
#
# See also <entity>_<config>_DATA_DIST
#
# 8.2.19. <entity>_CONFIG_FILES
#
# Configuration files which should be generated when building entity.
#
# See also <entity>_<config>_CONFIG_FILES
#
# 8.2.20. <entity>_MODULE_PREFIX <entity>_MODULE_SUFFIX <entity>_MODULE_EXTENSION
#
# The prefix, suffix and extension to use when building libraries.
# Defaults to $(MODULE_PREFIX), $(MODULE_SUFFIX) and $(MODULE_EXTENSION)
#
# See also <entity>_<config>_MODULE_PREFIX
# See also <entity>_<config>_MODULE_SUFFIX
# See also <entity>_<config>_MODULE_EXTENSION
#
# 8.2.21. <entity>_MODULE
#
# Defaults to a concatenation of <entity>_MODULE_PREFIX, <entity>, _SUFFIX
# and _EXTENSION.
#
# See also <entity>_<config>_MODULE
#
# 8.2.22. <entity>_PKGCONFIG
#
# List of pkgconfig libraries to use when building <entity>.
#
# See also <entity>_<config>_PKGCONFIG
#
# 8.2.23. <entity>_PKGCONFIG_EXEC
#
# pkgconfig executable to use when building with pkgconfig libraries.
# Defaults to $(PKGCONFIG_EXEC)
#
# 8.3. INDEX OF VARIABLES WHICH APPLY TO CONFIGURATIONS
#
# <entity>_<config>_SRCS
# <entity>_<config>_CXXFLAGS
# <entity>_<config>_CFLAGS
# <entity>_<config>_LDFLAGS
# <entity>_<config>_DEFINES
# <entity>_<config>_UNDEFINES
# <entity>_<config>_INCLUDES
# <entity>_<config>_LIBS
# <entity>_<config>_STATIC_LIBS
# <entity>_<config>_LIBPATHS
# <entity>_<config>_CXX
# <entity>_<config>_CXXLD
# <entity>_<config>_CXXDEP
# <entity>_<config>_CC
# <entity>_<config>_CCLD
# <entity>_<config>_CCDEP
# <entity>_<config>_INSTALL
# <entity>_<config>_DATA_DIST
# <entity>_<config>_CONFIG_FILES
# <entity>_<config>_MODULE_PREFIX
# <entity>_<config>_MODULE_SUFFIX
# <entity>_<config>_MODULE_EXTENSION
# <entity>_<config>_MODULE
# <entity>_<config>_LIBPATHS
# <entity>_<config>_PKGCONFIG
# <entity>_<config>_PKGCONFIG_EXEC
#
# Please refer to the counterpart from section 8.2.
#
# <entity>_<config>_LIB_<lib>_CONFIG
#
# When linking to a library which is being built from
# the same Makefile, this variable can be used to control
# which configuration of that library to link to. By default
# when a library is linked with an executable it links
# the library in the same configuration which is currently
# being built for the executable.
#   
# <entity>_<pkg>_PKGCONFIG_<config>_versioncheck
#
# TODO: Write docs.
#
# <entity>_<pkg>_PKGCONFIG_<config>_CXXFLAGS
#
# TODO: Write docs.
#
# <entity>_<pkg>_PKGCONFIG_<config>_CFLAGS
#
# TODO: Write docs.
#
# <entity>_<pkg>_PKGCONFIG_<config>_ALLLIBS
#
# TODO: Write docs.
#
# <entity>_<pkg>_PKGCONFIG_<config>_EXCLUDELIBS
#
# TODO: Write docs.
#
# <entity>_<pkg>_PKGCONFIG_<config>_LIBS
#
# TODO: Write docs.
#
#
# 9. DEBUGGING COMMON.MK BEHAVIOUR
#
# Currently number of available tools for debugging common.mk
# behaviour is quite limited in the sense that only one tool
# exists at the time: describing targets.
# 
#
# 9.1. DESCRIBING TARGETS
#
# To help with debugging the behaviour of common.mk several
# targets have been added:
#
#   describe
#
# As well as entity and configuration specific variants:
#
#   describe-<entity>
#   describe-<entity>-<configuration>
#
# These targets print all defined and generated variables
# of an entity (and its configuration, respectively) with the
# set value. Because also generated and internal variables
# are printed this can easily be used for debugging purposes
# (in case you happen to know a bit about common.mk internals).
#
#
# ENDDOC <<DO NOT REMOVE THIS LINE>>
#






#
#
# WARNING WARNING WARNING WARNING WARNING WARNING
#
#   Only super-gurus may edit this file beyond this line.
#
#

COMMON_MK_INCLUDED=1

CXXFLAGS			?= -O0 -g -Wall -fmessage-length=0
Debug_CXXFLAGS		?= -O0 -g -Wall -fmessage-length=0
Release_CXXFLAGS	?= -O2 -Wall -Werror -fmessage-length=0

CFLAGS				?= -O0 -g -Wall -fmessage-length=0
Debug_CFLAGS		?= -O0 -g -Wall -fmessage-length=0
Release_CFLAGS		?= -O2 -Wall -Werror -fmessage-length=0

ARFLAGS				= rcu

VERBOSE				?= 0
VERBOSE_CHECK		?= $(VERBOSE)

CXXLD    			= $(CXX)
CXXDEP   			= $(CXX)
CCLD    			= $(CC)
CCDEP    			= $(CC)

INSTALL				?= /usr/bin/install
PKGCONFIG_EXEC		?= /usr/bin/pkg-config

MODULE_PREFIX		?= lib
MODULE_SUFFIX		?=
MODULE_EXTENSION	?= .so

STATIC_MODULE_PREFIX		?= lib
STATIC_MODULE_SUFFIX		?=
STATIC_MODULE_EXTENSION		?= .a

CONFIGURATIONS		?= Release Debug
BINDIR				?= bin

package-version		?= 0.0.0
package-name		?= $(package)_$(package-version)
prefix				?= /usr/local
exec-prefix			?= $(prefix)
bindir				?= $(exec-prefix)/bin
sbindir				?= $(exec-prefix)/sbin
libexecdir			?= $(exec-prefix)/libexec
datarootdir			?= $(prefix)/share
datadir				?= $(datarootdir)/$(package-name)
sysconfdir			?= $(prefix)/etc
sharedstatedir		?= $(prefix)/com
localstatedir		?= $(prefix)/var
includedir			?= $(prefix)/include
docdir				?= $(datarootdir)/doc/$(package-name)
infodir				?= $(datarootdir)/info
htmldir				?= $(docdir)
dvidir				?= $(docdir)
pdfdir				?= $(docdir)
psdir				?= $(docdir)
libdir				?= $(exec-prefix)/lib
lispdir				?= $(datarootdir)/emacs/site-lisp
localedir			?= $(datarootdir)/locale
mandir				?= $(datarootdir)/man

DESTDIR				?= $(package-name)

# these macros are used to beautify the make output
#
# each command invokation which needs a quiet counterpart, has its quiet counterpart
# defined here in the form 'quiet_' + <REAL COMMAND NAME>, later below then the macro
# Q is defined to be 'quiet_' (unless VERBOSE == 1, when Q is defined to be empty).
# This makes the following input:
#   $($(Q)CXX) to evaluate to $(quiet_CXX) when VERBOSE != 1
# and:
#   $($(Q)CXX) to evaluate to $(CXX) when VERBOSE == 1
# 

ifeq ($(VERBOSE),1)
	NO_COLORS ?= 1
endif

IS_A_TTY=$(shell tty)
ifeq ($(IS_A_TTY),not a tty)
	NO_COLORS ?= 1
endif

ifeq ($(NO_COLORS),1)
	COMMAND_PRE=
	CONFIG_PRE=
	TARGET_PRE=
	LINE_SUF=
else
	COMMAND_PRE=
	CONFIG_PRE=\033[32m
	TARGET_PRE=\033[0;1m
	LINE_SUF=\033[0m
endif

define pretty_PRINT_with_config
	printf "%b%-12s %b%-12s %b%s%b\n" "$(COMMAND_PRE)" "[$(1)]" "$(CONFIG_PRE)" "($(2))" "$(TARGET_PRE)" "$(3)" "$(LINE_SUF)"
endef

define pretty_PRINT
	printf "%b%-12s %b%-12s %b%s%b\n" "$(COMMAND_PRE)" "[$(1)]" "$(CONFIG_PRE)" "" "$(TARGET_PRE)" "$(3)" "$(LINE_SUF)"
endef

define quiet_CXX
	@$(call pretty_PRINT,C++,$<)
	@$(CXX)
endef

define quiet_CXXLD
	@$(call pretty_PRINT,C++ LD,$@)
	@$(CXX)
endef

define quiet_CXXDEP
	@$(call pretty_PRINT,C++ DEP,$<)
	@$(CXX)
endef

define quiet_CC
	@$(call pretty_PRINT,C,$<)
	@$(CC)
endef

define quiet_CCLD
	@$(call pretty_PRINT,C LD,$@)
	@$(CC)
endef

define quiet_CCDEP
	@$(call pretty_PRINT,C DEP,$<)
	@$(CC)
endef

define quiet_AR
	@$(call pretty_PRINT,AR,$<)
	@$(AR)
endef

ifeq ($(VERBOSE),1)
	Q=
	q=
	s=#
else
	Q=quiet_
	q=@
	s=@
endif

ifeq ($(VERBOSE_CHECK),1)
	CHK_REDIR_STDOUT=
	CHK_REDIR_STDERR= 2>&1
	CHK_MSG="[CHECK]        (%02d/%02d) Running check '%s'...\n"
ifeq ($(NO_COLORS),1)
	CHK_MSG_SUCCESS="[CHECK]        (%02d/%02d) Check '%s': SUCCESS\n"
	CHK_MSG_FAILED="[CHECK]        (%02d/%02d) Check '%s': FAILED\n"
else
	CHK_MSG_SUCCESS="[CHECK]        (%02d/%02d) Check '%s': \033[32;1mSUCCESS\033[0m\n"
	CHK_MSG_FAILED="[CHECK]        (%02d/%02d) Check '%s': \033[31;1mFAILED\033[0m\n"
endif
else
	CHK_REDIR_STDOUT= >/dev/null
	CHK_REDIR_STDERR= 2>/dev/null
	CHK_MSG="[CHECK]        (%02d/%02d) Running check '%s'"
ifeq ($(NO_COLORS),1)
	CHK_MSG_SUCCESS=": SUCCESS\n"
	CHK_MSG_FAILED=": FAILED\n"
else
	CHK_MSG_SUCCESS=": \033[32;1mSUCCESS\033[0m\n"
	CHK_MSG_FAILED=": \033[31;1mFAILED\033[0m\n"
endif
endif

DEPSDIR = .deps
OBJSDIR = .objs

#
# a function which chooses which tool to use for a task
#
# params:
#   $(1): program variable name, e.g. CXX
#   $(2): buildable entity, e.g. helloworld
#   $(3): configuration name
#
# an invokation in the form
#
#   CXX = g++-1
#   Debug_CXX = g++-2
#   helloworld_CXX = g++-3
#
#   helloworld_Debug_CXX = $($(call choosetool,CXX,helloworld,Debug))
#   helloworld_Release_CXX = $($(call choosetool,CXX,helloworld,Release))
#   goodbye_Release_CXX = $($(call choosetool,CXX,goodbye,Release))
#
#  will yield:
#
#   helloworld_Debug_CXX == $(Debug_CXX)
#   helloworld_Release_CXX == $(helloworld_CXX) 
#   goodbye_Release_CXX == CXX
#
#  meaning:
#
choose_variable = $(if $($(3)_$(1)),$(3)_$(1),$(if $($(2)_$(1)),$(2)_$(1),$(1)))

choose_linker   = $(if $($(3)_$(1)),$(3)_$(1),$(if $($(2)_$(1)),$(2)_$(1),$(if $($(2)_$(3)_CXXSRCS),$(2)_$(3)_CXXLD,$(2)_$(3)_CCLD)))
choose_linker_name	= $(if $($(3)_$(1)),$(3)_$(1),$(if $($(2)_$(1)),$(2)_$(1),$(if $($(2)_$(3)_CXXSRCS),C++ LD,C LD)))

#
# a template which defines all common variables for an entity
# which are not dependent on configuration
#
# params:
#   $(1): program name
define PROGRAM_VARIABLES_BASE_template
 $(1)_SRCS ?= $(1).cpp
 $(1)_CXXFLAGS ?= $(CXXFLAGS)
 $(1)_CFLAGS ?= $(CFLAGS)
 $(1)_DEFINES ?= $(DEFINES)
 $(1)_UNDEFINES ?= $(UNDEFINES)
 $(1)_INCLUDES ?= $(INCLUDES)
 $(1)_LIBS ?= $(LIBS)
 $(1)_STATIC_LIBS ?= $(STATIC_LIBS)
 $(1)_LIBPATHS ?= $(LIBPATHS)
 $(1)_CONFIGURATIONS ?= $(CONFIGURATIONS)
 $(1)_BINDIR ?= $(BINDIR)
 $(1)_CXX ?= $(CXX)
 $(1)_CXXLD ?= $(CXXLD)
 $(1)_CXXDEP ?= $(CXXDEP)
 $(1)_AR ?= $(AR)
 $(1)_ARFLAGS ?= $(ARFLAGS) 
 $(1)_CC ?= $(CC)
 $(1)_CCLD ?= $(CCLD)
 $(1)_CCDEP ?= $(CCDEP)
 $(1)_INSTALL_CONF ?= $$(firstword $$($(1)_CONFIGURATIONS))
 $(1)_DATA_DIST ?=
 $(1)_CONFIG_FILES ?=
endef

#
# a template which defines all common variables used during compilation
#
# params:
#   $(1): program name
#   $(2): configuration
#
define PROGRAM_VARIABLES_template
 $(1)_$(2)_OBJSDIR = $(OBJSDIR)/$(1)/$(2)
 $(1)_$(2)_SRCS ?= $$($(1)_SRCS)
 $(1)_$(2)_CXXSRCS = $$(filter %.cpp ,$$($(1)_$(2)_SRCS))
 $(1)_$(2)_CSRCS = $$(filter %.c , $$($(1)_$(2)_SRCS))
 $(1)_$(2)_CXXOBJS = $$(addprefix $$($(1)_$(2)_OBJSDIR)/, $$($(1)_$(2)_CXXSRCS:%.cpp=%.cpp.o))
 $(1)_$(2)_COBJS = $$(addprefix $$($(1)_$(2)_OBJSDIR)/, $$($(1)_$(2)_CSRCS:%.c=%.c.o))
 $(1)_$(2)_DEPSDIR = $(DEPSDIR)/$(1)/$(2)
 $(1)_$(2)_CXXDEPS = $$(addprefix $$($(1)_$(2)_DEPSDIR)/, $$($(1)_$(2)_CXXSRCS:%.cpp=%.cpp.o.dep))
 $(1)_$(2)_CDEPS = $$(addprefix $$($(1)_$(2)_DEPSDIR)/, $$($(1)_$(2)_CSRCS:%.c=%.c.o.dep))
 $(1)_$(2)_DEPSFILE = $$($(1)_$(2)_DEPSDIR)/Makefile.depend
 $(1)_$(2)_CXXFLAGS ?= $$($(call choose_variable,CXXFLAGS,$(1),$(2)))
 $(1)_$(2)_CFLAGS ?= $$($(call choose_variable,CFLAGS,$(1),$(2)))
 $(1)_$(2)_LDFLAGS ?= $$($(call choose_variable,LDFLAGS,$(1),$(2)))
 $(1)_$(2)_ARFLAGS ?= $$($(call choose_variable,ARFLAGS,$(1),$(2)))
 $(1)_$(2)_DEFINES ?= $$($(call choose_variable,DEFINES,$(1),$(2)))
 $(1)_$(2)_UNDEFINES ?= $$($(call choose_variable,UNDEFINES,$(1),$(2)))
 $(1)_$(2)_INCLUDES ?= $$($(call choose_variable,INCLUDES,$(1),$(2)))
 $(1)_$(2)_LIBS ?= $$($(call choose_variable,LIBS,$(1),$(2)))
 $(1)_$(2)_STATIC_LIBS ?= $$($(call choose_variable,STATIC_LIBS,$(1),$(2)))
 $(1)_$(2)_LIBPATHS ?= $$($(call choose_variable,LIBPATHS,$(1),$(2)))
 $(1)_$(2)_CXXFLAGS += $$($(1)_$(2)_DEFINES:%=-D%) $$($(1)_$(2)_UNDEFINES:%=-U%) $$($(1)_$(2)_INCLUDES:%=-I%)
 $(1)_$(2)_CFLAGS += $$($(1)_$(2)_DEFINES:%=-D%) $$($(1)_$(2)_UNDEFINES:%=-U%) $$($(1)_$(2)_INCLUDES:%=-I%)
 $(1)_$(2)_CONFIGSTATUS = $$($(1)_$(2)_OBJSDIR)/config.status
 $(1)_$(2)_BINDIR ?= $$($(1)_BINDIR)/$(2)
 $(1)_$(2)_TARGET = $$($(1)_$(2)_BINDIR)/$(1)

 # configuration specific compiler
 $(1)_$(2)_CXX ?= $$($(call choose_variable,CXX,$(1),$(2)))
 $(1)_$(2)_CXXLD ?= $$($(call choose_variable,CXXLD,$(1),$(2)))
 $(1)_$(2)_CXXDEP ?= $$($(call choose_variable,CXXDEP,$(1),$(2)))
 $(1)_$(2)_CC ?= $$($(call choose_variable,CC,$(1),$(2)))
 $(1)_$(2)_CCLD ?= $$($(call choose_variable,CCLD,$(1),$(2)))
 $(1)_$(2)_CCDEP ?= $$($(call choose_variable,CCDEP,$(1),$(2)))
 $(1)_$(2)_AR ?= $$($(call choose_variable,AR,$(1),$(2)))
 $(1)_$(2)_INSTALL ?= $$($(call choose_variable,INSTALL,$(1),$(2)))
 $(1)_$(2)_DATA_DIST ?= $$($(call choose_variable,DATA_DIST,$(1),$(2)))

# configuration options
 $(1)_$(2)_CONFIG_FILES ?= $$($(call choose_variable,CONFIG_FILES,$(1),$(2)))
 $(1)_$(2)_CONFIG_FILES_GEN = $$(addprefix $$($(1)_$(2)_OBJSDIR)/, $$($(1)_$(2)_CONFIG_FILES:%.in=%))

define quiet_$(1)_$(2)_CXX
	@$$(call pretty_PRINT_with_config,C++,$(2),$$<)
	@$$($(1)_$(2)_CXX)
endef

define quiet_$(1)_$(2)_CXXLD
	@$$(call pretty_PRINT_with_config,C++ LD,$(2),$$@)
	@$$($(1)_$(2)_CXXLD)
endef

define quiet_$(1)_$(2)_CXXDEP
	@$$(call pretty_PRINT_with_config,C++ DEP,$(2),$$<)
	@$$($(1)_$(2)_CXXDEP)
endef

define quiet_$(1)_$(2)_CC
	@$$(call pretty_PRINT_with_config,C,$(2),$$<)
	@$$($(1)_$(2)_CC)
endef

define quiet_$(1)_$(2)_CCLD
	@$$(call pretty_PRINT_with_config,C LD,$(2),$$@)
	@$$($(1)_$(2)_CCLD)
endef

define quiet_$(1)_$(2)_CCDEP
	@$$(call pretty_PRINT_with_config,C DEP,$(2),$$<)
	@$$($(1)_$(2)_CCDEP)
endef

define quiet_$(1)_$(2)_AR
	@$$(call pretty_PRINT_with_config,AR,$(2),$$<)
	@$$($(1)_$(2)_AR)
endef

define quiet_$(1)_$(2)_INSTALL
	@$$(call pretty_PRINT_with_config,INSTALL,$(2),$$<)
	@$$($(1)_$(2)_INSTALL)
endef
endef

#
# choose a linker to use for program $(1) with configuration $(2)
#
# WARNING: this cannot be used inside PROGRAM_VARIABLES_template because
#		of some magic make stuff with expansions
#
# $(1): program name
# $(2): configuration
define CHOOSE_LINKER_template
 $(1)_$(2)_LD ?= $$($(call choose_linker,LD,$(1),$(2)))
 $(1)_$(2)_LINKERNAME ?= $(call choose_linker_name,LD,$(1),$(2))

define quiet_$(1)_$(2)_LD
	@$$(call pretty_PRINT_with_config,LINK,$(2),$$@)
	@$$($(1)_$(2)_LD)
endef
endef

#
# a template which defines the variables needed for compiling libraries
#
# params:
#   $(1): program name
define LIBRARY_VARIABLES_BASE_template
 $(1)_MODULE_PREFIX ?= $(MODULE_PREFIX)
 $(1)_MODULE_SUFFIX ?= $(MODULE_SUFFIX)
 $(1)_MODULE_EXTENSION ?= $(MODULE_EXTENSION)
 $(1)_MODULE ?= $$($(1)_MODULE_PREFIX)$(1)$$($(1)_MODULE_SUFFIX)$$($(1)_MODULE_EXTENSION)

# automatically add -fPIC unless -fno-pic is specified
ifeq ($$(findstring -fno-pic,$$($(1)_CXXFLAGS)),)
ifeq ($$(findstring -fPIC,$$($(1)_CXXFLAGS)),)
 $(1)_CXXFLAGS += -fPIC
endif
endif

ifeq ($$(findstring -fno-pic,$$($(1)_CFLAGS)),)
ifeq ($$(findstring -fPIC,$$($(1)_CFLAGS)),)
 $(1)_CFLAGS += -fPIC
endif
endif

endef

#
# a template which defines the variables needed for compiling libaries
#
# params:
#   $(1): program name
#   $(2): configuration
define LIBRARY_VARIABLES_template
 $(1)_$(2)_MODULE_PREFIX ?= $$($(1)_MODULE_PREFIX)
 $(1)_$(2)_MODULE_SUFFIX ?= $$($(1)_MODULE_SUFFIX)
 $(1)_$(2)_MODULE_EXTENSION ?= $$($(1)_MODULE_EXTENSION)
 $(1)_$(2)_MODULE ?= $$($(1)_$(2)_MODULE_PREFIX)$(1)$$($(1)_$(2)_MODULE_SUFFIX)$$($(1)_$(2)_MODULE_EXTENSION)
 $(1)_$(2)_TARGET = $$($(1)_$(2)_BINDIR)/$$($(1)_$(2)_MODULE)

# automatically add -fPIC unless -fno-pic is specified
ifeq ($$(findstring -fno-pic,$$($(1)_$(2)_CXXFLAGS)),)
ifeq ($$(findstring -fPIC,$$($(1)_$(2)_CXXFLAGS)),)
 $(1)_$(2)_CXXFLAGS += -fPIC
endif
endif

ifeq ($$(findstring -fno-pic,$$($(1)_$(2)_CFLAGS)),)
ifeq ($$(findstring -fPIC,$$($(1)_$(2)_CFLAGS)),)
 $(1)_$(2)_CFLAGS += -fPIC
endif
endif

endef

#
# a template which defines the variables needed for compiling static libaries
#
# params:
#   $(1): program name
#   $(2): configuration
#
# a template which defines the variables needed for compiling libraries
#
# params:
#   $(1): program name
define STATIC_LIBRARY_VARIABLES_BASE_template
 $(1)_STATIC_MODULE_PREFIX ?= $(STATIC_MODULE_PREFIX)
 $(1)_STATIC_MODULE_SUFFIX ?= $(STATIC_MODULE_SUFFIX)
 $(1)_STATIC_MODULE_EXTENSION ?= $(STATIC_MODULE_EXTENSION)
 $(1)_STATIC_MODULE ?= $$($(1)_STATIC_MODULE_PREFIX)$(1)$$($(1)_STATIC_MODULE_SUFFIX)$$($(1)_STATIC_MODULE_EXTENSION)
endef

define STATIC_LIBRARY_VARIABLES_template
 $(1)_$(2)_STATIC_MODULE_PREFIX ?= $$($(1)_STATIC_MODULE_PREFIX)
 $(1)_$(2)_STATIC_MODULE_SUFFIX ?= $$($(1)_STATIC_MODULE_SUFFIX)
 $(1)_$(2)_STATIC_MODULE_EXTENSION ?= $$($(1)_STATIC_MODULE_EXTENSION)
 $(1)_$(2)_STATIC_MODULE ?= $$($(1)_$(2)_STATIC_MODULE_PREFIX)$(1)$$($(1)_$(2)_STATIC_MODULE_SUFFIX)$$($(1)_$(2)_STATIC_MODULE_EXTENSION)
 $(1)_$(2)_TARGET = $$($(1)_$(2)_BINDIR)/$$($(1)_$(2)_STATIC_MODULE)
endef

#
# a template which defines targets for creating the build dirs needed for compiling
#
# params:
#   $(1): program name
#   $(2): configuration
define PROGRAM_BUILDDIRS_template
 $$($(1)_$(2)_OBJSDIR):
	@$$(call pretty_PRINT_with_config,MKDIR,$(2),$$@)
	$(q)if [ -x "$$($(1)_$(2)_OBJSDIR)" ]; then if [ ! -d "$$($(1)_$(2)_OBJSDIR)" ]; then -rm -rf "$$($(1)_$(2)_OBJSDIR)"; mkdir -p $$($(1)_$(2)_OBJSDIR); fi; else mkdir -p $$($(1)_$(2)_OBJSDIR); fi

 $$($(1)_$(2)_DEPSDIR):
	@$$(call pretty_PRINT_with_config,MKDIR,$(2),$$@)
	$(q)if [ -x "$$($(1)_$(2)_DEPSDIR)" ]; then if [ ! -d "$$($(1)_$(2)_DEPSDIR)" ]; then -rm -rf "$$($(1)_$(2)_DEPSDIR)"; mkdir -p $$($(1)_$(2)_DEPSDIR); fi; else mkdir -p $$($(1)_$(2)_DEPSDIR); fi
endef

#
# a template which handles configuration files
#
# params:
#   $(1): program name
#   $(2): configuration
define CONFIGURATION_template
 $$($(1)_$(2)_CONFIG_FILES_GEN): $$($(1)_$(2)_OBJSDIR)/%: %.in
	$(q)mkdir -p $$(dir $$@)
	@$$(call pretty_PRINT_with_config,CONFIG,$(2),$$@)
	$(q)cat $$< | \
		sed -e 's@\@$(1)_SRCS\@@$$($(1)_SRCS)@g' | \
		sed -e 's@\@$(1)_DEFINES\@@$$($(1)_DEFINES)@g' | \
		sed -e 's@\@$(1)_UNDEFINES\@@$$($(1)_UNDEFINES)@g' | \
		sed -e 's@\@$(1)_INCLUDES\@@$$($(1)_INCLUDES)@g' | \
		sed -e 's@\@$(1)_LIBS\@@$$($(1)_LIBS)@g' | \
		sed -e 's@\@$(1)_STATIC_LIBS\@@$$($(1)_STATIC_LIBS)@g' | \
		sed -e 's@\@$(1)_LIBPATHS\@@$$($(1)_LIBPATHS)@g' | \
		sed -e 's@\@$(1)_CONFIGURATIONS\@@$$($(1)_CONFIGURATIONS)@g' | \
		sed -e 's@\@$(1)_BINDIR\@@$$($(1)_BINDIR)@g' | \
		sed -e 's@\@$(1)_CXX\@@$$($(1)_CXX)@g' | \
		sed -e 's@\@$(1)_CXXLD\@@$$($(1)_CXXLD)@g' | \
		sed -e 's@\@$(1)_CXXDEP\@@$$($(1)_CXXDEP)@g' | \
		sed -e 's@\@$(1)_CXXFLAGS\@@$$($(1)_CXXFLAGS)@g' | \
		sed -e 's@\@$(1)_CC\@@$$($(1)_CC)@g' | \
		sed -e 's@\@$(1)_CCLD\@@$$($(1)_CCLD)@g' | \
		sed -e 's@\@$(1)_CCDEP\@@$$($(1)_CCDEP)@g' | \
		sed -e 's@\@$(1)_CFLAGS\@@$$($(1)_CFLAGS)@g' | \
		sed -e 's@\@$(1)_INSTALL_CONF\@@$$($(1)_INSTALL_CONF)@g' > $$@

 config-files-$(1)-$(2): $$($(1)_$(2)_CONFIG_FILES_GEN)

 clean-config-files-$(1)-$(2):
	$(q)-rm -f $$($(1)_$(2)_CONFIG_FILES_GEN)

.PHONY: config-files-$(1)-$(2) clean-config-files-$(1)-$(2)
endef

#
# a template which compiles source files and handles source dependency information
#
# params:
#   $(1): program name
#   $(2): configuration
define PROGRAM_template
 $$($(1)_$(2)_DEPSFILE): $$($(1)_$(2)_DEPSDIR) $$($(1)_$(2)_CXXDEPS) $$($(1)_$(2)_CDEPS)
	$(q)-rm -f $$@
	@$$(call pretty_PRINT_with_config,GEN,$(2),$$@)
	$(q)cat $$(filter-out $$($(1)_$(2)_DEPSDIR), $$^) >> $$@

 $$($(1)_$(2)_CONFIGSTATUS): $$($(1)_$(2)_OBJSDIR) $$(addprefix $$($(1)_$(2)_OBJSDIR)/pkgconfig-check-$(1)-,$$($(1)_$(2)_PKGCONFIG)) $$($(1)_$(2)_CONFIG_FILES_GEN)
	@$$(call pretty_PRINT_with_config,TOUCH,$(2),$$@)
	$(q)touch $$($(1)_$(2)_CONFIGSTATUS)

 config-clean-$(1)-$(2): $$(addprefix clean-pkgconfig-check-$(1)-$(2)-,$$($(1)_$(2)_PKGCONFIG))
	@$$(call pretty_PRINT_with_config,CLEAN,$(2),$$($(1)_$(2)_CONFIGSTATUS))
	$(q)-rm -f $$($(1)_$(2)_CONFIGSTATUS)

 $$($(1)_$(2)_CXXOBJS): $$($(1)_$(2)_OBJSDIR)/%.cpp.o: %.cpp
	$(q)mkdir -p $$(dir $$@)
	$$($(Q)$(1)_$(2)_CXX) $$($(1)_$(2)_CXXFLAGS) $$($(1)_$(2)_EXTRA_CXXFLAGS) -c -o $$@ $$<

 $$($(1)_$(2)_CXXDEPS): $$($(1)_$(2)_DEPSDIR)/%.cpp.o.dep: %.cpp
	$(q)mkdir -p $$(dir $$@)
	$$($(Q)$(1)_$(2)_CXXDEP) $$($(1)_$(2)_CXXFLAGS) $$($(1)_$(2)_EXTRA_CXXFLAGS) -MT $$(@:$$($(1)_$(2)_DEPSDIR)/%.cpp.o.dep=$$($(1)_$(2)_OBJSDIR)/%.cpp.o) -MM $$^ > $$@

 $$($(1)_$(2)_COBJS): $$($(1)_$(2)_OBJSDIR)/%.c.o: %.c
	$(q)mkdir -p $$(dir $$@)
	$$($(Q)$(1)_$(2)_CC) $$($(1)_$(2)_CFLAGS) $$($(1)_$(2)_EXTRA_CFLAGS) -c -o $$@ $$<

 $$($(1)_$(2)_CDEPS): $$($(1)_$(2)_DEPSDIR)/%.c.o.dep: %.c
	$(q)mkdir -p $$(dir $$@)
	$$($(Q)$(1)_$(2)_CCDEP) $$($(1)_$(2)_CFLAGS) $$($(1)_$(2)_EXTRA_CFLAGS) -MT $$(@:$$($(1)_$(2)_DEPSDIR)/%.c.o.dep=$$($(1)_$(2)_OBJSDIR)/%.c.o) -MM $$^ > $$@

 clean-depends-$(1)-$(2):
	@$$(call pretty_PRINT_with_config,CLEAN DEPS,$(2),$(1))
	$(q)-rm -rf $$($(1)_$(2)_DEPSDIR)

 clean-pkgconfig-check-$(1)-$(2): $$(addprefix clean-pkgconfig-check-$(1)-$(2)-,$$($(1)_$(2)_PKGCONFIG))

 depends-$(1)-$(2): $$($(1)_$(2)_DEPSFILE)

.PHONY: config-clean-$(1)-$(2) clean-depends-$(1)-$(2) clean-pkgconfig-check-$(1)-$(2) depends-$(1)-$(2)
endef

# we have split this one simple line out of PROGRAM_template in order to have
# invocations of make which do not generate all dependencies upon start
#
# $(1): program
# $(2): config
define INCLUDE_DEPENDENCY_INFO_template
ifneq ($(filter build all %-$(2) $(1),$(MAKECMDGOALS)),)
 -include $$($(1)_$(2)_DEPSFILE)
else
ifeq ($(MAKECMDGOALS),)
 -include $$($(1)_$(2)_DEPSFILE)
endif
endif
endef

#
# a template which defines the targets needed for linkin a program
#
# params:
#   $(1): program name
#   $(2): configuration name

	# TODO:
	# ld on mac osx doesn't support -Wl,-Bdynamic I wonder how I should solve this
	#
	# $$($(Q)$(1)_$(2)_LD) -o $$($(1)_$(2)_TARGET) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($$(sort $(1)_$(2)_LIBPATHS):%=-L%) $$($(1)_$(2)_LDFLAGS) $$($(1)_$(2)_EXTRA_LDFLAGS) -Wl,-Bdynamic $$($(1)_$(2)_LIBS:%=-l%) -Wl,-Bstatic $$($(1)_$(2)_STATIC_LIBS:%=-l%) -Wl,-Bdynamic
define PROGRAM_LINK_template
 $$($(1)_$(2)_TARGET): $$($(1)_$(2)_CONFIGSTATUS) $$($(1)_$(2)_DEPSFILE) $$($(1)_$(2)_OBJSDIR) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_SELFLIBS_TARGETS) $$($(1)_$(2)_SELFSTATICLIBS_TARGETS)
	$(q)if [ -x "$$($(1)_$(2)_BINDIR)" ]; then if [ ! -d "$$($(1)_$(2)_BINDIR)" ]; then -rm -rf "$$($(1)_$(2)_BINDIR)"; mkdir -p $$($(1)_$(2)_BINDIR); fi; else mkdir -p $$($(1)_$(2)_BINDIR); fi
	$$($(Q)$(1)_$(2)_LD) -o $$($(1)_$(2)_TARGET) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($$(sort $(1)_$(2)_LIBPATHS):%=-L%) $$($(1)_$(2)_LDFLAGS) $$($(1)_$(2)_EXTRA_LDFLAGS) $$($(1)_$(2)_LIBS:%=-l%)

 $(1)-$(2): $$($(1)_$(2)_TARGET)

 clean-$(1)-$(2):
	@$$(call pretty_PRINT_with_config,CLEAN,$(2),$(1))
	$(q)-rm -f $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_TARGET)
	$(q)for CLEAN_FILE in $$($(1)_$(2)_CLEANFILES); \
	do \
		echo "[CLEAN]......$$$$CLEAN_FILE"; \
		rm -f $$$$CLEAN_FILE; \
	done

.PHONY: clean-$(1)-$(2) $(1)-$(2)
endef

#
# a template which defines the targets needed for linking a library
#
# params:
#   $(1): program name
#   $(2): configuration name
define LIBRARY_LINK_template
 $$($(1)_$(2)_TARGET): $$($(1)_$(2)_CONFIGSTATUS) $$($(1)_$(2)_DEPSFILE) $$($(1)_$(2)_OBJSDIR) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_SELFLIBS_TARGETS) $$($(1)_$(2)_SELFSTATICLIBS_TARGETS)
	$(q)if [ -x "$$($(1)_$(2)_BINDIR)" ]; then if [ ! -d "$$($(1)_$(2)_BINDIR)" ]; then -rm -rf "$$($(1)_$(2)_BINDIR)"; mkdir -p $$($(1)_$(2)_BINDIR); fi; else mkdir -p $$($(1)_$(2)_BINDIR); fi
	$$($(Q)$(1)_$(2)_LD) -shared -o $$($(1)_$(2)_TARGET) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_LIBPATHS:%=-L%) $$($(1)_$(2)_LDFLAGS) $$($(1)_$(2)_EXTRA_LDFLAGS) -Wl,-Bdynamic $$($(1)_$(2)_LIBS:%=-l%) -Wl,-Bstatic $$($(1)_$(2)_STATIC_LIBS:%=-l%) -Wl,-Bdynamic

 $(1)-$(2): $$($(1)_$(2)_TARGET)

 clean-$(1)-$(2):
	@$$(call pretty_PRINT_with_config,CLEAN,$(2),$(1))
	$(q)-rm -f $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_TARGET)
	$(q)for CLEAN_FILE in $$($(1)_$(2)_CLEANFILES); \
	do \
		echo "[CLEAN]......$$$$CLEAN_FILE"; \
		rm -f $$$$CLEAN_FILE; \
	done

.PHONY: $(1)-$(2) clean-$(1)-$(2)
endef

#
# a template which defines the targets needed for linking a static library
#
# params:
#   $(1): program name
#   $(2): configuration name
define STATIC_LIBRARY_LINK_template
 $$($(1)_$(2)_TARGET): $$($(1)_$(2)_CONFIGSTATUS) $$($(1)_$(2)_DEPSFILE) $$($(1)_$(2)_OBJSDIR) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_SELFLIBS_TARGETS) $$($(1)_$(2)_SELFSTATICLIBS_TARGETS)
	$(q)if [ -x "$$($(1)_$(2)_BINDIR)" ]; then if [ ! -d "$$($(1)_$(2)_BINDIR)" ]; then -rm -rf "$$($(1)_$(2)_BINDIR)"; mkdir -p $$($(1)_$(2)_BINDIR); fi; else mkdir -p $$($(1)_$(2)_BINDIR); fi
	$$($(Q)$(1)_$(2)_AR) $$($(1)_$(2)_ARFLAGS) $$($(1)_$(2)_TARGET) $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS)

 $(1)-$(2): $$($(1)_$(2)_TARGET)

 clean-$(1)-$(2):
	@$$(call pretty_PRINT_with_config,CLEAN,$(2),$(1))
	$(q)-rm -f $$($(1)_$(2)_CXXOBJS) $$($(1)_$(2)_COBJS) $$($(1)_$(2)_TARGET)
	$(q)for CLEAN_FILE in $$($(1)_$(2)_CLEANFILES); \
	do \
		echo "[CLEAN]......$$$$CLEAN_FILE"; \
		rm -f $$$$CLEAN_FILE; \
	done

.PHONY: $(1)-$(2) clean-$(1)-$(2)
endef

#
# a template which modifies <prog>_<config>_LIBPATHS when linking to self-built libraries
#
# params:
#   $(1): program name
#   $(2): configuration
#   $(3): library to link against
#
# depends on:
#   $(3)_<config>_TARGET
define ADD_SELF_LIB_template
 $(1)_$(2)_LIB_$(3)_CONFIG ?= $(2)
 $(1)_$(2)_LIB_$(3)_TARGETPATH ?= $$(dir $$($(3)_$$($(1)_$(2)_LIB_$(3)_CONFIG)_TARGET))
 $(1)_$(2)_LIBPATHS += $$($(1)_$(2)_LIB_$(3)_TARGETPATH)
 $(1)_$(2)_SELFLIBS_TARGETS += $(3)-$$($(1)_$(2)_LIB_$(3)_CONFIG)
 $(1)_$(2)_EXTRA_LDFLAGS += -Wl,-rpath-link=$$(realpath $$($(1)_$(2)_LIB_$(3)_TARGETPATH)) -Wl,-rpath=$$(realpath $$($(1)_$(2)_LIB_$(3)_TARGETPATH))
endef

#
# a template which handles linking to self-built static libraries
#
# params:
#   $(1): program name
#   $(2): configuration
#   $(3): static library to link against
#
# depends on:
#   $(3)_<config>_TARGET
define ADD_SELF_STATIC_LIB_template
 $(1)_$(2)_LIB_$(3)_CONFIG ?= $(2)
 $(1)_$(2)_LIB_$(3)_TARGET ?= $$($(3)_$$($(1)_$(2)_LIB_$(3)_CONFIG)_TARGET)
 $(1)_$(2)_SELFSTATICLIBS_TARGETS += $(3)-$$($(1)_$(2)_LIB_$(3)_CONFIG)
 $(1)_$(2)_EXTRA_LDFLAGS += $$($(1)_$(2)_LIB_$(3)_TARGET)
 $(1)_$(2)_STATIC_LIBS = $$(filter-out $(3),$($(1)_$(2)_STATIC_LIBS))
endef


#
# a template which sets up variables for linking against a library generated from the same makefile
#
# params:
#   $(1): program
#   $(2): config of program
define SELF_LIBS_template
 # handle linking to libraries built within the same Makefile
 # this is only needed for dynamic libs
 $(1)_$(2)_SELFLIBS = $$(filter $$(LIBRARIES),$$($(1)_$(2)_LIBS))
 $(1)_$(2)_SELFSTATICLIBS = $$(filter $$(STATIC_LIBRARIES),$$($(1)_$(2)_STATIC_LIBS))
ifneq ($$($(1)_$(2)_SELFLIBS),)
 $$(foreach lib,$$($(1)_$(2)_SELFLIBS),$$(eval $$(call ADD_SELF_LIB_template,$(1),$(2),$$(lib))))
endif
ifneq ($$($(1)_$(2)_SELFSTATICLIBS),)
 $$(foreach lib,$$($(1)_$(2)_SELFSTATICLIBS),$$(eval $$(call ADD_SELF_STATIC_LIB_template,$(1),$(2),$$(lib))))
endif
endef

#
# a template which defines common rules
#
# params:
#   $(1): program name
define COMMON_RULES_template
 $(1): $$(addprefix $(1)-,$$($(1)_CONFIGURATIONS))

 clean-$(1): $$(addprefix clean-$(1)-,$$($(1)_CONFIGURATIONS))

 depends-$(1): $$(addprefix depends-$(1)-,$$($(1)_CONFIGURATIONS))

 clean-depends-$(1): $$(addprefix clean-depends-$(1)-,$$($(1)_CONFIGURATIONS))

 config-clean-$(1): $$(addprefix config-clean-$(1)-,$$($(1)_CONFIGURATIONS))

 config-files-$(1): $$(addprefix config-files-$(1)-,$$($(1)_CONFIGURATIONS))

 clean-config-files-$(1): $$(addprefix clean-config-files-$(1)-,$$($(1)_CONFIGURATIONS))

 describe-$(1):: $$(addprefix describe-$(1)-,$$($(1)_CONFIGURATIONS))

 install-$(1): install-$(1)-$$($(1)_INSTALL_CONF) install-data-$(1)-$$($(1)_INSTALL_CONF)
 
 uninstall-$(1): uninstall-$(1)-$$($(1)_INSTALL_CONF) uninstall-data-$(1)-$$($(1)_INSTALL_CONF)

.PHONY: $(1) clean-$(1) depends-$(1) clean-depends-$(1) config-clean-$(1) install-$(1) uninstall-$(1)
endef

#
# a template which defines data dist rules
#
# params:
#   $(1): program name
#   $(2): configuration name

## 		echo "[INSTALL]    (data) $$$$DATA_FILE";
define DIST_DATA_template
 install-data-$(1)-$(2): $(1)-$(2) $($(1)_$(2)_DATA_DIST)
ifneq ($$(strip $$($(1)_$(2)_DATA_DIST)),)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(dir) $(DESTDIR)$(datadir))
	@$($(1)_$(2)_INSTALL) -d $(DESTDIR)$(datadir)
	$(q)for DATA_FILE in $$($(1)_$(2)_DATA_DIST); \
	do \
		FILE=`basename $$$$DATA_FILE`; \
		$(call pretty_PRINT_with_config,INSTALL,$(2),(data) $(DESTDIR)$(datadir)/$$$$FILE); \
		$(INSTALL) -m 0644 $$$$DATA_FILE $(DESTDIR)$(datadir); \
	done
endif

 uninstall-data-$(1)-$(2):
	@for DATA_FILE in $$($(1)_$(2)_DATA_DIST); \
	do \
		$(call pretty_PRINT_with_config,UNINSTALL,$(2),(data) $(DESTDIR)$(datadir)/`basename $$$$DATA_FILE`); \
		rm -f $(DESTDIR)$(datadir)/`basename $$$$DATA_FILE` ; \
	done

.PHONY: install-data-$(1)-$(2) uninstall-data-$(1)-$(2)
endef

#
# a template which defines dist rules for programs
#
# params:
#   $(1): program name
#   $(2): configuration name
define DIST_PROGRAM_template
 install-$(1)-$(2): $$($(1)_$(2)_TARGET)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(dir) $(DESTDIR)$(bindir))
	@$($(1)_$(2)_INSTALL) -d $(DESTDIR)$(bindir)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(bin) $(DESTDIR)$(bindir)/$(1))
	@$($(1)_$(2)_INSTALL) -m 0755 $$($(1)_$(2)_TARGET) $(DESTDIR)$(bindir)

 uninstall-$(1)-$(2):
	@$(call pretty_PRINT_with_config,UNINSTALL,$(2),(bin) $(DESTDIR)$(bindir)/$(1))
	@-rm -f $(DESTDIR)$(bindir)/$(1)

.PHONY: install-$(1)-$(2) uninstall-$(1)-$(2)
endef

#
# a template which defines dist rules for libraries
#
# params:
#   $(1): program name
#   $(2): configuration name
define DIST_LIBRARY_template
 install-$(1)-$(2): $$($(1)_$(2)_TARGET)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(dir) $(DESTDIR)$(libdir))
	@$($(1)_$(2)_INSTALL) -d $(DESTDIR)$(libdir)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(lib) $(DESTDIR)$(libdir)/$$($(1)_$(2)_MODULE))
	@$($(1)_$(2)_INSTALL) -m 0755 $$($(1)_$(2)_TARGET) $(DESTDIR)$(libdir)

 uninstall-$(1)-$(2):
	@$(call pretty_PRINT_with_config,UNINSTALL,$(2),(lib) $(DESTDIR)$(libdir)/$$($(1)_$(2)_MODULE))
	@-rm -f $(DESTDIR)$(libdir)/$$($(1)_$(2)_MODULE)

.PHONY: install-$(1)-$(2) uninstall-$(1)-$(2)
endef

#
# a template which defines dist rules for static libraries
#
# params:
#   $(1): program name
#   $(2): configuration name
define DIST_STATIC_LIBRARY_template
 install-$(1)-$(2): $$($(1)_$(2)_TARGET)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(dir) $(DESTDIR)$(libdir))
	@$($(1)_$(2)_INSTALL) -d $(DESTDIR)$(libdir)
	@$(call pretty_PRINT_with_config,INSTALL,$(2),(lib) $(DESTDIR)$(libdir)/$$($(1)_$(2)_STATIC_MODULE))
	@$($(1)_$(2)_INSTALL) -m 0755 $$($(1)_$(2)_TARGET) $(DESTDIR)$(libdir)

 uninstall-$(1)-$(2):
	@$(call pretty_PRINT_with_config,UNINSTALL,$(2),(lib) $(DESTDIR)$(libdir)/$$($(1)_$(2)_STATIC_MODULE))
	@-rm -f $(DESTDIR)$(libdir)/$$($(1)_$(2)_MODULE)

.PHONY: install-$(1)-$(2) uninstall-$(1)-$(2)
endef


#
# a template for pkgconfig variables
#
# params:
#   $(1): program name
#   $(2): configuration
define PKGCONFIG_BASE_template
 $(1)_$(2)_PKGCONFIG ?= $$($(1)_PKGCONFIG)
 $(1)_$(2)_PKGCONFIG_EXEC ?= $$($(call choose_variable,PKGCONFIG_EXEC,$(1),$(2)))
endef

#
# a template for pkgconfig rules 
#
# params:
#   $(1): program name
#   $(2): pkg-config library
#   $(3): configuration
define PKGCONFIG_template
 $(1)_$(3)_PKGCONFIG_$(2)_versioncheck = $$(shell echo $$($(1)_$(3)_PKGCONFIG_$(2)) | sed -e 's/atleast=\(.*\)/--atleast-version=\1/;s/max=\(.*\)/--max-version=\1/;s/exact=\(.*\)/--exact-version=\1/')
 $(1)_$(3)_PKGCONFIG_$(2)_CXXFLAGS = $$(shell $($(1)_$(3)_PKGCONFIG_EXEC) $(2) --cflags)
 $(1)_$(3)_PKGCONFIG_$(2)_CFLAGS = $$(shell $($(1)_$(3)_PKGCONFIG_EXEC) $(2) --cflags)
 $(1)_$(3)_PKGCONFIG_$(2)_ALLLIBS = $$(shell $($(1)_$(3)_PKGCONFIG_EXEC) $(2) --libs)
 $(1)_$(3)_PKGCONFIG_$(2)_EXCLUDELIBS ?= $$($(1)_PKGCONFIG_$(2)_EXCLUDELIBS) 
 $(1)_$(3)_PKGCONFIG_$(2)_LIBS = $$(filter-out $$(addprefix -l,$$($(1)_$(3)_PKGCONFIG_$(2)_EXCLUDELIBS)),$$($(1)_$(3)_PKGCONFIG_$(2)_ALLLIBS))
 $(1)_$(3)_EXTRA_CXXFLAGS += $$($(1)_$(3)_PKGCONFIG_$(2)_CXXFLAGS)
 $(1)_$(3)_EXTRA_CFLAGS += $$($(1)_$(3)_PKGCONFIG_$(2)_CFLAGS)
 $(1)_$(3)_EXTRA_LDFLAGS += $$($(1)_$(3)_PKGCONFIG_$(2)_LIBS)

 $$($(1)_$(3)_OBJSDIR)/pkgconfig-check-$(1)-$(2): $$($(1)_$(3)_OBJSDIR) $(firstword $(MAKEFILE_LIST))
ifneq ($$($(1)_$(3)_PKGCONFIG_$(2)),)
	$(q)printf "%b%-12s %b%-12s %b%s%b: " "$(COMMAND_PRE)" "[PKGCONF]" "$(CONFIG_PRE)" "($(3))" "$(TARGET_PRE)" "Checking for $(2) ($$($(1)_$(3)_PKGCONFIG_$(2)))" "$(LINE_SUF)"
else
	$(q)printf "%b%-12s %b%-12s %b%s%b: " "$(COMMAND_PRE)" "[PKGCONF]" "$(CONFIG_PRE)" "($(3))" "$(TARGET_PRE)" "Checking for $(2)" "$(LINE_SUF)"
endif
	$(q)if [ ! -x "$($(1)_$(3)_PKGCONFIG_EXEC)" ]; then \
		echo "pkg-config is not installed ($($(1)_$(3)_PKGCONFIG_EXEC))."; \
		exit 1; \
	fi
	$(q)$($(1)_$(3)_PKGCONFIG_EXEC) $(2); \
	if [ "$$$$?" != "0" ]; then \
		echo "$(2) NOT INSTALLED"; \
		exit 1; \
	else \
		$($(1)_$(3)_PKGCONFIG_EXEC) $(2) $$($(1)_$(3)_PKGCONFIG_$(2)_versioncheck); \
		if [ "$$$$?" != "0" ]; then \
			echo "WRONG VERSION (available = `pkg-config $(2) --modversion`)"; \
			exit 1; \
		else \
			echo OK; \
		fi \
	fi
	$(q)touch $$($(1)_$(3)_OBJSDIR)/pkgconfig-check-$(1)-$(2)

 clean-pkgconfig-check-$(1)-$(3)-$(2):
	$(q)-rm -f $$($(1)_$(3)_OBJSDIR)/pkgconfig-check-$(1)-$(2)

.PHONY: clean-pkgconfig-check-$(1)-$(3)-$(2)
endef

#
# prints a variable name and its value
#
# $(1): variable_name
define print_variable
	@echo $(1) = $($(1))
endef

#
# describe an entity
#
# $(1): entity
define DESCRIBE_template
 describe-$(1)::
	$$(call print_variable,$(1)_SRCS)
	$$(call print_variable,$(1)_CXXFLAGS)
	$$(call print_variable,$(1)_CFLAGS)
	$$(call print_variable,$(1)_DEFINES)
	$$(call print_variable,$(1)_UNDEFINES)
	$$(call print_variable,$(1)_INCLUDES)
	$$(call print_variable,$(1)_LIBS)
	$$(call print_variable,$(1)_STATIC_LIBS)
	$$(call print_variable,$(1)_LIBPATHS)
	$$(call print_variable,$(1)_CONFIGURATIONS)
	$$(call print_variable,$(1)_BINDIR)
	$$(call print_variable,$(1)_CXX)
	$$(call print_variable,$(1)_CXXLD)
	$$(call print_variable,$(1)_CXXDEP)
	$$(call print_variable,$(1)_CC)
	$$(call print_variable,$(1)_CCLD)
	$$(call print_variable,$(1)_CCDEP)
	$$(call print_variable,$(1)_INSTALL_CONF)

.PHONY: describe-$(1)
endef

#
# describe the program in its specified configuration
#
# $(1): program
# $(2): configuration
define DESCRIBE_WITH_CONFIG_template
 describe-$(1)-$(2)::
	$$(call print_variable,$(1)_$(2)_OBJSDIR)
	$$(call print_variable,$(1)_$(2)_SRCS)
	$$(call print_variable,$(1)_$(2)_CXXSRCS)
	$$(call print_variable,$(1)_$(2)_CSRCS)
	$$(call print_variable,$(1)_$(2)_CXXOBJS)
	$$(call print_variable,$(1)_$(2)_COBJS)
	$$(call print_variable,$(1)_$(2)_DEPSDIR)
	$$(call print_variable,$(1)_$(2)_CXXDEPS)
	$$(call print_variable,$(1)_$(2)_CDEPS)
	$$(call print_variable,$(1)_$(2)_DEPSFILE)
	$$(call print_variable,$(1)_$(2)_CXXFLAGS)
	$$(call print_variable,$(1)_$(2)_CFLAGS)
	$$(call print_variable,$(1)_$(2)_DEFINES)
	$$(call print_variable,$(1)_$(2)_UNDEFINES)
	$$(call print_variable,$(1)_$(2)_INCLUDES)
	$$(call print_variable,$(1)_$(2)_LIBS)
	$$(call print_variable,$(1)_$(2)_SELFLIBS)
	$$(call print_variable,$(1)_$(2)_SELFLIBS_TARGETS)
	$$(call print_variable,$(1)_$(2)_SELFSTATICLIBS)
	$$(call print_variable,$(1)_$(2)_SELFSTATICLIBS_TARGETS)
	$$(call print_variable,$(1)_$(2)_STATIC_LIBS)
	$$(call print_variable,$(1)_$(2)_LIBPATHS)
	$$(call print_variable,$(1)_$(2)_CXXFLAGS)
	$$(call print_variable,$(1)_$(2)_CFLAGS)
	$$(call print_variable,$(1)_$(2)_CONFIGSTATUS)
	$$(call print_variable,$(1)_$(2)_BINDIR)
	$$(call print_variable,$(1)_$(2)_TARGET)

	$$(call print_variable,$(1)_$(2)_CXX)
	$$(call print_variable,$(1)_$(2)_CXXLD)
	$$(call print_variable,$(1)_$(2)_CXXDEP)
	$$(call print_variable,$(1)_$(2)_CC)
	$$(call print_variable,$(1)_$(2)_CCLD)
	$$(call print_variable,$(1)_$(2)_CCDEP)

	$$(call print_variable,$(1)_$(2)_PKGCONFIG)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_EXEC)

.PHONY: describe-$(1)-$(2)
endef

#
# $(1): program
# $(2): config
# $(3): pkg-config library
define DESCRIBE_PKGCONFIG_template
 describe-$(1)-$(2)::
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_versioncheck)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_CXXFLAGS)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_CFLAGS)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_ALLLIBS)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_EXCLUDELIBS)
	$$(call print_variable,$(1)_$(2)_PKGCONFIG_$(3)_LIBS)
endef

#
# $(1): program
# $(2): config
# $(3): selflib
#
define DESCRIBE_SELFLIBS_template
 describe-$(1)-$(2)::
	$$(call print_variable,$(1)_$(2)_LIB_$(3)_CONFIG)
	$$(call print_variable,$(1)_$(2)_LIB_$(3)_TARGETPATH)
endef

#
# the following three templates are used to create targets
# to build all programs which defines a specific configuration,
# e.g. all-Debug or clean-Debug
#
define COLLECT_CONFIGURATIONS_template
 ALL_REGISTERED_CONFIGURATIONS = $$(sort $(ALL_REGISTERED_CONFIGURATIONS) $$($(1)_CONFIGURATIONS))
endef

define BUILD_CONFIG_TO_TARGET_MAP_template
ifneq ($$(filter $(1),$$($(2)_CONFIGURATIONS)),)
 $(1)_TARGETS += $(2)
endif
endef

define BUILD_BY_CONFIGURATION_template
 all-$(1): $$(addsuffix -$(1),$$($(1)_TARGETS))

 clean-$(1): $$(addsuffix -$(1),$$(addprefix clean-,$$($(1)_TARGETS)))

 depends-$(1): $$(addsuffix -$(1),$$(addprefix depends-,$$($(1)_TARGETS)))

 clean-depends-$(1): $$(addsuffix -$(1),$$(addprefix clean-depends-,$$($(1)_TARGETS)))

 describe-all-$(1): $$(addsuffix -$(1),$$(addprefix describe-,$$($(1)_TARGETS)))

.PHONY: all-$(1) clean-$(1) depends-$(1) clean-depends-$(1) describe-all-$(1)
endef

# only do the next steps if we actually need them
# otherwise make manual can trigger a dependency build

ifneq ($(MAKECMDGOALS),bootstrap)
ifneq ($(MAKECMDGOALS),manual)
ifneq ($(MAKECMDGOALS),manual-plain)
ifneq ($(MAKECMDGOALS),manual-toc)
ifneq ($(MAKECMDGOALS),extract-example)

ifndef package
$(error You must assign the variable 'package')
endif

# setup up some variables to make the following lines easier to use
ENTITIES = $(PROGRAMS) $(NODIST_PROGRAMS) $(LIBRARIES) $(STATIC_LIBRARIES)

# generate variables for programs
# first generate variables which are not dependent on configurations
$(foreach prog,$(ENTITIES),$(eval $(call PROGRAM_VARIABLES_BASE_template,$(prog))))

# then generate the variables which are dependent on configurations
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call PROGRAM_VARIABLES_template,$(prog),$(config)))))

# generate configuration files rules
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call CONFIGURATION_template,$(prog),$(config)))))

# choose linker
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call CHOOSE_LINKER_template,$(prog),$(config)))))

$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call PROGRAM_BUILDDIRS_template,$(prog),$(config)))))

$(foreach prog,$(LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call LIBRARY_VARIABLES_BASE_template,$(prog),$(config)))))
$(foreach prog,$(LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call LIBRARY_VARIABLES_template,$(prog),$(config)))))

$(foreach prog,$(STATIC_LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call STATIC_LIBRARY_VARIABLES_BASE_template,$(prog),$(config)))))
$(foreach prog,$(STATIC_LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call STATIC_LIBRARY_VARIABLES_template,$(prog),$(config)))))

# handle self lib linking
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call SELF_LIBS_template,$(prog),$(config)))))

# pkg-config
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call PKGCONFIG_BASE_template,$(prog),$(config)))))
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(foreach lib,$($(prog)_$(config)_PKGCONFIG),$(eval $(call PKGCONFIG_template,$(prog),$(lib),$(config))))))

# generate dependency tree and compiling of objects
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call PROGRAM_template,$(prog),$(config)))))

# handle the inclusion of the dependency Makefiles
$(foreach prog,$(ENTITIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call INCLUDE_DEPENDENCY_INFO_template,$(prog),$(config)))))

$(foreach prog,$(PROGRAMS) $(NODIST_PROGRAMS),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call PROGRAM_LINK_template,$(prog),$(config)))))
$(foreach prog,$(LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call LIBRARY_LINK_template,$(prog),$(config)))))
$(foreach prog,$(STATIC_LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call STATIC_LIBRARY_LINK_template,$(prog),$(config)))))

# distribution
$(foreach prog,$(PROGRAMS) $(LIBRARIES) $(STATIC_LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call DIST_DATA_template,$(prog),$(config)))))
$(foreach prog,$(PROGRAMS),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call DIST_PROGRAM_template,$(prog),$(config)))))
$(foreach prog,$(LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call DIST_LIBRARY_template,$(prog),$(config)))))
$(foreach prog,$(STATIC_LIBRARIES),$(foreach config,$($(prog)_CONFIGURATIONS),$(eval $(call DIST_STATIC_LIBRARY_template,$(prog),$(config)))))

# setup common rules
$(foreach prog,$(ENTITIES),$(eval $(call COMMON_RULES_template,$(prog))))

# compute a list of all known configurations
$(foreach prog,$(ENTITIES),$(eval $(call COLLECT_CONFIGURATIONS_template,$(prog))))
$(foreach config,$(ALL_REGISTERED_CONFIGURATIONS),$(foreach prog,$(ENTITIES),$(eval $(call BUILD_CONFIG_TO_TARGET_MAP_template,$(config),$(prog)))))
# and create targets to build by configurations
$(foreach config,$(ALL_REGISTERED_CONFIGURATIONS),$(eval $(call BUILD_BY_CONFIGURATION_template,$(config))))

# create describe rules
$(foreach entity,$(ENTITIES),$(eval $(call DESCRIBE_template,$(entity))))
$(foreach entity,$(ENTITIES),$(foreach config,$($(entity)_CONFIGURATIONS),$(eval $(call DESCRIBE_WITH_CONFIG_template,$(entity),$(config)))))
# describe each pkg-config
$(foreach entity,$(ENTITIES),$(foreach config,$($(entity)_CONFIGURATIONS),$(foreach pkg,$($(entity)_$(config)_PKGCONFIG),$(eval $(call DESCRIBE_PKGCONFIG_template,$(entity),$(config),$(pkg))))))
# describe each self-lib
$(foreach entity,$(ENTITIES),$(foreach config,$($(entity)_CONFIGURATIONS),$(foreach selflib,$($(entity)_$(config)_SELFLIBS),$(eval $(call DESCRIBE_SELFLIBS_template,$(entity),$(config),$(selflib))))))
endif
endif
endif
endif
endif

all: $(ENTITIES)

clean: $(addprefix clean-,$(ENTITIES)) $(CLEAN_EXTRA_TARGETS)
	$(q)-rm -rf $(OBJSDIR)
	$(q)-rm -rf $(DESTDIR)
	$(q)-rm -rf $(package-name).tar.gz
	$(q)-rm -rf $(CLEAN_EXTRA_FILES)

clean-depends: $(addprefix clean-depends-,$(ENTITIES))
	$(q)-rm -rf $(DEPSDIR)

maintainer-clean: clean-depends clean $(addprefix config-clean-,$(ENTITIES))

depends: $(addprefix depends-,$(ENTITIES))

config-files: $(addprefix config-files-,$(ENTITIES))

clean-config-files: $(addprefix clean-config-files-,$(ENTITIES))

install: $(addprefix install-,$(PROGRAMS) $(LIBRARIES))

uninstall: $(addprefix uninstall-,$(PROGRAMS) $(LIBRARIES))

describe: $(addprefix describe-,$(ENTITIES))

$(package-name).tar.gz: install
	$(s)echo '[DIST]       $(package-name).tar.gz'
	$(q)tar -c -h -o -C $(DESTDIR) -f - . | gzip -9 -c > $(package-name).tar.gz
	$(q)rm -rf $(DESTDIR)

binary-dist: $(package-name).tar.gz

check: $(CHECKS)
	@echo '[CHECK]      Running $(words $(CHECKS)) self test(s)... '
	@I=0; FAILED=0; for CHECK in $(CHECKS); \
	do \
		I=`echo $$I+1 | bc`; \
		printf $(CHK_MSG) $$I $(words $(CHECKS)) $$CHECK; \
		./$$CHECK $(CHK_REDIR_STDOUT) $(CHK_REDIR_STDERR); \
		if [ "$$?" != "0" ]; then \
			printf $(CHK_MSG_FAILED) $$I $(words $(CHECKS)) $$CHECK; \
			FAILED=`echo $$FAILED+1 | bc`; \
		else \
			printf $(CHK_MSG_SUCCESS) $$I $(words $(CHECKS)) $$CHECK; \
		fi; \
	done; \
	if [ "$$FAILED" != "0" ]; then \
		echo "[CHECK]      FAILURE: $$FAILED of $(words $(CHECKS)) tests failed"; \
		exit 1; \
	fi 
	@echo '[CHECK]      DONE'

build: maintainer-clean all check $(BUILD_EXTRA_DEPENDS)

#
# the manual targets use perl instead of sed because
# the sed shipped on mac doesn't support escape sequences (\t e.g.)
#
manual-plain:
	@cat common.mk | \
		grep '^#' | \
		awk '/BEGDOC/,/ENDDOC/{ if (/BEGDOC/ || /ENDDOC/) next; print }' | \
		cut -c2- | \
		perl -ne 'BEGIN { $$indent = 0; } \
			if (/^ ((([0-9]{1,}\.){1,}) .*)$$/) \
			{ \
				my $$toc = $$1; \
				my $$level = $$2; \
				$$level =~ s/[^\.]//g; \
				$$indent = length($$level); \
				print " " x $$level; \
				print "$$toc"; \
			} else { \
				print " " x $$indent; \
				print " " . $$_; \
			}'

manual:
	@cat common.mk | \
		grep '^#' | \
		awk '/BEGDOC/,/ENDDOC/{ if (/BEGDOC/ || /ENDDOC/) next; print }' | \
		cut -c2- | \
		perl -ne 'BEGIN { $$indent = 0; } \
			if (/^ ((([0-9]{1,}\.){1,}) .*)$$/) \
			{ \
				my $$toc = $$1; \
				my $$level = $$2; \
				$$level =~ s/[^\.]//g; \
				$$indent = length($$level); \
				print " " x $$level; \
				print "\x1b[01;04m$$toc\x1b[0m\n"; \
			} else { \
				print " " x $$indent; \
				if (/^ {3,4}/) { \
					print " " . "\x1b[33m$$_\x1b[0m"; \
				} else { \
					print " " . $$_; \
				} \
			}'

#		sed -e '/^ [0-9]\./!s/.*/\t&/' | \
#		sed -e '/^ [0-9]\./!s/\([a-z]\{3,\}-\)*<[a-z]\{3,\}>/\x1b[33m&\x1b[0m/g' | \
#		sed -e '/^ [0-9]\./!s/\(<\?[a-z]\{3,\}>\?\)\?[A-Z0-9_]\{3,\}/\x1b[32m&\x1b[0m/g' | \
#		sed -e 's/^ \([0-9]\..*\)$$/ \x1b[01;04m\1\x1b[0m/' | \
#		sed -e 's/$$(.*)/\x1b[32m&\x1b[0m/'

manual-toc:
	@cat common.mk | \
		grep '^#' | \
		awk '/BEGDOC/,/ENDDOC/{ if (/BEGDOC/ || /ENDDOC/) next; print }' | \
		cut -c2- | \
		perl -ne 'if (/^ ((([0-9]{1,}\.){1,}) .*)$$/) \
			{ \
				my $$toc = $$1; \
				my $$heading = $$2; \
				$$heading =~ s/[^\.]//g; \
				print "  " x length($$heading); \
				print "\x1b[01;04m$$toc\x1b[0m\n"; \
			}'

bootstrap:
ifndef package
	$(error USAGE: 'make -f common.mk bootstrap package=helloworld')
endif
	@echo '#'
	@echo '# Makefile for package $(package)'
	@echo '#'
	@echo
	@echo package = $(package)
	@echo
	@echo PROGRAMS = $(package)
	@echo
	@printf '$(package)_SRCS = '
	@if [ -d src ]; then \
		for FILE in `find src -type f -name '*.cpp' -o -name '*.c'`; do \
			printf '\\\n\t%s ' $$FILE; \
		done; \
	else \
		echo $(package).cpp; \
	fi
	@echo
	@echo
	@echo ifndef COMMON_MK_INCLUDED
	@echo include common.mk
	@echo endif
	@echo '# DO NOT DELETE'

extract-example:
ifndef example
	$(error USAGE: 'make -f common.mk extract-example example=NAME_OF_EXAMPLE')
endif
	@cat common.mk | \
		grep '^#' | \
		awk '/BEGDOC/,/ENDDOC/{ if (/BEGDOC/ || /ENDDOC/) next; print }' | \
		cut -c3- | \
		awk '/<<BEG: $(example)>>/,/<<END: $(example)>>/{ if (/<<BEG/ || /<<END/) next; print }'

.PHONY: all clean clean-depends maintainer-clean depends config-files build binary-dist bootstrap
.PHONY: manual manual-toc manual-plain bootstrap extract-example install uninstall describe

.DEFAULT_GOAL := all
# DO NOT DELETE



