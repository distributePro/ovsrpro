# Note: Requres gnu32 for windows to use sed, find, and xargs (c:\program files(x86)\gnuwin32)

xpProOption(zookeeper)
set(REPO https://github.com/apache/zookeeper)
set(REPO_PATH "${CMAKE_BINARY_DIR}/xpbase/Source/zookeeper")
set(ZOOKEEPER_VERSION 3.6.1)
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
  DLMD5 ede02f69fd41766264b8a094602eb46e 
  DLNAME zookeeper-release-${ZOOKEEPER_VERSION}.tar.gz
  PATCH "${PATCH_DIR}/zookeeper.patch"
)

if(XP_DEFAULT OR XP_PRO_ZOOKEEPER)
  find_package(Java REQUIRED COMPONENTS Development)
  find_program(mvn mvn)
  if(NOT mvn)
    message(FATAL_ERROR "Maven is required to build zookeeper.")
  endif()
endif()


function(build_zookeeper)
  if(NOT (XP_DEFAULT OR XP_PRO_ZOOKEEPER))
    return()
  endif()
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/Findzookeeper.cmake"
    "${STAGE_DIR}/share/cmake/Findzookeeper.cmake"
    @ONLY
  )
  ExternalProject_Get_Property(zookeeper SOURCE_DIR)
  ExternalProject_Add(
    zookeeper_maven
    DEPENDS zookeeper
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND mvn --batch-mode clean compile -DskipTests
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
  )
  set(
    cmake_options
    -DWANT_CPPUNIT:bool=off
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_INCLUDEDIR=include/zookeeper
    # This must be OFF (case sensitive) to disable OpenSSL.
    -DWITH_OPENSSL:STRING=OFF
    -DCMAKE_DEBUG_POSTFIX=d
  )
  xpCmakeBuild(zookeeper zookeeper_maven "${cmake_options}")
endfunction(build_zookeeper)