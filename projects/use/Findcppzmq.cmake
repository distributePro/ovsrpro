# Copyright Utah State University Research Foundation.
# All rights reserved except as specified below.
# This information is protected by a Non-Disclosure/Government Purpose
# License Agreement and is authorized only for United States Federal
# Government use.
# This information may be subject to export control.

#[=[.rst
Findcppzmq
----------

Find the ZeroMQ C++ header-only library in the ovsrpro meta-package.
Before using this package, you must find ovsrpro, then add ovsrpro to the ``CMAKE_MODULE_PATH``.

.. code-block:: cmake

  set(ovsrpro_REV 21.09)
  find_package(ovsrpro)
  list(APPEND CMAKE_MODULE_PATH "${ovsrpro_DIR}/share/cmake")

Then, just use ``find_package()`` and ``target_link_libraries()``.

.. code-block:: cmake

  find_package(cppzmq)
  
  # Define your target as normal.
  target_link_libraries(YourTarget PRIVATE ZeroMQ::cppzmq)

Target
^^^^^^

This module defines the ``ZeroMQ::cppzmq`` imported target.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

.. variable:: cppzmq_FOUND

  True if cppzmq is found, false if it is not.

.. variable:: cppzmq_VERSION

  The version of the cppzmq found.
  This version is fixed at the time ovsrpro is built.

.. variable:: cppzmq_INCLUDE_DIR

  The path to the cppzmq header files in the ovsrpro meta-package.

.. variable:: cppzmq_LIBRARY_RELEASE

  The path to the the release build of cppzmq library in the ovsrpro meta-package.
  This will be a static library.

.. variable:: cppzmq_LIBRARY_DEBUG

  The path to the debug build of the cppzmq library in the ovsrpro meta-package.
  This will be a static library.
  The status of the debug library does not effect ``cppzmq_FOUND``; the debug library is always optional.
#]=]

set(cppzmq_VERSION @CPPZMQ_VER@)

# Note: This is a Find module, not a configuration file. So, FindDependency
# won't work correctly and we must manually invoke find_package().
find_package(ZeroMQ @ZEROMQ_VERSION@ EXACT)

find_path(
  cppzmq_INCLUDE_DIR
  zmq.hpp
  PATHS "${ovsrpro_DIR}/include/cppzmq"
  NO_DEFAULT_PATH
  DOC "The path to the cppzmq header files."
)
mark_as_advanced(cppzmq_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  cppzmq
  REQUIRED_VARS
    cppzmq_INCLUDE_DIR
    ZeroMQ_FOUND
  VERSION_VAR cppzmq_VERSION
)

if(cppzmq_FOUND)
  add_library(ZeroMQ::cppzmq INTERFACE IMPORTED)
  set_target_properties(
    ZeroMQ::cppzmq
    PROPERTIES
      IMPORTED_CONFIGURATIONS "Release;MinSizeRel;Debug;DebWithRelInfo"
      INTERFACE_INCLUDE_DIRECTORIES "${cppzmq_INCLUDE_DIR}"
  )
endif()
