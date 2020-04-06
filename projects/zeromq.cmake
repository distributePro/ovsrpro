xpProOption(zeromq)
set(ZMQ_VERSION 4.2.3)
set(REPO https://github.com/zeromq/libzmq)
set(PRO_ZEROMQ
  NAME zeromq
  WEB "ZeroMQ" https://zeromq.org "ZeroMQ - Home"
  LICENSE "LGPL" ${REPO}/blob/master/README.md "LGPL v3 (See License Section)"
  DESC "ZeroMQ is a lightweight messaging kernel that extends standard socket interfaces with more powerful features."
  REPO "repo" ${REPO} "ZeroMQ repo on github"
  VER ${ZMQ_VERSION}
  DLURL ${REPO}/archive/v${ZMQ_VERSION}.tar.gz
  DLMD5 ad07f71105fc914e1937683d33b4ee8d
  DLNAME libzmq-${ZMQ_VERSION}.tar.gz
)

function(build_zeromq)
  if (NOT (XP_DEFAULT OR XP_PRO_ZEROMQ))
    return()
  endif()
  configure_file(
    "${PRO_DIR}/use/useop-zeromq-config.cmake"
    "${STAGE_DIR}/share/cmake/"
    @ONLY
    NEWLINE_STYLE LF
  )
  xpSetPostfix()
  set(
    XP_CONFIGURE
    -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_INCLUDEDIR=include/zeromq
    -DWITH_PERF_TOOL=off
    -DZMQ_BUILD_TESTS=off
    -DENABLE_CPACK=off
  )
  xpCmakeBuild(zeromq "" "${XP_CONFIGURE}")
endfunction()
