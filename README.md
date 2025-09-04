# cmake-common

CMake common settings used by other C/C++ projects.

## Usage

In your project directory:

```sh
git submodule add git@github.com:lasyard/cmake-common.git
```

Then add the following line in the `CMakeLists.txt`:

```cmake
include(cmake-common/functions.cmake)
```
