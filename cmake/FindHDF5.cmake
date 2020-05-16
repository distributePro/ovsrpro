#[========================================================================[.rst:
FindHDF5
========

Finds the HDF5 library installed as part of Ovsrpro.

Posssible Components
--------------------

The following components can be specified to ``find_package()``:

``C``
  The HDF5 C library.
``CPP``
  The HDF5 C++ library.
``HL``
  The HDF5 High-Level Region C library.
``HL_CPP``
  The HDF5 High-Level Region C++ library.
``Tools``
  The library used by various HDF5 tools.

If no components are specified, this module will import all of them.

Imported Targets
----------------

This module provides two targets that cannot be disabled. They are required for
the HDF5 targets.

``HDF5::szip``
  The SZIP library, built as part of HDF5.
``HDF5::z``
  ZLIB, built as part of HDF5.

This module also provides these imported targets depending on the specified
components:

``HDF5::c``
  The C version of HDF5.
``HDF5::cpp``
  The C++ version of HDF5.
``HDF5::hl``
  The HDF5 High-Level Region C library.
``HDF5::hl_cpp``
  The HDF5 High-Level Region C++ library.
``HDF5::tools``
  The library used by various HDF5 tools.

Result Variables
----------------

This module defines the following variables:

``HDF5_FOUND``
  True if the Ovsrpro HDF5 library is found.
``HDF5_INCLUDE_DIR``
  The path to the HDF5 header files.
``HDF5_VERSION``
  The version of HDF5 that was found.
``HDF5_LIBRARY_C_RELEASE
  The release build of the C library.
``HDF5_LIBRARY_C_DEBUG``
  The debug build of the C library. This variable may be ``-NOTFOUND`` without
  affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_CPP_RELEASE
  The release build of the C++ library.
``HDF5_LIBRARY_CPP_DEBUG``
  The debug build of the C++ library. This variable may be ``-NOTFOUND`` without
  affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_HL_RELEASE
  The release build of the high-level region C library.
``HDF5_LIBRARY_HL_DEBUG``
  The debug build of the high-level region C library. This variable may be
  ``-NOTFOUND`` without affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_HL_CPP_RELEASE
  The release build of the high-level region C++ library.
``HDF5_LIBRARY_HL_CPP_DEBUG``
  The debug build of the high-level region C++ library. This variable may be
  ``-NOTFOUND`` without affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_Tools_RELEASE
  The release build of the tools library.
``HDF5_LIBRARY_Tools_DEBUG``
  The debug build of the tools library. This variable may be ``-NOTFOUND``
  without affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_SZIP_RELEASE
  The release build of the szip library.
``HDF5_LIBRARY_SZIP_DEBUG``
  The debug build of the szip library. This variable may be ``-NOTFOUND`` without
  affecting ``HDF5_FOUND``.
``HDF5_LIBRARY_Z_RELEASE
  The release build of zlib.
``HDF5_LIBRARY_Z_DEBUG``
  The debug build of zlib. This variable may be ``-NOTFOUND`` without
  affecting ``HDF5_FOUND``.
#]========================================================================]

set(HDF5_VERSION @HDF5_VERSION@)

#------------------------------------------------------------------ szip library
find_library(
  HDF5_LIBRARY_SZIP_RELEASE
  NAMES szip
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(HDF5_LIBRARY_SZIP_RELEASE)
find_library(
  HDF5_LIBRARY_SZIP_DEBUG
  NAMES szip_debug
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(HDF5_LIBRARY_SZIP_DEBUG)

#--------------------------------------------------------------------- z library
find_library(
  HDF5_LIBRARY_Z_RELEASE
  NAMES z
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(HDF5_LIBRARY_Z_RELEASE)
find_library(
  HDF5_LIBRARY_Z_DEBUG
  NAMES z_debug
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(HDF5_LIBRARY_Z_DEBUG)

#---------------------------------------------------------------- HDF5 libraries
find_path(
  HDF5_INCLUDE_DIR
  NAMES hdf5.h
  PATHS "${ovsrpro_INCLUDE_DIR}/hdf5"
  DOC "The location of the HDF5 header files."
  NO_DEFAULT_PATH
)
mark_as_advanced(HDF5_INCLUDE_DIR)

if(HDF5_FIND_COMPONENTS)
  list(APPEND HDF5_FIND_COMPONENTS C HL)
  list(REMOVE_DUPLICATES HDF5_FIND_COMPONENTS)
else()
  set(HDF5_FIND_COMPONENTS C HL)
endif()

foreach(component IN LISTS HDF5_FIND_COMPONENTS)
  if(component STREQUAL "C")
    set(library_postfix "")
  else()
    string(TOLOWER ${component} library_postfix)
    set(library_postfix "_${library_postfix}")
  endif()
  find_library(
    HDF5_LIBRARY_${component}_RELEASE
    NAMES hdf5${library_postfix}
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The HDF5 ${component} release library."
    NO_DEFAULT_PATH
  )
  if(HDF5_LIBRARY_${component}_RELEASE)
    set(HDF5_${component}_FOUND true)
  else()
    set(HDF5_${component}_FOUND false)
  endif()
  find_library(
    HDF5_LIBRARY_${component}_DEBUG
    NAMES hdf5${library_postfix}_debug
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The HDF5 ${component} debug library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(
    HDF5_LIBRARY_${component}_RELEASE
    HDF5_LIBRARY_${component}_DEBUG
  )
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  HDF5
  REQUIRED_VARS
    HDF5_INCLUDE_DIR
    HDF5_LIBRARY_SZIP_RELEASE
    HDF5_LIBRARY_Z_RELEASE
  VERSION_VAR HDF5_VERSION
  HANDLE_COMPONENTS
)

#----------------------------------------------------------------------- targets
if(HDF5_FOUND)
  foreach(component IN ITEMS ${HDF5_FIND_COMPONENTS} SZIP Z)
    string(TOLOWER ${component} target_name)
    message(STATUS "[ovsrpro] checking for target HDF5::${target_name}")
    if(NOT TARGET HDF5::${target_name})
      add_library(HDF5::${target_name} IMPORTED UNKNOWN)
      set_target_properties(
        HDF5::${target_name}
        PROPERTIES
          IMPORTED_LOCATION "${HDF5_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_RELEASE "${HDF5_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_MINSIZEREL "${HDF5_LIBRARY_${component}_RELEASE}"
          IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
          INTERFACE_INCLUDE_DIRECTORIES "${HDF5_INCLUDE_DIR}"
      )
      if(HDF5_LIBRARY_${component}_DEBUG)
        set_target_properties(
          HDF5::${target_name}
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${HDF5_LIBRARY_${component}_DEBUG}" 
            IMPORTED_LOCATION_RELWITHDEBINFO "${HDF5_LIBRARY_${component}_DEBUG}" 
        )
        set_property(
          TARGET HDF5::${target_name}
          APPEND
          PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
        )
      endif()
    endif()
  endforeach()
endif()

if(TARGET HDF5::c)
  set_target_properties(
    HDF5::c
    PROPERTIES
      IMPORTED_LINK_INTERFACE_LIBRARIES "HDF5::z;HDF5::hl;HDF5::szip;dl")
endif()
if(TARGET HDF5::cpp)
  set_target_properties(HDF5::cpp PROPERTIES IMPORTED_LINK_INTERFACE_LIBRARIES HDF5::c)
endif()
