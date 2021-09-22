# ovsrpro

A meta-package for developing projects that use these libraries.

## Using ovsrpro

Throughout this section, I assume

- Your installation prefix is */opt/extern*,
- You installed to a subdirectory of the installation prefix,
- Your version of ovsrpro is 21.09.

If you do any of these differently, make the appropriate substitutes in the instructions and example commands.

### Installation

1. Install ovsrpro on your platform. See the [releases page](https://github.com/distributePro/ovsrpro/releases) for downloads.
   1. We recommend installing to */opt/extern/*, but that is not required.
1. Create a symbolic link from */opt/extern/ovsrpro/* */opt/extern/ovsrpro-21.09-gcc931-64-Linux/*.
1. Update your ldconfig.

```bash
./ovsrpro-21.09-gcc931-64-Linux.sh \
  --prefix=/opt/extern \
  --include-subdir
ln -s /opt/extern/ovsrpro-21.09-gcc931-64-Linux/ /opt/extern/ovsrpro
```

### Finding ovsrpro with CMake

1. Copy */opt/extern/ovsrpro-21.09-gcc931-64-Linux/share/cmake/Findovsrpro.cmake* to the root directory of your project.
1. In your root CMakeLists.txt file, add these lines:
   ```cmake
   set(ovsrpro_rev 21.09)
   find_package(ovsrpro)
   ```
1. Use `opFindPkg()` to load an ovsrpro package:
   ```cmake
   opFindPkg(qwt)
   ```

## Building ovsrpro

### Build Environment

We recommend using our VS Code [development container](https://code.visualstudio.com/docs/remote/containers).
Follow these steps to get the container setup.

1. Clone the repository.
1. Make a build directory adjacent to the repository.
   ```bash
   cd /path/to/repository
   mkdir ../build
   ```
1. Open the repository folder in VS Code.
1. Use the VS Code command `Remote Containers: Rebuild and Reopen in Container`.

If you don't want to use the development container, you need to maintain your own build environment.
Follow these instructions to set up your system.

1. Install these tools:
   - externpro --- Install [externpro](https://github.com/distributePro/externpro) for your platform.
   - CMake --- Install [CMake](https://cmake.org/download/).
   - GCC --- Install GCC with your package management system. Clang may work, but we don't support it.
1. Install 3rd party development packages. See our development container [Dockerfile](.devcontainer/Dockerfile) for the complete list.

### Configuring and Building

Run these steps in your build directory:

1. Use CMake to generate the build system.
1. Use your build tool to build the projects.
1. Use CPack to create the installation package.

Here is a basic complete example:

```bash
cmake -D XP_STEP=build ../ovsrpro
cmake --build .
cpack -G STGZ
```

Refer to the [cmake(1)](https://cmake.org/cmake/help/latest/manual/cmake.1.html) and [cpack(1)](https://cmake.org/cmake/help/latest/manual/cpack.1.html) documentation for more options.
See the [externpro documentation](https://github.com/distributePro/externpro/blob/master/README.md) for available CMake options.
In addition, there are a few undocumented options which you might find useful.

| Option | Type | Default | Description |
|:---|:---|:---|:---|
| `XP_BUILD_DEBUG` | boolean | `true` | Build debug versions of the projects. Note that release versions are always built. |
| `XP_DEFAULT` | boolean | `true` | Build all the ovsrpro projects. If you disable this option, you can enable individual projects with their `XP_PRO_<project>` options. |
| `XP_MARKPARTIAL` | boolean | `true` | Add "-p" to the ovsrpro project files, such as the installation package. This only occurs if some projects are excluded from the build. |
| `XP_PRO_<projct>` | boolean | `false` | Configure and build the \<project\> project. If `XP_DEFAULT` is enabled, these options are ignored. |
