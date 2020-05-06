#[========================================================================[.rst:
Findlibrdkafka
==============

Finds the librdkafka library installed as part of Ovsrpro.

Imported Targets
----------------

This module provides these imported targets

``librdkafka::C``
  The C version of librdkafka.
``librdkafka::CPP``
  The C++ version of librdkafka.

Result Variables
----------------

This module defines the following variables:

``librdkafka_FOUND``
  True if the Ovsrpro librdkafka library is found.
``librdkafka_INCLUDE_DIR``
  The path to the librdkafka header files.
``librdkafka_VERSION``
  The version of librdkafka that was found.
``librdkafka_LIBRARY_C_RELEASE
  The release build of the C library.
``librdkafka_LIBRARY_C_DEBUG``
  The debug build of the C library. This variable may be ``-NOTFOUND`` without
  affecting ``librdkafka_FOUND``.
``librdkafka_LIBRARY_CXX_RELEASE
  The release build of the C++ library.
``librdkafka_LIBRARY_CXX_DEBUG``
  The debug build of the C++ library. This variable may be ``-NOTFOUND`` without
  affecting ``librdkafka_FOUND``.
#]========================================================================]

# TODO Replace this with the version variable, so it can be configured.
set(librdkafka_VERSION "0.9.5")

find_path(
  librdkafka_INCLUDE_DIR
  NAMES rdkafka.h
  PATHS "${ovsrpro_INCLUDE_DIR}/librdkafka"
  DOC "The location of the librdkafka headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(librdkafka_INCLUDE_DIR)

find_library(
  librdkafka_C_RELEASE_LIBRARY
  NAMES rdkafka
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(librdkafka_C_RELEASE_LIBRARY)

find_library(
  librdkafka_C_DEBUG_LIBRARY
  NAMES rdkafka-d
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(librdkafka_C_DEBUG_LIBRARY)

find_library(
  librdkafka_CXX_RELEASE_LIBRARY
  NAMES rdkafka++
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(librdkafka_CXX_RELEASE_LIBRARY)

find_library(
  librdkafka_CXX_DEBUG_LIBRARY
  NAMES rdkafka++-d
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(librdkafka_CXX_DEBUG_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  librdkafka
  REQUIRED_VARS
    librdkafka_INCLUDE_DIR
    librdkafka_C_RELEASE_LIBRARY
    librdkafka_CXX_RELEASE_LIBRARY
  VERSION_VAR librdkafka_VERSION
)

if(librdkafka_FOUND)
  if(NOT TARGET librdkafka::C)
    add_library(librdkafka::C IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::C
      PROPERTIES
        IMPORTED_LOCATION "${librdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${librdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${librdkafka_C_RELEASE_LIBRARY}"
        INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${librdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
    )
    if(librdkafka_C_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::C
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${librdkafka_C_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${librdkafka_C_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::C
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
  if(NOT TARGET librdkafka::CPP)
    add_library(librdkafka::CPP IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::CPP
      PROPERTIES
        IMPORTED_LOCATION "${librdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${librdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${librdkafka_CXX_RELEASE_LIBRARY}"
        INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${librdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
    )
    if(librdkafka_CXX_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::CPP
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${librdkafka_CXX_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${librdkafka_CXX_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::CPP
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
endif()