#[========================================================================[.rst:
FindOvsrproZeroMq
=================

Finds the ZeroMQ library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``zeromq::zeromq``.

Result Variables
----------------

This module defines the following variables:

``OvsrproZeroMq_FOUND``
  True if the Ovsrpro ZeroMQ library is found.
``OvsrproZeroMq_INCLUDE_DIR``
  The path to the ZeroMQ header files.
``OvsrproZeroMq_VERSION``
  The version of ZeroMQ that was found.
``OvsrproZeroMq_LIBRARY_RELEASE
  The release build of the library.
``OvsrproZeroMq_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproZeroMq_FOUND``.
#]========================================================================]

if(TARGET zeromq::zeromq)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproZeroMq_VERSION "4.2.3")

find_path(
  OvsrproZeroMQ_INCLUDE_DIR
  NAMES zmq.h
  PATHS "${ovsrpro_INCLUDE_DIR}/zeromq"
  DOC "The location of the ZeroMQ headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(Ovsrpro_INCLUDE_DIR)

find_library(
  OvsrproZeroMq_LIBRARY_RELEASE
  NAME zmq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the ZeroMQ library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproZeroMq_LIBRARY_RELEASE)

find_library(
  OvsrproZeroMq_LIBRARY_DEBUG
  NAME zmq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The debug build of the ZeroMQ library."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproZeroMq_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproZeroMQ
  REQUIRED_VARS
    OvsrproZeroMQ_INCLUDE_DIR
    OvsrproZeroMq_LIBRARY_RELEASE
  VERSION_VAR OvsrproZeroMq_VERSION
)

if(OvsrproZeroMq_FOUND)
  add_library(zeromq::zeromq IMPORTED UNKNOWN)
  set_target_properties(
    zeromq::zeromq
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproZerMq_INCLUDE_DIR}"
      IMPORTED_LOCATION "${OvsrproZeroMq_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${OvsrproZeroMq_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${OvsrproZeroMq_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(OvsrproZeroMq_LIBRARY_DEBUG)
    set_target_properties(
      zeromq::zeromq
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${OvsrproZeroMq_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_MINSIZEREL "${OvsrproZeroMq_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproZeroMq_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET zeromq::zeromq
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()