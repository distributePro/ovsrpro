#[========================================================================[.rst:
FindOvsrproNovas
================

Finds the NOVAS library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``novas::novas``.

Result Variables
----------------

This module defines the following variables:

``OvsrproNovas_FOUND``
  True if the Ovsrpro NOVAS library is found.
``OvsrproNovas_INCLUDE_DIR``
  The path to the NOVAS header files.
``OvsrproNovas_VERSION``
  The version of NOVAS that was found.
``OvsrproNovas_LIBRARY_RELEASE
  The release build of the library.
``OvsrproNovas_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproNovas_FOUND``.
#]========================================================================]

if(TARGET novas::novas)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproNovas_VERSION 3.1)

find_path(
  OvsrproNovas_INCLUDE_DIR
  NAMES novas.h
  PATHS "${ovsrpro_INCLUDE_DIR}/novas"
  DOC "The location of the NOVAS headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproNovas_INCLUDE_DIR)

find_library(
  OvsrproNovas_LIBRARY_RELEASE
  NAME novas
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the NOVAS library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproNovas_LIBRARY_RELEASE)

find_library(
  OvsrproNovas_LIBRARY_DEBUG
  NAME novasd
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The debug build of the NOVAS library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproNovas_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproNovas
  REQUIRED_VARS
    OvsrproNovas_INCLUDE_DIR
    OvsrproNovas_LIBRARY_RELEASE
  VERSION_VAR OvsrproNovas_VERSION
)

if(OvsrproNovas_FOUND)
  add_library(novas::novas IMPORTED UNKNOWN)
  set_target_properties(
    novas::novas
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproNovas_INCLUDE_DIR}"
      IMPORTED_LOCATION "${OvsrproNovas_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${OvsrproNovas_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${OvsrproNovas_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(OvsrproNovas_LIBRARY_DEBUG)
    set_target_properties(
      novas::novas
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${OvsrproNovas_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproNovas_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET novas::novas
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()
