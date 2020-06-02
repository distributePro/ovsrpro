#[========================================================================[.rst:
Findzookeeper
=============

Finds the ZooKeeper library installed as part of Ovsrpro.

Imported Targets
----------------

This module provides the imported target ``zookeeper::zookeeper``.

Result Variables
----------------

This module defines the following variables:

``zookeeper_FOUND``
  True if the Ovsrpro ZooKeeper library is found.
``zookeeper_INCLUDE_DIR``
  The path to the ZooKeeper header files.
``zookeeper_VERSION``
  The version of ZooKeeper that was found.
``zookeeper_LIBRARY_RELEASE
  The release build of the library.
``zookeeper_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``zookeeper_FOUND``.
#]========================================================================]

if(TARGET zookeeper::zookeeper)
  return()
endif()

set(zookeeper_VERSION @ZOOKEEPER_VERSION@)

find_path(
  zookeeper_INCLUDE_DIR
  NAMES zookeeper.h
  PATHS "${ovsrpro_INCLUDE_DIR}/zookeeper"
  DOC "The location of the ZooKeeper headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(zookeeper_INCLUDE_DIR)

find_library(
  zookeeper_LIBRARY_RELEASE
  NAME zookeeper
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the ZooKeeper library."
  NO_DEFAULT_PATH
)
mark_as_advanced(zookeeper_LIBRARY_RELEASE)

find_library(
  zookeeper_LIBRARY_DEBUG
  NAME zookeeperd
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The debug build of the ZooKeeper library."
  NO_DEFAULT_PATH
)
mark_as_advanced(zookeeper_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  zookeeper
  REQUIRED_VARS
    zookeeper_INCLUDE_DIR
    zookeeper_LIBRARY_RELEASE
  VERSION_VAR zookeeper_VERSION
)

if(zookeeper_FOUND)
  add_library(zookeeper::zookeeper IMPORTED UNKNOWN)
  set_target_properties(
    zookeeper::zookeeper
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${zookeeper_INCLUDE_DIR}"
      IMPORTED_LOCATION "${zookeeper_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${zookeeper_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${zookeeper_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(zookeeper_LIBRARY_DEBUG)
    set_target_properties(
      zookeeper::zookeeper
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${zookeeper_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${zookeeper_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET zookeeper::zookeeper
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()
