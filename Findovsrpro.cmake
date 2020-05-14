if(NOT ovsrpro_FIND_VERSION)
  message(FATAL_ERROR "A version of Ovsrpro is required in the find_package() command.")
endif()

function(ovsrpro_message)
  if(NOT ovsrpro_FIND_QUIETLY)
    message(${ARGN})
  endif()
endfunction()

if(ovsrpro_FIND_COMPONENTS)
  ovsrpro_message(
    AUTHOR_WARNING
    "Ovsrpro does not support components in find_package()."
  )
endif()

# Since ovsrpro uses date versioning instead of semantic versioning, we cannot
# deduce compatibility from the version. So force an exact match to be found.
if(NOT ovsrpro_FIND_VERSION_EXACT)
  set(ovsrpro_FIND_VERSION_EXACT true)
  ovsrpro_message(
    AUTHOR_WARNING
    "Ovsrpro requires an exact version match. We recommend adding EXACT to find_package()."
  )
endif()

# Figure out the compiler name and version to search for.
if(CMAKE_COMPILER_IS_GNUCXX)
  execute_process(
    COMMAND
      ${CMAKE_CXX_COMPILER}
      ${CMAKE_CXX_COMPILER_ARG1}
      -dumpfullversion
      -dumpversion
    OUTPUT_VARIABLE gcc_version
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  string(
    REGEX REPLACE
    "([0-9]+)\\.([0-9]+)\\.([0-9]+)?"
    "gcc\\1\\2\\3"
    compiler
    ${gcc_version}
  )
else()
  message(FATAL_ERROR "${CMAKE_CXX_COMPILER_ID} is not supported.")
endif()

# Get the architecture width to search for.
cmake_host_system_information(RESULT is_64_bit QUERY IS_64BIT)
if(is_64_bit)
  set(bits 64)
else()
  set(bits 32)
endif()

set(ovsrpro_signature ${ovsrpro_FIND_VERSION}-${compiler}-${bits})
ovsrpro_message(STATUS "Looking for ovsrpro ${ovsrpro_signature}...")
find_path(
  ovsrpro_ROOT_DIR
  NAMES ovsrpro_${ovsrpro_signature}.txt
  PATHS
    # environment variable
    "$ENV{ovsrpro}/ovsrpro ${ovsrpro_signature}"
    "$ENV{ovsrpro_ROOT_DIR}/ovsrpro-${ovsrpro_signature}-${CMAKE_SYSTEM_NAME}"
    # installed versions
    "~/ovsrpro/ovsrpro-${ovsrpro_signature}-${CMAKE_SYSTEM_NAME}"
    "/opt/ovsrpro/ovsrpro-${ovsrpro_signature}-${CMAKE_SYSTEM_NAME}"
    # rpm installed location
    "/opt/ovsrpro"
  DOC "ovsrpro directory"
)

# TODO Replace this with the version variable, so it can be configured.
set(ovsrpro_VERSION @version@)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  ovsrpro
  REQUIRED_VARS ovsrpro_ROOT_DIR
  VERSION_VAR ovsrpro_VERSION
)
list(APPEND CMAKE_MODULE_PATH "${ovsrpro_ROOT_DIR}/share/cmake")

set(
  ovsrpro_INCLUDE_DIR
  "${ovsrpro_ROOT_DIR}/include"
  CACHE
  PATH
  "The path to Ovsrpro project header files."
)
set(
  ovsrpro_LIBRARY_DIR
  "${ovsrpro_ROOT_DIR}/lib"
  CACHE
  PATH
  "The path to Ovsrpro project library files."
)
set(
  ovsrpro_CONFIG_PATH
  "${ovsrpro_ROOT_DIR}/qt5/lib/cmake"
  CACHE
  PATH
  "The path to use to find Qt5 CMake configuration files."
)
mark_as_advanced(
  ovsrpro_ROOT_DIR
  ovsrpro_INCLUDE_DIR
  ovsrpro_LIBRARY_DIR
  ovsrpro_CONFIG_PATH
)
