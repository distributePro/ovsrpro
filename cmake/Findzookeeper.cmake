#[========================================================================[.rst:
Findzookeeper
=============

Finds the ZooKeeper library installed as part of Ovsrpro.

Possible Components
-------------------

The components can be specified in ``find_package()``:

``multithreaded``
  The multi-threaded version of the ZooKeeper C API.
``singlethreaded``
  The single threaded version of the ZooKeeper C API.

If no components are specified, both are searched for.

Imported Targets
----------------

This module provides the imported targets ``zookeeper::mt`` and
``zookeeper::st``. These correspond to the ``multithreaded`` and
``singlethreaded`` components, respectively.

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

set(zookeeper_VERSION @ZOOKEEPER_VERSION@)

find_path(
  zookeeper_INCLUDE_DIR
  NAMES zookeeper.h
  PATHS "${ovsrpro_INCLUDE_DIR}/zookeeper"
  DOC "The location of the ZooKeeper headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(zookeeper_INCLUDE_DIR)

if(NOT zookeeper_FIND_COMPONENTS)
  set(zookeeper_FIND_COMPONENTS multithreaded singlethreaded)
endif()
foreach(component IN LISTS zookeeper_FIND_COMPONENTS)
  if(component STREQUAL multithreaded)
    set(library_suffix "mt")
  elseif(component STREQUAL singlethreaded)
    set(library_suffix "st")
  endif()
  find_library(
    zookeeper_LIBRARY_${component}_RELEASE
    NAME zookeeper_${library_suffix}
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The release build of the ZooKeeper ${component} library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(zookeeper_LIBRARY_${component}_RELEASE)
  if(zookeeper_LIBRARY_${component}_RELEASE)
    set(zookeeper_${component}_FOUND true)
  else()
    set(zookeeper_${component}_FOUND false)
  endif()
  find_library(
    zookeeper_LIBRARY_${component}_DEBUG
    NAME zookeeper_${library_suffix}
    PATHS "${ovsrpro_LIBRARY_DIR}/zookeeperDebug"
    DOC "The debug build of the ZooKeeper ${component} library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(zookeeper_LIBRARY_${component}_DEBUG)
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  zookeeper
  REQUIRED_VARS
    zookeeper_INCLUDE_DIR
  VERSION_VAR zookeeper_VERSION
  HANDLE_COMPONENTS
)

if(zookeeper_FOUND)
  foreach(component IN LISTS zookeeper_FIND_COMPONENTS)
    if(NOT TARGET zookeeper::${component})
      add_library(zookeeper::${component} IMPORTED UNKNOWN)
      set_target_properties(
        zookeeper::${component}
        PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${zookeeper_INCLUDE_DIR}"
          IMPORTED_LOCATION "${zookeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_RELEASE "${zookeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_MINSIZEREL "${zookeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
      )
      if(zookeeper_LIBRARY_DEBUG)
        set_target_properties(
          zookeeper::${component}
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${zookeeper_LIBRARY_${component}_DEBUG}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${zookeeper_LIBRARY_${component}_DEBUG}"
        )
        set_property(
          TARGET zookeeper::${component}
          APPEND
          PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
        )
      endif()
    endif()
  endforeach()
endif()
