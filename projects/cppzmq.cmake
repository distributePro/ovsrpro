xpProOption(cppzmq)
set(VERSION 4.2.1)
set(REPO https://github.com/zeromq/cppzmq)
set(PRO_CPPZMQ
  NAME cppzmq
  WEB "cppzmq" ${REPO} "cppzmq"
  LICENSE "MIT" ${REPO}/blob/v${VERSION}/LICENSE "MIT"
  DESC "cppzmq is a minimal c++ binding to the libzmq functions."
  REPO "repo" ${REPO}/tree/v${VERSION} "cppzmq repo on github"
  VER ${VERSION}
  DLURL ${REPO}/archive/v${VERSION}.tar.gz
  DLMD5 72d1296f26341d136470c25320936683
  DLNAME cppzmq-${VERSION}.tar.gz
)


function(build_cppzmq)
  if (NOT (XP_DEFAULT OR XP_PRO_CPPZMQ))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_ZEROMQ))
    message(FATAL_ERROR "cppzmq requires zeromq")
  endif()
  configure_file(
    "${PRO_DIR}/use/useop-cppzmq-config.cmake"
    "${STAGE_DIR}/share/cmake/"
    @ONLY
    NEWLINE_STYLE LF
  )
  set(
    XP_CONFIGURE
    -DZeroMQ_DIR=${STAGE_DIR}/share/cmake/ZeroMQ
    -DCMAKE_INSTALL_INCLUDEDIR=include/cppzmq
  )
  xpCmakeBuild(cppzmq "" "${XP_CONFIGURE}")
  add_dependencies(cppzmq zeromq_Release)
endfunction()
