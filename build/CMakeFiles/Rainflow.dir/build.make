# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /datadisk/git/rainflow

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /datadisk/git/rainflow/build

# Include any dependencies generated for this target.
include CMakeFiles/Rainflow.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Rainflow.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Rainflow.dir/flags.make

CMakeFiles/Rainflow.dir/rainflow.c.o: CMakeFiles/Rainflow.dir/flags.make
CMakeFiles/Rainflow.dir/rainflow.c.o: ../rainflow.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/datadisk/git/rainflow/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/Rainflow.dir/rainflow.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/Rainflow.dir/rainflow.c.o   -c /datadisk/git/rainflow/rainflow.c

CMakeFiles/Rainflow.dir/rainflow.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/Rainflow.dir/rainflow.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /datadisk/git/rainflow/rainflow.c > CMakeFiles/Rainflow.dir/rainflow.c.i

CMakeFiles/Rainflow.dir/rainflow.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/Rainflow.dir/rainflow.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /datadisk/git/rainflow/rainflow.c -o CMakeFiles/Rainflow.dir/rainflow.c.s

CMakeFiles/Rainflow.dir/rainflow.c.o.requires:

.PHONY : CMakeFiles/Rainflow.dir/rainflow.c.o.requires

CMakeFiles/Rainflow.dir/rainflow.c.o.provides: CMakeFiles/Rainflow.dir/rainflow.c.o.requires
	$(MAKE) -f CMakeFiles/Rainflow.dir/build.make CMakeFiles/Rainflow.dir/rainflow.c.o.provides.build
.PHONY : CMakeFiles/Rainflow.dir/rainflow.c.o.provides

CMakeFiles/Rainflow.dir/rainflow.c.o.provides.build: CMakeFiles/Rainflow.dir/rainflow.c.o


# Object files for target Rainflow
Rainflow_OBJECTS = \
"CMakeFiles/Rainflow.dir/rainflow.c.o"

# External object files for target Rainflow
Rainflow_EXTERNAL_OBJECTS =

rfc.mexa64: CMakeFiles/Rainflow.dir/rainflow.c.o
rfc.mexa64: CMakeFiles/Rainflow.dir/build.make
rfc.mexa64: /usr/local/MATLAB/R2017b/bin/glnxa64/libmx.so
rfc.mexa64: /usr/local/MATLAB/R2017b/bin/glnxa64/libmex.so
rfc.mexa64: /usr/local/MATLAB/R2017b/bin/glnxa64/libmex.so
rfc.mexa64: /usr/local/MATLAB/R2017b/bin/glnxa64/libmx.so
rfc.mexa64: CMakeFiles/Rainflow.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/datadisk/git/rainflow/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library rfc.mexa64"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Rainflow.dir/link.txt --verbose=$(VERBOSE)
	/usr/bin/cmake -E make_directory /datadisk/git/rainflow/build/mex//
	/usr/bin/cmake -E copy /datadisk/git/rainflow/build/rfc.mexa64 /datadisk/git/rainflow/build/mex//

# Rule to build all files generated by this target.
CMakeFiles/Rainflow.dir/build: rfc.mexa64

.PHONY : CMakeFiles/Rainflow.dir/build

CMakeFiles/Rainflow.dir/requires: CMakeFiles/Rainflow.dir/rainflow.c.o.requires

.PHONY : CMakeFiles/Rainflow.dir/requires

CMakeFiles/Rainflow.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Rainflow.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Rainflow.dir/clean

CMakeFiles/Rainflow.dir/depend:
	cd /datadisk/git/rainflow/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /datadisk/git/rainflow /datadisk/git/rainflow /datadisk/git/rainflow/build /datadisk/git/rainflow/build /datadisk/git/rainflow/build/CMakeFiles/Rainflow.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Rainflow.dir/depend

