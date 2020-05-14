xpProOption(librdkafka)
set(LIBRDKAFKA_VERSION 0.9.5)
set(REPO https://github.com/edenhill/librdkafka)
set(PRO_LIBRDKAFKA
  NAME librdkafka
  WEB "librdkafka" ${REPO} "librdkafka on github"
  LICENSE "open" ${REPO}/blob/master/LICENSE "2-clause BSD license"
  DESC "librdkafka is a C library implementation of the Apache Kafka protocol, containing both Producer and Consumer support -- [windows-only patch](../patches/librdkafka-windows.patch)"
  REPO "repo" ${REPO} "The Apache C/C++ library."
  VER ${LIBRDKAFKA_VERSION}
  GIT_ORIGIN git://github.com/edenhill/librdkafka.git
  GIT_TAG v${LIBRDKAFKA_VERSION} # what to 'git checkout'
  DLURL ${REPO}/archive/v${LIBRDKAFKA_VERSION}.tar.gz
  DLMD5 8e5685baa01554108ae8c8e9c97dc495
  DLNAME librdkafka-v${LIBRDKAFKA_VERSION}.tar.gz
  PATCH ${PATCH_DIR}/librdkafka.patch
  DIFF ${REPO}/compare/edenhill:
  )


function(patch_librdkafka)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBRDKAFKA))
    return()
  endif()
  xpPatchProject(${PRO_LIBRDKAFKA})
endfunction(patch_librdkafka)


# macro(addLibs target)
#   if(WIN32)
#     message("adding libs to ${target}")
#     target_link_libraries(${target}
#       ${XP_ROOTDIR}/lib/zlibstatic-s.lib
#       ${XP_ROOTDIR}/lib/crypto-s.lib
#       ${XP_ROOTDIR}/lib/ssl-s.lib)
#   endif()
# endmacro()


function(build_librdkafka)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBRDKAFKA))
    return()
  endif()
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/Findlibrdkafka.cmake"
    "${STAGE_DIR}/share/cmake/Findlibrdkafka.cmake"
    @ONLY
  )
  xpSetPostfix()
  xpStringAppendIfDne(CMAKE_CXX_FLAGS "-fPIC")
  xpStringAppendIfDne(CMAKE_C_FLAGS "-fPIC")
  set(XP_CONFIGURE
      -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
      -DWITH_SSL=off
      -DWITH_ZLIB=off
     )
  xpCmakeBuild(librdkafka "" "${XP_CONFIGURE}")
endfunction()
