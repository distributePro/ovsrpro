# Copyright Utah State University Research Foundation.
# All rights reserved except as specified below.
# This information is protected by a Non-Disclosure/Government Purpose
# License Agreement and is authorized only for United States Federal
# Government use.
# This information may be subject to export control.

#[=[.rst
FindZeroMQ
----------

Find the ZeroMQ C library in the ovsrpro meta-package.
Before using this package, you must find ovsrpro, then add ovsrpro to the ``CMAKE_MODULE_PATH``.

.. code-block:: cmake

  set(ovsrpro_REV 21.09)
  find_package(ovsrpro)
  list(APPEND CMAKE_MODULE_PATH "${ovsrpro_DIR}/share/cmake")

Then, just use ``find_package()`` and ``target_link_libraries()``.

.. code-block:: cmake

  find_package(ZeroMQ)
  
  # Define your target as normal.
  target_link_libraries(YourTarget PRIVATE ZeroMQ::ZeroMQ)

Target
^^^^^^

This module defines the ``ZeroMQ::ZeroMQ`` imported target.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

.. variable:: ZeroMQ_FOUND

  True if ZeroMQ is found, false if it is not.

.. variable:: ZeroMQ_VERSION

  The version of the ZeroMQ found.
  This version is fixed at the time ovsrpro is built.

.. variable:: ZeroMQ_INCLUDE_DIR

  The path to the ZeroMQ header files in the ovsrpro meta-package.

.. variable:: ZeroMQ_LIBRARY_RELEASE

  The path to the the release build of ZeroMQ library in the ovsrpro meta-package.
  This will be a static library.

.. variable:: ZeroMQ_LIBRARY_DEBUG

  The path to the debug build of the ZeroMQ library in the ovsrpro meta-package.
  This will be a static library.
  The status of the debug library does not effect ``ZeroMQ_FOUND``; the debug library is always optional.
#]=]

set(ZeroMQ_VERSION @ZEROMQ_VERSION@)

find_path(
  ZeroMQ_INCLUDE_DIR
  zmq.h
  PATHS "${ovsrpro_DIR}/include/zeromq"
  NO_DEFAULT_PATH
  DOC "The path to the ZeroMQ header files."
)
mark_as_advanced(ZeroMQ_INCLUDE_DIR)

find_library(
  ZeroMQ_LIBRARY_RELEASE
  libzmq.a
  PATHS "${ovsrpro_DIR}/lib"
  NO_DEFAULT_PATH
  DOC "The full path to the ZeroMQ release-build library."
)
mark_as_advanced(ZeroMQ_LIBRARY_RELEASE)

find_library(
  ZeroMQ_LIBRARY_DEBUG
  libzmq-d.a
  PATHS "${ovsrpro_DIR}/lib"
  NO_DEFAULT_PATH
  DOC "The full path to the ZeroMQ debug-build library."
)
mark_as_advanced(ZeroMQ_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  ZeroMQ
  REQUIRED_VARS
    ZeroMQ_INCLUDE_DIR
    ZeroMQ_LIBRARY_RELEASE
  VERSION_VAR
    ZeroMQ_VERSION
)

if(ZeroMQ_FOUND)
  add_library(ZeroMQ::ZeroMQ STATIC IMPORTED)
  set_target_properties(
    ZeroMQ::ZeroMQ
    PROPERTIES
      IMPORTED_CONFIGURATIONS "Release;MinSizeRel"
      IMPORTED_LOCATION "${ZeroMQ_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${ZeroMQ_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${ZeroMQ_LIBRARY_RELEASE}"
      INTERFACE_INCLUDE_DIRECTORIES "${ZeroMQ_INCLUDE_DIR}"
  )
  if(ZeroMQ_LIBRARY_DEBUG)
    set_property(
      TARGET ZeroMQ::ZeroMQ
      APPEND
      PROPERTY IMPORTED_CONFIGURATIONS "Debug;RelWithDebInfo"
    )
    set_target_properties(
      ZeroMQ::ZeroMQ
      PROPERTIES
        IMPORTED_LOCATION_DEBUG "${ZeroMQ_LIBRARY_DEBUG}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${ZeroMQ_LIBRARY_DEBUG}"
    )
  endif()
endif()
