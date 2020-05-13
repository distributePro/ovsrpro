xpProOption(cppzmq)
set(CPPZMQ_VERSION 4.2.1)
set(REPO https://github.com/zeromq/cppzmq)
set(PRO_CPPZMQ
  NAME cppzmq
  WEB "cppzmq" ${REPO} "cppzmq"
  LICENSE "MIT" ${REPO}/blob/v${CPPZMQ_VERSION}/LICENSE "MIT"
  DESC "cppzmq is a minimal c++ binding to the libzmq functions."
  REPO "repo" ${REPO}/tree/v${CPPZMQ_VERSION} "cppzmq repo on github"
  VER ${CPPZMQ_VERSION}
  DLURL ${REPO}/archive/v${CPPZMQ_VERSION}.tar.gz
  DLMD5 72d1296f26341d136470c25320936683
  DLNAME cppzmq-${CPPZMQ_VERSION}.tar.gz
)


function(build_cppzmq)
  if (NOT (XP_DEFAULT OR XP_PRO_CPPZMQ))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_ZEROMQ))
    message(FATAL_ERROR "cppzmq requires zeromq")
  endif()
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/Findcppzmq.cmake"
    "${STAGE_DIR}/share/cmake/Findcppzmq.cmake"
    @ONLY
  )
  set(
    XP_CONFIGURE
    -DZeroMQ_DIR=${STAGE_DIR}/share/cmake/ZeroMQ
    -DCMAKE_INSTALL_INCLUDEDIR=include/cppzmq
  )
  xpCmakeBuild(cppzmq "" "${XP_CONFIGURE}")
  add_dependencies(cppzmq zeromq_Release)
endfunction()
