#[========================================================================[.rst:
Findcppzmq
==========

Finds the C++ ZeroMQ library installed as part of Ovsrpro.

Interface Targets
-----------------

This module provides the interface target ``cppzmq::cppzmq``. The C++ ZeroMQ
library is a header only wrapper around ZeroMQ.

Result Variables
----------------

This module defines the following variables:

``cppzmq_FOUND``
  True if the Ovsrpro C++ ZeroMQ library is found.
``cppzmq_INCLUDE_DIR``
  The path to the C++ ZeroMQ header files.
``cppzmq_VERSION``
  The version of C++ ZeroMQ that was found.
#]========================================================================]

if(TARGET cppzmq::cppzmq)
  return()
endif()

if(cppzmq_FIND_REQUIRED)
  set(required "REQUIRED")
endif()
if(cppzmq_FIND_QUIETLY)
  set(quiet "QUIET")
endif()
find_package(libzmq ${required} ${quiet})

find_path(
  cppzmq_INCLUDE_DIR
  NAMES zmq.hpp
  PATHS "${ovsrpro_INCLUDE_DIR}/cppzmq"
  DOC "The location of the C++ ZeroMQ header files."
)
mark_as_advanced(cppzmq_INCLUDE_DIR)

# TODO Replace this with the version variable, so it can be configured.
set(cppzmq_VERSION "4.2.1")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  cppzmq
  REQUIRED_VARS cppzmq_INCLUDE_DIR
  VERSION_VAR cppzmq_VERSION
)

if(cppzmq_FOUND)
  add_library(cppzmq::cppzmq IMPORTED UNKNOWN)
  set_target_properties(
    cppzmq::cppzmq
    PROPERTIES
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${cppzmq_INCLUDE_DIR}"
  )
endif()
