#[========================================================================[.rst:
FindOvsrproCppZmq
=================

Finds the C++ ZeroMQ library installed as part of Ovsrpro.

Interface Targets
-----------------

This module provides the interface target ``cppzmq::cppzmq``. The C++ ZeroMQ
library is a header only wrapper around ZeroMQ.

Result Variables
----------------

This module defines the following variables:

``OvsrproCppZmq_FOUND``
  True if the Ovsrpro C++ ZeroMQ library is found.
``OvsrproCppZmq_INCLUDE_DIR``
  The path to the C++ ZeroMQ header files.
``OvsrproCppZmq_VERSION``
  The version of C++ ZeroMQ that was found.
#]========================================================================]

if(TARGET cppzmq::cppzmq)
  return()
endif()

if(OvsrproCppZmq_FIND_REQUIRED)
  set(required "REQUIRED")
endif()
if(OvsrproCppZmq_FIND_QUIETLY)
  set(quiet "QUIET")
endif()
find_package(OvsrproZeroMq ${required} ${quiet})

find_path(
  OvsrproCppZmq_INCLUDE_DIR
  NAMES zmq.hpp
  PATHS "${ovsrpro_INCLUDE_DIR}/cppzmq"
  DOC "The location of the C++ ZeroMQ header files."
)
mark_as_advanced(OvsrproCppZmq_INCLUDE_DIR)

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproCppZmq_VERSION "4.2.1")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproCppZmq
  REQUIRED_VARS OvsrproCppZmq_INCLUDE_DIR
  VERSION_VAR OvsrproCppZmq_VERSION
)

if(OvsrproCppZmq_FOUND)
  add_library(cppzmq INTERFACE)
  add_library(cppzmq::cppzmq ALIAS cppzmq)
  target_include_directories(cppzmq SYSTEM INTERFACE "${header_path}")
endif()
