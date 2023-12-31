# CMakeLists for rainflow
# 2023, Andreas Martin

# First set Matlab_ROOT_DIR environment variable to your installed matlab path,
# such as 'export Matlab_ROOT_DIR=/usr/local/MATLAB/R2017b'!
# (GNUC: gcc for C file, g++ for CXX files)

# Building makefiles:
# mkdir build
# cd build
# cmake -G "Visual Studio 14 2015 Win64" ..


cmake_minimum_required( VERSION 3.24 )
set( CMAKE_VERBOSE_MAKEFILE OFF )
set( CMAKE_BUILD_PARALLEL_LEVEL 12 )

if( POLICY CMP0076 )
  cmake_policy(SET CMP0076 NEW)
endif()

# Project name and version
project( rainflow )
set( RFC_VERSION_MAJOR "0" )
set( RFC_VERSION_MINOR "8" )


# Build type and compiler selection
if( NOT CMAKE_CONFIGURATION_TYPES )
    get_property( HAVE_MULTI_CONFIG_GENERATOR GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG )
    # Set default configuration types for multi-config generators
    if( HAVE_MULTI_CONFIG_GENERATOR )
        set( CMAKE_CONFIGURATION_TYPES "Release;Debug" )
    endif()
endif()

# C++11
set( CMAKE_CXX_STANDARD 11 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )
set( CMAKE_CXX_EXTENSIONS ON )
set( CMAKE_POSITION_INDEPENDENT_CODE ON )


# Options valid, if project compiled as standalone only
if( CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR )
    set( CMAKE_BUILD_TYPE Release CACHE STRING "Release" FORCE )
    #set( CMAKE_BUILD_TYPE Debug   CACHE STRING "Debug"   FORCE )

    message( STATUS "Build ${PROJECT_NAME} as main project")
    option( RFC_MINIMAL                "(Disable all other flags)" OFF )
    option( RFC_USE_INTEGRAL_COUNTS    "Use integral (non-floating) data type for counts" OFF )
    option( RFC_USE_HYSTERESIS_FILTER  "Use hysteresis filtering" ON )
    option( RFC_USE_DELEGATES          "Use delegates (functors)" ON )
    option( RFC_GLOBAL_EXTREMA         "Always calculate global extrema" ON )
    option( RFC_HCM_SUPPORT            "Support HCM (Clormann/Seeger) algorithm" ON )
    option( RFC_ASTM_SUPPORT           "Support ASTM E 1049-85 algorithm" ON )
    option( RFC_TP_SUPPORT             "Support turning points" ON )
    option( RFC_DH_SUPPORT             "Support \"spread damage\" over turning points and damage history" ON )
    option( RFC_AT_SUPPORT             "Support amplitude transformation regarding mean load influence on fatigue strength" ON )
    option( RFC_AR_SUPPORT             "Support automatic growth of counting buffers" OFF )
    option( RFC_DAMAGE_FAST            "Enables fast damage calculation (per look-up table)" ON )
    option( RFC_DEBUG_FLAGS            "Enables flags for detailed examination" OFF )
    option( RFC_EXPORT_MEX             "Export a function wrapper for MATLAB(R)" ON )
    option( RFC_TEST                   "Generate rainflow testing program" ON )
else()
    message( STATUS "Build ${PROJECT_NAME} as subsequent project")
endif()

# Save options in configuration file
add_definitions( -DRFC_HAVE_CONFIG_H )
configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/src/config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/src/config.h )


if( CMAKE_BUILD_TYPE MATCHES Debug ) 
    message( STATUS "Rainflow: Debug build" ) 
    add_definitions( -DDEBUG -D_DEBUG ) 
endif() 

# Compiler dependencies
if( MSVC )
    # Turn off misguided "secure CRT" warnings in MSVC.
    # Microsoft wants people to use the MS-specific <function>_s
    # versions of certain C functions but this is difficult to do
    # in platform-independent code.
    add_definitions( -D_CRT_SECURE_NO_WARNINGS )
endif()

# Math library
find_library( LIBM_LIBRARY NAMES m )
if( NOT LIBM_LIBRARY )
    set( LIBM_LIBRARY "" )
endif()


# MATLAB
if( RFC_EXPORT_MEX )
    # find MATLAB
    set( MATLAB_FIND_DEBUG 1 )
    set( MATLAB_ADDITIONAL_VERSIONS "R2019b=9.7" )
    set( VERSION_MATLAB 9 CACHE STRING "The required Matlab installation (at least R2015b)"  )
    if( DEFINED ENV{Matlab_ROOT_DIR} )
        set( Matlab_ROOT_DIR $ENV{Matlab_ROOT_DIR} )
    endif()
    if( NOT Matlab_ROOT_DIR )
        set( Matlab_ROOT_DIR /appl/matlab/2017b )
    endif()
    find_package( Matlab ${VERSION_MATLAB} COMPONENTS MX_LIBRARY MAIN_PROGRAM )

    if( MATLAB_FOUND )
        message( STATUS "MATLAB Found, MATLAB MEX will be compiled." )
        # message( STATUS ${Matlab_LIBRARIES} )
    else()
        message( FATAL_ERROR "MATLAB not found...nothing will be built." )
    endif()



    # MATLAB version dependent definitions
    if( UNIX )
        matlab_get_version_from_matlab_run( ${Matlab_MAIN_PROGRAM} matlab_version )
        if( $ENV{USER} STREQUAL "emartna" )
            # These switches could not be set (redhat 6.10, gcc 4.4.7)
            set( CMAKE_CXX_FLAGS -std=gnu++0x )
            set( CMAKE_C_FLAGS -fPIC )
        endif()
    else()
        set( matlab_version ${VERSION_MATLAB} )
    endif()

    # set up matlab libraries
    include_directories( ${Matlab_INCLUDE_DIRS} )

    # MEX function (MATLAB)
    matlab_add_mex( NAME ${PROJECT_NAME} SRC src/rainflow.c OUTPUT_NAME rfc )
    target_compile_definitions( ${PROJECT_NAME} PRIVATE MATLAB_MEX_FILE _SCL_SECURE_NO_WARNINGS )
    target_link_libraries( ${PROJECT_NAME} ${Matlab_LIBRARIES} ${LIBM_LIBRARY} )
    # install to /bin by default
    install( TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin LIBRARY DESTINATION bin )
endif()

# Static rainflow library
add_library( rfc STATIC src/rainflow.c )
target_link_libraries( rfc ${LIBM_LIBRARY} )

# Test application, start project for MSVC
if( RFC_TEST )
    add_executable( rfc_test src/rainflow.c test/rfc_test.c test/rfc_wrapper_simple.cpp test/rfc_wrapper_advanced.cpp )
    target_compile_definitions( rfc_test PRIVATE _SCL_SECURE_NO_WARNINGS GREATEST_VA_ARGS )
    target_link_libraries( rfc_test ${LIBM_LIBRARY} )
    target_sources( rfc_test PUBLIC greatest/greatest.h )
    set_property( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT rfc_test )

    # install to /bin by default
    install( TARGETS rfc_test RUNTIME DESTINATION bin LIBRARY DESTINATION bin )
    install( FILES test/long_series.csv test/long_series.c matlab/validate.m DESTINATION bin )
endif()

# Update sources for Python module
if( CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR )
    add_custom_command( TARGET rfc
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/src/rainflow.h ${CMAKE_SOURCE_DIR}/python/src/
                        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/src/rainflow.c ${CMAKE_SOURCE_DIR}/python/src/
                        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/src/rainflow.hpp ${CMAKE_SOURCE_DIR}/python/src/
                        COMMENT "Copy sources to python submodule" )
endif()


# CPack
include( InstallRequiredSystemLibraries )

set( CPACK_GENERATOR TGZ ZIP )
set( CPACK_SOURCE_GENERATOR TGZ ZIP )
set( CPACK_PACKAGE_DIRECTORY ${CMAKE_BINARY_DIR}/package )
set( CPACK_PACKAGE_VERSION_MAJOR ${RFC_VERSION_MAJOR} )
set( CPACK_PACKAGE_VERSION_MINOR ${RFC_VERSION_MINOR} )
set( CPACK_PACKAGE_VERSION_PATCH "" )
set( CPACK_PACKAGE_VERSION ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR} )
set( CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "Fast rainflow counting written in C (C99)" )
set( CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE" )
set( CPACK_SOURCE_IGNORE_FILES 
     # Files specific to version control.
     "/\\\\.git/"
     "/\\\\.gitattributes$"
     "/\\\\.github/"
     "/\\\\.gitignore$"
     "/\\\\.hooks-config$"

     # Package build.
     "/build"
     "/.git*"

     # Temporary files.
     "\\\\.#"
     "/#"
     "~$"
    )
set( CPACK_STRIP_FILES TRUE )
set( CPACK_SOURCE_STRIP_FILES TRUE )

include( CPack )
