#[========================================================================[.rst:
FindOvsrproHdf5
===============

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

``hdf5::szip``
  The SZIP library, built as part of HDF5.
``hdf5::z``
  ZLIB, built as part of HDF5.

This module also provides these imported targets depending on the specified
components:

``hdf5::c``
  The C version of HDF5.
``hdf5::CPP``
  The C++ version of HDF5.
``hdf5::hl``
  The HDF5 High-Level Region C library.
``hdf5::hl_CPP``
  The HDF5 High-Level Region C++ library.
``hdf5::tools``
  The library used by various HDF5 tools.

Result Variables
----------------

This module defines the following variables:

``OvsrproHdf5_FOUND``
  True if the Ovsrpro hdf5 library is found.
``OvsrproHdf5_INCLUDE_DIR``
  The path to the hdf5 header files.
``OvsrproHdf5_VERSION``
  The version of hdf5 that was found.
``OvsrproHdf5_LIBRARY_C_RELEASE
  The release build of the C library.
``OvsrproHdf5_LIBRARY_C_DEBUG``
  The debug build of the C library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_CPP_RELEASE
  The release build of the C++ library.
``OvsrproHdf5_LIBRARY_CPP_DEBUG``
  The debug build of the C++ library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_HL_RELEASE
  The release build of the high-level region C library.
``OvsrproHdf5_LIBRARY_HL_DEBUG``
  The debug build of the high-level region C library. This variable may be
  ``-NOTFOUND`` without affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_HL_CPP_RELEASE
  The release build of the high-level region C++ library.
``OvsrproHdf5_LIBRARY_HL_CPP_DEBUG``
  The debug build of the high-level region C++ library. This variable may be
  ``-NOTFOUND`` without affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_Tools_RELEASE
  The release build of the tools library.
``OvsrproHdf5_LIBRARY_Tools_DEBUG``
  The debug build of the tools library. This variable may be ``-NOTFOUND``
  without affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_SZIP_RELEASE
  The release build of the szip library.
``OvsrproHdf5_LIBRARY_SZIP_DEBUG``
  The debug build of the szip library. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproHdf5_FOUND``.
``OvsrproHdf5_LIBRARY_Z_RELEASE
  The release build of zlib.
``OvsrproHdf5_LIBRARY_Z_DEBUG``
  The debug build of zlib. This variable may be ``-NOTFOUND`` without
  affecting ``OvsrproHdf5_FOUND``.
#]========================================================================]

# TODO Replace this with the version variable, so it can be configured.
set(OvsrproHdf5_VERSION "1.8.16")

#------------------------------------------------------------------ szip library
find_library(
  OvsrproHdf5_LIBRARY_SZIP_RELEASE
  NAMES szip
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproHdf5_LIBRARY_SZIP_RELEASE)
find_library(
  OvsrproHdf5_LIBRARY_SZIP_DEBUG
  NAMES szip_debug
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproHdf5_LIBRARY_SZIP_DEBUG)

#--------------------------------------------------------------------- z library
find_library(
  OvsrproHdf5_LIBRARY_Z_RELEASE
  NAMES z
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproHdf5_LIBRARY_Z_RELEASE)
find_library(
  OvsrproHdf5_LIBRARY_Z_DEBUG
  NAMES z_debug
  PATHS "${ovsrpro_LIBRARY_DIR}"
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproHdf5_LIBRARY_Z_DEBUG)

#---------------------------------------------------------------- HDF5 libraries
find_path(
  OvsrproHdf5_INCLUDE_DIR
  NAMES hdf5.h
  PATHS "${ovsrpro_INCLUDE_DIR}/hdf5"
  DOC "The location of the HDF5 header files."
  NO_DEFAULT_PATH
)
mark_as_advanced(OvsrproHdf5_INCLUDE_DIR)

foreach(component IN LISTS OvsrproHdf5_FIND_COMPONENTS)
  if(component STREQUAL "C")
    set(library_postfix "")
  else()
    string(TOLOWER ${component} library_postfix)
    set(library_postfix "_${library_postfix}")
  endif()
  find_library(
    OvsrproHdf5_LIBRARY_${component}_RELEASE
    NAMES hdf5${library_postfix}
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The HDF5 ${component} release library."
    NO_DEFAULT_PATH
  )
  if(OvsrproHdf5_LIBRARY_${component}_RELEASE)
    set(OvsrproHdf5_${component}_FOUND true)
  else()
    set(OvsrproHdf5_${component}_FOUND false)
  endif()
  find_library(
    OvsrproHdf5_LIBRARY_${component}_DEBUG
    NAMES hdf5${library_postfix}_debug
    PATHS "${ovsrpro_LIBRARY_DIR}"
    DOC "The HDF5 ${component} debug library."
    NO_DEFAULT_PATH
  )
  mark_as_advanced(
    OvsrproHdf5_LIBRARY_${component}_RELEASE
    OvsrproHdf5_LIBRARY_${component}_DEBUG
  )
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  OvsrproHdf5
  REQUIRED_VARS
    OvsrproHdf5_INCLUDE_DIR
    OvsrproHdf5_LIBRARY_SZIP_RELEASE
    OvsrproHdf5_LIBRARY_Z_RELEASE
  VERSION_VAR OvsrproHdf5_VERSION
  HANDLE_COMPONENTS
)

#----------------------------------------------------------------------- targets
if(OvsrproHdf5_FOUND)
  foreach(component IN ITEMS ${OvsrproHdf5_FIND_COMPONENTS} SZIP Z)
    string(TOLOWER ${component} target_name)
    if(NOT TARGET hdf5::${target_name})
      add_library(hdf5::${target_name} IMPORTED UNKNOWN)
      set_target_properties(
        hdf5::${target_name}
        PROPERTIES
          IMPORTED_LOCATION "${OvsrproHdf5_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_RELEASE "${OvsrproHdf5_LIBRARY_${component}_RELEASE}"
          IMPORTED_LOCATION_MINSIZEREL "${OvsrproHdf5_LIBRARY_${component}_RELEASE}"
          IMPORTED_CONFIGURATIONS "RELEASE;MINSIZEREL"
          INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${OvsrproHdf5_INCLUDE_DIR}"
      )
      if(OvsrproHdf5_LIBRARY_${component}_DEBUG)
        set_target_properties(
          hdf5::${target_name}
          PROPERTIES
            IMPORTED_LOCATION_DEBUG "${OvsrproHdf5_LIBRARY_${compoenent}_DEBUG}" 
            IMPORTED_LOCATION_RELWITHDEBINFO "${OvsrproHdf5_LIBRARY_${compoenent}_DEBUG}" 
        )
        set_property(
          TARGET hdf5::${target_name}
          APPEND
          PROPERTY IMPORTED_CONFIGURATIONS "DEBUG;RELWITHDEBINFO"
        )
      endif()
    endif()
  endforeach()
endif()