#[========================================================================[.rst:
FindOvsrproPsql
===============

Finds the PSQL library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``psql::psql``.

Result Variables
----------------

This module defines the following variables:

``OvsrproPsql_FOUND``
  True if the Ovsrpro PSQL library is found.
``OvsrproPsql_INCLUDE_DIR``
  The path to the PSQL header files.
``OvsrproPsql_VERSION``
  The version of PSQL that was found.
``OvsrproPsql_LIBRARY_RELEASE
  The release build of the library.
``OvsrproPsql_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproPsql_FOUND``.
#]========================================================================]

if(TARGET psql::psql)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproPsql_VERSION 9.6.10)

find_path(
  OvsrproPsql_INCLUDE_DIR
  NAMES sql3types.h
  PATHS "${ovsrpro_INCLUDE_DIR}/psql"
  DOC "The location of the PSQL headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproPsql_INCLUDE_DIR)

find_library(
  OvsrproPsql_LIBRARY_RELEASE
  NAME pq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the PSQL library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproPsql_LIBRARY_RELEASE)

find_library(
  OvsrproPsql_LIBRARY_DEBUG
  NAME pq
  PATHS "${ovsrpro_LIBRARY_DIR}/psqldebug"
  DOC "The debug build of the PSQL library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproPsql_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproPsql
  REQUIRED_VARS
    OvsrproPsql_INCLUDE_DIR
    OvsrproPsql_LIBRARY_RELEASE
  VERSION_VAR OvsrproPsql_VERSION
)

if(OvsrproPsql_FOUND)
  add_library(psql::psql IMPORTED UNKNOWN)
  set_target_properties(
    psql::psql
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproPsql_INCLUDE_DIR}"
      IMPORTED_LOCATION "${OvsrproPsql_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${OvsrproPsql_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${OvsrproPsql_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(OvsrproPsql_LIBRARY_DEBUG)
    set_target_properties(
      psql::psql
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${OvsrproPsql_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproPsql_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET psql::psql
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()
