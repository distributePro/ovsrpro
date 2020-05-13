# Note: Requres gnu32 for windows to use sed, find, and xargs (c:\program files(x86)\gnuwin32)

xpProOption(zookeeper)
set(REPO https://github.com/apache/zookeeper)
set(REPO_PATH "${CMAKE_BINARY_DIR}/xpbase/Source/zookeeper")
set(ZOOKEEPER_VERSION 3.4.13)
if(WIN32)
  set(ZOO_PATCH "${PATCH_DIR}/zookeeper-windows.patch")
else(UNIX)
  set(ZOO_PATCH "${PATCH_DIR}/zookeeper.patch")
endif()
set(PRO_ZOOKEEPER
  NAME zookeeper
  WEB "Zookeeper" https://zookeeper.apache.org/ "Zookeeper - Home"
  LICENSE "open" http://www.apache.org/licenses/ "Apache V2.0"
  DESC "Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination. -- [windows-only patch](../patches/zookeeper-windows.patch)"
  REPO "repo" ${REPO} "Zookeeper main repo"
  VER ${ZOOKEEPER_VERSION}
  GIT_ORIGIN ${REPO}
  GIT_TAG release-${ZOOKEEPER_VERSION}
  DLURL ${REPO}/archive/release-${ZOOKEEPER_VERSION}.tar.gz
  DLMD5 c6eeaab9624730f0a16a97dd24838813
  DLNAME zookeeper-release-${ZOOKEEPER_VERSION}.tar.gz
  PATCH ${ZOO_PATCH}
)


macro(zookeepercheckDependencies)
  find_program(javac javac)
  mark_as_advanced(javac)
  if(NOT javac)
    message(FATAL_ERROR "javac required for zookeeper")
  endif()

  find_program(ant ant)
  mark_as_advanced(ant)
  if(NOT ant)
    message(FATAL_ERROR "ant required for zookeeper")
  endif()
endmacro()


function(build_zookeeper)
  if(NOT (XP_DEFAULT OR XP_PRO_ZOOKEEPER))
    return()
  endif()
  zookeeperCheckDependencies()
  xpPatchProject(${PRO_ZOOKEEPER})
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/Findzookeeper.cmake"
    "${STAGE_DIR}/share/cmake/Findzookeeper.cmake"
    @ONLY
  )
  ExternalProject_Get_Property(zookeeper SOURCE_DIR)
  ExternalProject_Add(
    zookeeper_ant
    DEPENDS zookeeper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR}
    CONFIGURE_COMMAND ant clean jar
    BUILD_COMMAND ant compile_jute
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
  )
  if(WIN32)
    _build_zookeeper_on_windows()
  else()
    _build_zookeeper_on_linux()
  endif()
  ExternalProject_Add(
    zookeeper_install_files
    DEPENDS zookeeper_Release
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND
      ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}/share/zookeeper"
      && ${CMAKE_COMMAND} -E copy "${SOURCE_DIR}/src/c/LICENSE" "${STAGE_DIR}/share/zookeeper"
      && ${CMAKE_COMMAND} -E copy "${SOURCE_DIR}/src/c/NOTICE.txt" "${STAGE_DIR}/share/zookeeper"
      && ${CMAKE_COMMAND} -E copy "${SOURCE_DIR}/src/c/README" "${STAGE_DIR}/share/zookeeper"
  )
endfunction(build_zookeeper)


function(_build_zookeeper_on_windows)
  #TODO Still need to convert the Windows build to use ExternalProject...
  set(ZK_INCLUDE_PATH "${SOURCE_DIR}/src/c/include")
  set(zookeeper_hdr_files
    "${ZK_INCLUDE_PATH}/proto.h"
    "${ZK_INCLUDE_PATH}/recordio.h"
    "${ZK_INCLUDE_PATH}/zookeeper.h"
    "${ZK_INCLUDE_PATH}/zookeeper_log.h"
    "${ZK_INCLUDE_PATH}/zookeeper_version.h"
    "${SOURCE_DIR}/src/c/generated/zookeeper.jute.h"
    "${SOURCE_DIR}/src/c/src/winport.h"
    "${ZK_INCLUDE_PATH}/winconfig.h"
    "${ZK_INCLUDE_PATH}/winstdint.h"
  )
  add_custom_target(
    zookeeper_build
    ALL
    WORKING_DIRECTORY "${REPO_PATH}/src/c"
    COMMAND
      msbuild
      "${REPO_PATH}/src/c/zookeeper.sln"
      /p:Configuration=Release\;Platform=x64
      /t:zookeeper:rebuild
    COMMAND
      msbuild
      "${REPO_PATH}/src/c/zookeeper.sln"
      /p:Configuration=Debug\;Platform=x64
      /t:zookeeper:rebuild
    COMMAND ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}/include/zookeeper"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}/lib"
    COMMAND
      ${CMAKE_COMMAND}
      -E copy
      "${REPO_PATH}/src/c/x64/Debug/libzookeeperd-mt.lib"
      "${STAGE_DIR}/lib/libzookeeperd-mt.lib"
    COMMAND
      ${CMAKE_COMMAND}
      -E copy
      "${REPO_PATH}/src/c/x64/Release/libzookeeper-mt.lib"
      "${STAGE_DIR}/lib/libzookeeper-mt.lib"
    DEPENDS zookeeper zookeeper_ant
  )
  foreach(header_file IN LISTS zookeeper_hdr_files)
    get_filename_component(header_name ${header_file} NAME)
    add_custom_command(
      TARGET zookeeper_build
      POST_BUILD
      COMMAND
        ${CMAKE_COMMAND}
        -E copy
        "${header_file}"
        "${STAGE_DIR}/include/zookeeper/${header_name}"
    )
  endforeach()
endfunction()


function(_build_zookeeper_on_linux)
  set(ACLOCAL_STR "aclocal -I ${SOURCE_DIR}/src/c/cppunit-${CPP_UNIT_VERSION}")
  ExternalProject_Add(
    zookeeper_Release
    DEPENDS zookeeper_ant
    DOWNLOAD_COMMAND ""
    SOURCE_DIR "${SOURCE_DIR}/src/c"
    CONFIGURE_COMMAND
      ${CMAKE_COMMAND} -E
        env ACLOCAL=${ACLOCAL_STR} autoreconf -if -W none
      && ./configure
        AM_PATH_CPPUNIT=${SOURCE_DIR}
        CFLAGS=-Wno-format-overflow
        --prefix=${STAGE_DIR}
    BUILD_COMMAND $(MAKE) clean && $(MAKE)
    BUILD_IN_SOURCE true
    INSTALL_COMMAND $(MAKE) install
  )

  if(XP_BUILD_DEBUG)
    ExternalProject_Add(
      zookeeper_Debug
      DEPENDS zookeeper_Release
      DOWNLOAD_COMMAND ""
      SOURCE_DIR "${SOURCE_DIR}/src/c"
      CONFIGURE_COMMAND
        ./configure
        CFLAGS=-Wno-format-overflow
        --libdir=${STAGE_DIR}/lib/zookeeperDebug
        --enable-debug
      BUILD_COMMAND $(MAKE) clean && $(MAKE)
      BUILD_IN_SOURCE true
      INSTALL_COMMAND
        $(MAKE) install-libLTLIBRARIES
        && ${CMAKE_COMMAND}
          -E rename
          "${STAGE_DIR}/lib/zookeeperDebug/libzookeeper_mt.a" 
          "${STAGE_DIR}/lib/libzookeeper_mt-d.a"
        && ${CMAKE_COMMAND}
          -E rename
          "${STAGE_DIR}/lib/zookeeperDebug/libzookeeper_st.a" 
          "${STAGE_DIR}/lib/libzookeeper_st-d.a"
    )
  endif()
endfunction()