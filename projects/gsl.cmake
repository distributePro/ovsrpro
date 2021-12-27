xpProOption(gsl)
set(GSL_VER 3.1.0)
set(REPO https://github.com/microsoft/GSL)
set(PRO_GSL
  NAME gsl
  WEB "gsl" ${REPO} "gsl"
  LICENSE "MIT" ${REPO}/blob/v${GSL_VER}/LICENSE "MIT"
  DESC "Guidelines Support Library"
  REPO "repo" ${REPO}/tree/v${GSL_VER} "gsl repo on github"
  VER ${GSL_VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG v${GSL_VER}
  DLURL ${REPO}/archive/v${GSL_VER}.tar.gz
  DLMD5 b6910c54113f921b03dc06642cf7f11c
  DLNAME gsl-${GSL_VER}.tar.gz
)
function(build_gsl)
  if (NOT (XP_DEFAULT OR XP_PRO_GSL))
    return()
  endif()
  set(XP_CONFIGURE -DCMAKE_INSTALL_INCLUDEDIR=include/gsl -DGSL_TEST=off)
  xpCmakeBuild(gsl "" "${XP_CONFIGURE}")
endfunction()
