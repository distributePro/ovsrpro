xpProOption(novas)
if(WIN32)
  set(NOVAS_DLURL http://aa.usno.navy.mil/software/novas/novas_c/novasc3.1.zip)
  set(NOVAS_DLMD5 23429099025999970b2e5497c57a1e21)
else()
  set(NOVAS_DLURL http://aa.usno.navy.mil/software/novas/novas_c/novasc3.1.tar.gz)
  set(NOVAS_DLMD5 f5dd6f7930b18616154b33aae1ef02d6)
endif()
set(NOVAS_VERSION 3.1)
set(PRO_NOVAS
  NAME novas
  WEB "NOVAS" http://aa.usno.navy.mil/software/novas/novas_info.php "NOVAS"
  LICENSE "open" http://aa.usno.navy.mil/software/novas/novas_c/README.txt "(See Section IV. Using NOVAS in Your Applications)"
  DESC "NOVAS is an integrated package of ANSI C functions for computing many commonly needed quantities in positional astronomy."
  VER ${NOVAS_VERSION}
  DLURL ${NOVAS_DLURL}
  DLMD5 ${NOVAS_DLMD5}
  PATCH ${PATCH_DIR}/novas.patch
)

# TODO This is a temporary fix. The USNO website is down. It's not expected to be
# back up until fall 2020. When it is back up, take out this entire block.
if(XP_DEFAULT OR XP_PRO_NOVAS)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/../_bldpkgs/novasc3.1.tar.gz")
    set(
      OP_NOVAS_PATH
      "OP_NOVAS_PATH-NOTFOUND"
      CACHE
      FILEPATH
      "The path to the NOVAS archive file on your disk."
    )
    if(NOT EXISTS "${OP_NOVAS_PATH}")
      message(
        SEND_ERROR
        "Cannot find novasc3.1.tar.gz. Ensure OP_NOVAS_PATH is set to the correct path."
      )
      return()
    endif()
    file(MD5 "${OP_NOVAS_PATH}" actual_md5)
    if(NOT actual_md5 STREQUAL NOVAS_DLMD5)
      message(
        SEND_ERROR
        "${OP_NOVAS_PATH} is incorrect or is corrupt.\n"
        "  Actual MD5:   ${actual_md5}\n"
        "  Expected MD5: ${NOVAS_DLMD5}"
      )
      return()
    endif()
    file(COPY "${OP_NOVAS_PATH}" DESTINATION "${CMAKE_BINARY_DIR}/../_bldpkgs/")
  endif()
endif()
file(MD5 "${CMAKE_BINARY_DIR}/../_bldpkgs/novasc3.1.tar.gz" actual_md5)
if(NOT actual_md5 STREQUAL NOVAS_DLMD5)
  message(
    SEND_ERROR
    "Something failed in the copy operation for novasc3.1.tar.gz."
    "  Actual MD5:   ${actual_md5}"
    "  Expected MD5: ${NOVAS_DLMD5}"
  )
  return()
endif()


function(patch_novas)
  if(NOT (XP_DEFAULT OR XP_PRO_NOVAS))
    return()
  endif()
  xpPatchProject(${PRO_NOVAS})
endfunction()


function(build_novas)
  if (NOT (XP_DEFAULT OR XP_PRO_NOVAS))
    return()
  endif()
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/FindNOVAS.cmake"
    "${STAGE_DIR}/share/cmake/FindNOVAS.cmake"
    @ONLY
  )
  xpCmakeBuild(novas)
endfunction()
