#[========================================================================[.rst:
Findpsql
========

Finds the psql library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``psql::psql``.

Result Variables
----------------

This module defines the following variables:

``psql_FOUND``
  True if the Ovsrpro psql library is found.
``psql_INCLUDE_DIR``
  The path to the psql header files.
``psql_VERSION``
  The version of psql that was found.
``psql_LIBRARY_RELEASE
  The release build of the library.
``psql_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``psql_FOUND``.
#]========================================================================]

if(TARGET psql::psql)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(psql_VERSION 9.6.10)

find_path(
  psql_INCLUDE_DIR
  NAMES sql3types.h
  PATHS "${ovsrpro_INCLUDE_DIR}/psql"
  DOC "The location of the psql headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(psql_INCLUDE_DIR)

find_library(
  psql_LIBRARY_RELEASE
  NAME pq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the psql library."
  NO_DEFAULT_PATH
)
mark_as_advanced(psql_LIBRARY_RELEASE)

find_library(
  psql_LIBRARY_DEBUG
  NAME pq
  PATHS "${ovsrpro_LIBRARY_DIR}/psqldebug"
  DOC "The debug build of the psql library."
  NO_DEFAULT_PATH
)
mark_as_advanced(psql_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  psql
  REQUIRED_VARS
    psql_INCLUDE_DIR
    psql_LIBRARY_RELEASE
  VERSION_VAR psql_VERSION
)

if(psql_FOUND)
  add_library(psql::psql IMPORTED UNKNOWN)
  set_target_properties(
    psql::psql
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${psql_INCLUDE_DIR}"
      IMPORTED_LOCATION "${psql_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${psql_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${psql_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(psql_LIBRARY_DEBUG)
    set_target_properties(
      psql::psql
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${psql_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${psql_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET psql::psql
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()
