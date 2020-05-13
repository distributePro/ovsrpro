#[========================================================================[.rst:
FindNOVAS
=========

Finds the NOVAS library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``NOVAS::NOVAS``.

Result Variables
----------------

This module defines the following variables:

``NOVAS_FOUND``
  True if the  NOVAS library is found.
``NOVAS_INCLUDE_DIR``
  The path to the NOVAS header files.
``NOVAS_VERSION``
  The version of NOVAS that was found.
``NOVAS_LIBRARY_RELEASE
  The release build of the library.
``NOVAS_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``NOVAS_FOUND``.
#]========================================================================]

if(TARGET NOVAS::NOVAS)
  return()
endif()

set(NOVAS_VERSION @NOVAS_VERSION@)

find_path(
  NOVAS_INCLUDE_DIR
  NAMES novas.h
  PATHS "${ovsrpro_INCLUDE_DIR}/novas"
  DOC "The location of the NOVAS headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(NOVAS_INCLUDE_DIR)

find_library(
  NOVAS_LIBRARY_RELEASE
  NAME novas
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the NOVAS library."
  NO_DEFAULT_PATH
)
mark_as_advanced(NOVAS_LIBRARY_RELEASE)

find_library(
  NOVAS_LIBRARY_DEBUG
  NAME novasd
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The debug build of the NOVAS library."
  NO_DEFAULT_PATH
)
mark_as_advanced(NOVAS_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  NOVAS
  REQUIRED_VARS
    NOVAS_INCLUDE_DIR
    NOVAS_LIBRARY_RELEASE
  VERSION_VAR NOVAS_VERSION
)

if(NOVAS_FOUND)
  add_library(NOVAS::NOVAS IMPORTED UNKNOWN)
  set_target_properties(
    NOVAS::NOVAS
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${NOVAS_INCLUDE_DIR}"
      IMPORTED_LOCATION "${NOVAS_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${NOVAS_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${NOVAS_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(NOVAS_LIBRARY_DEBUG)
    set_target_properties(
      NOVAS::NOVAS
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${NOVAS_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${NOVAS_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET NOVAS::NOVAS
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()
