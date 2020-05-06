#[========================================================================[.rst:
Findlibzmq
==========

Finds the ZeroMQ library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``libzmq::libzmq``.

Result Variables
----------------

This module defines the following variables:

``libzmq_FOUND``
  True if the Ovsrpro ZeroMQ library is found.
``libzmq_INCLUDE_DIR``
  The path to the ZeroMQ header files.
``libzmq_VERSION``
  The version of ZeroMQ that was found.
``libzmq_LIBRARY_RELEASE
  The release build of the library.
``libzmq_LIBRARY_DEBUG``
  The debug build of the library. This variable may be ``-NOTFOUND`` without
  affecting ``libzmq_FOUND``.
#]========================================================================]

if(TARGET libzmq::libzmq)
  return()
endif()

# TODO Replace this with the version variable, so it can be configured.
set(libzmq_VERSION "4.2.3")

find_path(
  libzmq_INCLUDE_DIR
  NAMES zmq.h
  PATHS "${ovsrpro_INCLUDE_DIR}/zeromq"
  DOC "The location of the ZeroMQ headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(libzmq_INCLUDE_DIR)

find_library(
  libzmq_LIBRARY_RELEASE
  NAME zmq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the ZeroMQ library."
  NO_DEFAULT_PATH
)
mark_as_advanced(libzmq_LIBRARY_RELEASE)

find_library(
  libzmq_LIBRARY_DEBUG
  NAME zmq
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The debug build of the ZeroMQ library."
  NO_DEFAULT_PATH
)
mark_as_advanced(libzmq_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  libzmq
  REQUIRED_VARS
    libzmq_INCLUDE_DIR
    libzmq_LIBRARY_RELEASE
  VERSION_VAR libzmq_VERSION
)

if(libzmq_FOUND)
  add_library(libzmq::libzmq IMPORTED UNKNOWN)
  set_target_properties(
    libzmq::libzmq
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${libzmq_INCLUDE_DIR}"
      IMPORTED_LOCATION "${libzmq_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${libzmq_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${libzmq_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
  if(libzmq_LIBRARY_DEBUG)
    set_target_properties(
      libzmq::libzmq
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${libzmq_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_MINSIZEREL "${libzmq_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${libzmq_LIBRARY_DEBUG}"
    )
    set_property(
      TARGET libzmq::libzmq
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
    )
  endif()
endif()