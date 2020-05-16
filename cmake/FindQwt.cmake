#[========================================================================[.rst:
FindQwt
=======

Finds the Qwt library installed as part of Ovsrpro.

Imported Target
---------------

This module provides the imported target ``Qwt::Qwt``.

Result Variables
----------------

This module defines the following variables:

``Qwt_FOUND``
  True if the Ovsrpro Qwt library is found.
``Qwt_INCLUDE_DIR``
  The path to the Qwt header files.
``Qwt_VERSION``
  The version of Qwt that was found.
``Qwt_LIBRARY_RELEASE
  The release build of the library.

.. warning::

  This project does not install a debug version of the library.
#]========================================================================]

if(TARGET Qwt::Qwt)
  return()
endif()

set(Qwt_VERSION @QWT_VERSION@)

find_path(
  Qwt_INCLUDE_DIR
  NAMES qwt.h
  PATHS "${ovsrpro_INCLUDE_DIR}/qwt"
  DOC "The location of the Qwt headers."
  NO_DEFAULT_PATH
)
mark_as_advanced(Qwt_INCLUDE_DIR)

find_library(
  Qwt_LIBRARY_RELEASE
  NAME qwt
  PATHS "${ovsrpro_LIBRARY_DIR}"
  DOC "The release build of the Qwt library."
  NO_DEFAULT_PATH
)
mark_as_advanced(Qwt_LIBRARY_RELEASE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  Qwt
  REQUIRED_VARS
    Qwt_INCLUDE_DIR
    Qwt_LIBRARY_RELEASE
  VERSION_VAR Qwt_VERSION
)

if(Qwt_FOUND)
  add_library(Qwt::Qwt IMPORTED UNKNOWN)
  set_target_properties(
    Qwt::Qwt
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Qwt_INCLUDE_DIR}"
      IMPORTED_LOCATION "${Qwt_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_RELEASE "${Qwt_LIBRARY_RELEASE}"
      IMPORTED_LOCATION_MINSIZEREL "${Qwt_LIBRARY_RELEASE}"
      IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
  )
endif()
