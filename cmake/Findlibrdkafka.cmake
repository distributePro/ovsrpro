#[========================================================================[.rst:
Findlibrdkafka
==============

Finds the librdkafka library installed as part of Ovsrpro.

Imported Targets
----------------

This module provides these imported targets

``librdkafka::c``
  The C version of librdkafka.
``librdkafka::cpp``
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

set(librdkafka_VERSION @LIBRDKAFKA_VERSION@)

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
  if(NOT TARGET librdkafka::c)
    add_library(librdkafka::c IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::c
      PROPERTIES
        IMPORTED_LOCATION "${librdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${librdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${librdkafka_C_RELEASE_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${librdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
    )
    if(librdkafka_C_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::c
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${librdkafka_C_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${librdkafka_C_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::c
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
  if(NOT TARGET librdkafka::cpp)
    add_library(librdkafka::cpp IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::cpp
      PROPERTIES
        IMPORTED_LOCATION "${librdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${librdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${librdkafka_CXX_RELEASE_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${librdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
        IMPORTED_LINK_INTERFACE_LIBRARIES librdkafka::c
    )
    if(librdkafka_CXX_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::cpp
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${librdkafka_CXX_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${librdkafka_CXX_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::cpp
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
endif()
