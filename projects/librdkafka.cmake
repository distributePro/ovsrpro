xpProOption(librdkafka)
set(LIBRDKAFKA_VERSION 1.4.0)
set(REPO https://github.com/edenhill/librdkafka)
set(PRO_LIBRDKAFKA
  NAME librdkafka
  WEB "librdkafka" ${REPO} "librdkafka on github"
  LICENSE "open" ${REPO}/blob/master/LICENSE "2-clause BSD license"
  DESC "librdkafka is a C library implementation of the Apache Kafka protocol, containing both Producer and Consumer support."
  REPO "repo" ${REPO} "The Apache Kafka C/C++ library"
  VER ${LIBRDKAFKA_VERSION}
  GIT_ORIGIN git://github.com/distributepro/librdkafka.git
  GIT_TAG v${LIBRDKAFKA_VERSION}
  GIT_REF ${LIBRDKAFKA_VERSION}
  DLURL ${REPO}/archive/v${LIBRDKAFKA_VERSION}.tar.gz
  DLMD5 8b3c09e50a21beafecd25c26ad48c2e7
  DLNAME librdkafka-${LIBRDKAFKA_VERSION}.tar.gz
)


function(build_librdkafka)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBRDKAFKA))
    return()
  endif()
  configure_file(
    "${PRO_DIR}/use/useop-librdkafka-config.cmake"
    "${STAGE_DIR}/share/cmake/"
    @ONLY
    NEWLINE_STYLE LF
  )
  xpSetPostfix()
  set(XP_CONFIGURE
    -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
    -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS};-fPIC
    -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS};-fPIC
    -DRDKAFKA_BUILD_STATIC=on
  )
  xpCmakeBuild(librdkafka "" "${XP_CONFIGURE}")
endfunction()
