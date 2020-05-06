#[========================================================================[.rst:
FindOvsrproZooKeeper
====================

Finds the ZooKeeper library installed as part of Ovsrpro.

Possible Components
-------------------

The components can be specified in ``find_package()``:

``multithreaded``
  The multi-threaded version of the ZooKeeper C API.
``singlethreaded``
  The single threaded version of the ZooKeeper C API.

If no components are specified, both are found.

Imported Targets
----------------

This module provides the imported targets ``zookeeper::mt`` and
``zookeeper::st``. These correspond to the ``multithreaded`` and
``singlethreaded`` components, respectively.

Result Variables
----------------

This module defines the following variables:

``OvsrproZooKeeper_FOUND``
  True if the Ovsrpro ZooKeeper library is found.
``OvsrproZooKeeper_INCLUDE_DIR``
  The path to the ZooKeeper header files.
``OvsrproZooKeeper_VERSION``
  The version of ZooKeeper that was found.
``OvsrproZooKeeper_LIBRARY_RELEASE
  The release build of the library.
``OvsrproZooKeeper_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproZooKeeper_FOUND``.
#]========================================================================]

if(TARGET zookeeper::zookeeper)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproZooKeeper_VERSION 3.4.13)

find_path(
  OvsrproZooKeeper_INCLUDE_DIR
  NAMES zookeeper.h
  PATHS "${ovsrpro_INCLUDE_DIR}/zookeeper"
  DOC "The location of the ZooKeeper headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproZooKeeper_INCLUDE_DIR)

if(NOT OvsrproZooKeeper_FIND_COMPONENTS)
  set(OvsrproZooKeeper_FIND_COMPONENTS multithreaded singlethreaded)
endif()
foreach(component IN LISTS OvsrproZooKeeper_FIND_COMPONENTS)
  if(component STREQUAL multithreaded)
    set(library_suffix "mt")
  elseif(component STREQUAL singlethreaded)
    set(library_suffix "st")
  endif()
  find_library(
    OvsrproZooKeeper_LIBRARY_${component}_RELEASE
    NAME zookeeper_${library_suffix}
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The release build of the ZooKeeper ${component} library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(OvsrproZooKeeper_LIBRARY_${component}_RELEASE)
  if(OvsrproZooKeeper_LIBRARY_${component}_RELEASE)
    set(OvsrproZooKeeper_${component}_FOUND true)
  else()
    set(OvsrproZooKeeper_${component}_FOUND false)
  endif()
  find_library(
    OvsrproZooKeeper_LIBRARY_${component}_DEBUG
    NAME zookeeper_${library_suffix}
    PATHS "${ovsrpro_LIBRARY_DIR}/zookeeperDebug"
    DOC "The debug build of the ZooKeeper ${component} library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(OvsrproZooKeeper_LIBRARY_${component}_DEBUG)
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproZooKeeper
  REQUIRED_VARS
    OvsrproZooKeeper_INCLUDE_DIR
  VERSION_VAR OvsrproZooKeeper_VERSION
  HANDLE_COMPONENTS
)

if(OvsrproZooKeeper_FOUND)
  foreach(component IN LISTS ${OvsrproZooKeeper_FIND_COMPONENTS})
    if(NOT TARGET zookeeper::${component})
      add_library(zookeeper::${component} IMPORTED UNKNOWN)
      set_target_properties(
        zookeeper::${component}
        PROPERTIES
          INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproZooKeeper_INCLUDE_DIR}"
          IMPORTED_LOCATION "${OvsrproZooKeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_RELEASE "${OvsrproZooKeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_MINSIZEREL "${OvsrproZooKeeper_LIBRARY_${component}_RELEASE}"
          IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
      )
      if(OvsrproZooKeeper_LIBRARY_DEBUG)
        set_target_properties(
          zookeeper::${component}
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${OvsrproZooKeeper_LIBRARY_${component}_DEBUG}"
            IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproZooKeeper_LIBRARY_${component}_DEBUG}"
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
