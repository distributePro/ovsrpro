# ovsrpro

Build Overseer [dependencies](projects/README.md) by leveraging
[externpro](https://github.com/smanders/externpro).

## Installing ovsrpro

1. Download the installer for the release you need, for the your development
   environment (OS, compiler, etc). See
   <https://github.com/distributePro/ovsrpro/releases>.
1. Download the SHA256 checksum file for your release.
1. Validate the checksum.
   ```bash
   sha256sum --check ovsrpro-18.10.1-gcc631-64-Linux.sh.sha256
   ```
1. Run the installer.
   ```bash
   sudo ./ovsrpro-18.10.1-gcc631-64-Linux.sh --prefix=/opt/extern/ --include-subdir
   ```
   The recommended location for installation is */opt/ovsrpro/*. We also
   recommend using the subdirectory. Both these options are in this example.

## Using ovsrpro

Copy the file *share/cmake/Findovsrpro.cmake* from your installation to your
project's root directory. In your *CMakeLists.txt* add these lines:

```cmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}")
find_package(ovsrpro 18.10.1 EXACT REQUIRED)
```

A few notes about the `find_package()` command:

1. The version is required in the command.
1. `EXACT` is required. If it's omitted, it is forced by *Findovsrpro.cmake*
   and a warning is issued.

If ovsrpro is found, *share/cmake* is appended to `CMAKE_MODULE_PATH`
automatically. To find ovsrpro projects, add `find_package()` commands. The
project names must all be prefixed with "Ovsrpro".

```cmake
find_package(OvsrproQt)
find_package(OvsrproLibrdkafka)
find_package(OvsrproZooKeeper)
```

If projects are found, imported targets are available. If a project supports
imported targets natively, those same targets will be available. For example, if
you search for the Qt5 Core module, you will have the imported target
`Qt5::Core`.

```cmake
find_package(OvsrproQt COMPONENTS Core)
add_executable(AnApplication AnApplication.cpp)
target_link_libraries(AnApplication PRIVATE Qt5::Core)
```

If a project does not natively support imported targets, an imported target with
the name `ovsrpro::<project>` will be available, with "project" in all
lowercase.

```cmake
find_package(OvsrproZooKeeper)
add_executable(AnApplication)
target_link_libraries(AnApplication PRIVATE ovsrpro::zookeeper)
```

This table lists the details for the various projects.

| Project | Package Name | Targets |
|:---|:---|:---|:---|
| CppZmq | OvsrproCppZmq | cppzmq::cppzmq |
| HDF5 | OvsrproHdf5 | hdf5::c |
| | | hdf5::cxx |
| | | hdf5::hl |
| | | hdf5::hl_cxx |
| | | hdf5::tools |
| librdkafka | OvsrproLibrdkafka | librdkafka::c |
| | | librdkafka::cxx |
| ZeroMQ | OvsrproZeroMQ | zeromq::zeromq |

## Building ovsrpro

Developers should install an available package. If a package does not exist for
your system, use these instructions to build your own package.

### externpro

First, install [externpro](https://github.com/smanders/externpro). You must
install [version 18.8.4](https://github.com/smanders/externpro/releases/tag/18.08.4)
Use the same installation instructions as for ovsrpro, just substitute externpro
for ovsrpro.

### Building the Projects

1. Clone the repository.
1. In the repository, checkout the version you wish to build.
1. Create a build directory.
1. In the build directory, run CMake.
1. In the build directory, build the projects.
1. In the build directory, create an installation package.

```bash
cd ~/repositories/ovsrpro
git clone git://github.com/distributePro/ovsrpro.git
cd ovsrpro
git checkout 20.04.1
mkdir -p ~/repositories/ovsrpro/release
cd ../release
cmake -D XP_STEP=build ../ovsrpro
cmake --build .
cpack
```

Now, you can install your package, using the instructions above.

### CMake Options

For custom builds, the following CMake options are available:

<!-- markdownlint-disable MD013 -->
| Option | Default | Description |
|:---|:---|:---|
| `XP_BUILD_DEBUG` | `on` | Build debug versions of the projects. Note that release versions are always built. |
| `XP_DEFAULT` | `on` | Compiles all of the available packages. To only compile a subset of the packages, set `XP_DEFAULT=off` and specify the individual packages desired. This is easier to do using cmake-gui or ccmake. |
| `XP_STEP` | `patch` | Specify which steps to complete of the build process. See the [externpro documentation](https://github.com/smanders/externpro/blob/master/README.md) for available options. |
<!-- markdownlint-enable MD013 -->
