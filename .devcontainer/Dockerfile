FROM centos/devtoolset-7-toolchain-centos7:latest

LABEL \
  description="Ovsrpro Centos 7 Development Container" \
  name="ovsrpro-dev"

USER 0
RUN set -eux; \
  yum --assumeyes update; \
  yum install --assumeyes \
    epel-release \
    # This repository gives us more modern versions of some software, such as Git.
    https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm; \
  yum install --assumeyes \
    devtoolset-9-toolchain \
    git \
    make \
    wget \
    # Required by GLEW
    libX11-devel \
    mesa-libGL-devel \
    mesa-libGLU-devel \
    # Required for Qt5
    bison \
    expat-devel \
    fontconfig-devel \
    freetype-devel \
    gperf \
    libxcb-devel \
    libxkbcommon-devel \
    libxkbcommon-x11-devel \
    openssl-devel \
    which \
    zlib-devel \
    # Required by ZooKeeper
    ant \
    autoconf \
    automake \
    java-11-openjdk-devel \
    libtool; \
  yum --assumeyes clean all; \
  wget \
    --output-document=externpro.sh \
    https://github.com/distributePro/externpro/releases/download/21.04.1/externpro-21.04.1-gcc931-64-Linux.sh; \
  chmod 744 externpro.sh; \
  ./externpro.sh \
    --include-subdir \
    --skip-license \
    --prefix=/opt/extern; \
  rm externpro.sh; \
  wget \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash; \
  wget \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh; \
  chmod 744 git-completion.bash git-prompt.sh; \
  echo ". ~/git-completion.bash" >> ${HOME}/.bashrc; \
  echo ". ~/git-prompt.sh" >> ${HOME}/.bashrc; \
  echo "alias ls='ls --color=auto'" >> ${HOME}/.bashrc; \
  echo "PS1='\n\[\e[01;39m\]ovsrpro-dev \[\e[01;35m\]\w\[\e[01;36m\]\$(__git_ps1)\[\e[0m\]\n'" >> ${HOME}/.bashrc; \
  sed --in-place 's/devtoolset-7/devtoolset-9/' /opt/app-root/etc/scl_enable

RUN set -eux; \
  wget --output-document=cmake.sh \
    https://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2-linux-x86_64.sh; \
  chmod 744 cmake.sh; \
  ./cmake.sh --install-prefix=/opt/cmake --exclude-subdir --skip-license; \
  ln -s /opt/cmake/bin/ccmake /usr/bin/ccmake; \
  ln -s /opt/cmake/bin/cmake /usr/bin/cmake; \
  ln -s /opt/cmake/bin/ctest /usr/bin/ctest; \
  ln -s /opt/cmake/bin/cpack /usr/bin/cpack

CMD ["/bin/bash"]