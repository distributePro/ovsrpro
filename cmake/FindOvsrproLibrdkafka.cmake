#[========================================================================[.rst:
FindOvsrproLibrdkafka
=====================

Finds the librdkafka library installed as part of Ovsrpro.

Imported Targets
----------------

This module provides these imported targets

``librdkafka::c``
  The C version of librdkafka.
``librdkafka::cxx``
  The C++ version of librdkafka.

Result Variables
----------------

This module defines the following variables:

``OvsrproLibrdkafka_FOUND``
  True if the Ovsrpro librdkafka library is found.
``OvsrproLibrdkafka_INCLUDE_DIR``
  The path to the librdkafka header files.
``OvsrproLibrdkafka_VERSION``
  The version of librdkafka that was found.
``OvsrproLibrdkafka_LIBRARY_C_RELEASE
  The release build of the C library.
``OvsrproLibrdkafka_LIBRARY_C_DEBUG``
  The debug build of the C library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproLibrdkafka_FOUND``.
``OvsrproLibrdkafka_LIBRARY_CXX_RELEASE
  The release build of the C++ library.
``OvsrproLibrdkafka_LIBRARY_CXX_DEBUG``
  The debug build of the C++ library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproLibrdkafka_FOUND``.
#]========================================================================]

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproLibrdkafka_VERSION "0.9.5")

find_path(
  OvsrproLibrdkafka_INCLUDE_DIR
  NAMES rdkafka.h
  PATHS "${ovsrpro_INCLUDE_DIR}/librdkafka"
  DOC "The location of the librdkafka headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproLibrdkafka_INCLUDE_DIR)

find_library(
  OvsrproLibrdkafka_C_RELEASE_LIBRARY
  NAMES rdkafka
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproLibrdkafka_C_RELEASE_LIBRARY)

find_library(
  OvsrproLibrdkafka_C_DEBUG_LIBRARY
  NAMES rdkafka-d
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproLibrdkafka_C_DEBUG_LIBRARY)

find_library(
  OvsrproLibrdkafka_CXX_RELEASE_LIBRARY
  NAMES rdkafka++
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproLibrdkafka_CXX_RELEASE_LIBRARY)

find_library(
  OvsrproLibrdkafka_CXX_DEBUG_LIBRARY
  NAMES rdkafka++-d
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproLibrdkafka_CXX_DEBUG_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproLibrdkafka
  REQUIRED_VARS
    OvsrproLibrdkafka_INCLUDE_DIR
    OvsrproLibrdkafka_C_RELEASE_LIBRARY
    OvsrproLibrdkafka_CXX_RELEASE_LIBRARY
  VERSION_VAR OvsrproLibrdkafka_VERSION
)

if(OvsrproLibrdkafka_FOUND)
  if(NOT TARGET librdkafka::c)
    add_library(librdkafka::c IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::c
      PROPERTIES
        IMPORTED_LOCATION "${OvsrproLibrdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${OvsrproLibrdkafka_C_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${OvsrproLibrdkafka_C_RELEASE_LIBRARY}"
        INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproLibrdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
    )
    if(OvsrproLibrdkafka_C_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::c
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${OvsrproLibrdkafka_C_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproLibrdkafka_C_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::c
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
  if(NOT TARGET librdkafka::cxx)
    add_library(librdkafka::cxx IMPORTED UNKNOWN)
    set_target_properties(
      librdkafka::cxx
      PROPERTIES
        IMPORTED_LOCATION "${OvsrproLibrdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_RELEASE "${OvsrproLibrdkafka_CXX_RELEASE_LIBRARY}"
        IMPORTED_LOCATION_MINSIZEREL "${OvsrproLibrdkafka_CXX_RELEASE_LIBRARY}"
        INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproLibrdkafka_INCLUDE_DIR}"
        IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
    )
    if(OvsrproLibrdkafka_CXX_DEBUG_LIBRARY)
      set_target_properties(
        librdkafka::cxx
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${OvsrproLibrdkafka_CXX_DEBUG_LIBRARY}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproLibrdkafka_CXX_DEBUG_LIBRARY}"
      )
      set_property(
        TARGET librdkafka::cxx
        APPEND
        PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
      )
    endif()
  endif()
endif()