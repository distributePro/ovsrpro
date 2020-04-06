xpProOption(qwt)
set(QWT_VERSION 6.1.3)
set(PRO_QWT
  NAME qwt
  WEB "Qwt" http://qwt.sourceforge.net/ "Qwt - Qt Widgets for Technical Applications"
  LICENSE "LGPL" http://qwt.sourceforge.net/qwtlicense.html "LGPL with exceptions"
  DESC "The Qwt library contains GUI Components and utility classes which are primarily useful for programs with a technical background."
  VER ${QWT_VERSION}
  DLURL https://downloads.sourceforge.net/project/qwt/qwt/${QWT_VERSION}/qwt-${QWT_VERSION}.tar.bz2
  DLMD5 19d1f5fa5e22054d22ee3accc37c54ba
  PATCH ${PATCH_DIR}/qwtconfig.pri.patch
)


function(build_qwt)
  if(NOT (XP_DEFAULT OR XP_PRO_QWT))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_QT5))
    message(FATAL_ERROR "QWT requires Qt5")
  endif()
  if(NOT TARGET qwt)
    xpPatchProject(${PRO_QWT})
  endif()

  if(XP_BUILD_STATIC)
    set(STATIC_FLAG true)
  else()
    set(STATIC_FLAG false)
  endif()

  configure_file(
    "${PRO_DIR}/use/useop-qwt-config.cmake"
    "${STAGE_DIR}/share/cmake/useop-qwt-config.cmake"
    COPYONLY
  )

  if(WIN32)
    set(MAKE_CMD nmake)
  else()
    set(MAKE_CMD $(MAKE))
  endif()

  # In the configure step invoke qmake from the QT5 that was just built
  ExternalProject_Get_Property(qwt SOURCE_DIR)
  ExternalProject_Add(
    qwt_build
    DEPENDS qwt qt5_install_files
    DOWNLOAD_COMMAND ""
    SOURCE_DIR "${SOURCE_DIR}"
    CONFIGURE_COMMAND
      "${STAGE_DIR}/qt5/bin/qmake"
      qwt.pro
      INSTALL_PATH="${STAGE_DIR}"
      STATIC_BUILD="${STATIC_FLAG}"
    BUILD_COMMAND ${MAKE_CMD} clean && ${MAKE_CMD}
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ${MAKE_CMD} install
  )

  ExternalProject_Add(
    qwt_install_files
    DEPENDS qwt_build
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND
      ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}/share/qwt"
      && ${CMAKE_COMMAND} -E copy "${SOURCE_DIR}/COPYING" "${STAGE_DIR}/share/qwt"
  )

endfunction()
