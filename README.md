# devscripts
Scripts to bring up a msys2 bash shell for building on the windows platform.
The scripts automatically set environment variables to find visual studio compilers, cmake, git, ninja, jom, ant, and more.
The scripts contain variables which should be adjusted to reflect your environment.

Although these scripts target building for the windows x64 platform, other platforms can be targetted in the following ways.
- Use CMake and toolchain files to specify the exact cross compilers for the other platform.
- Modify the setup_env.sh to specify the exact cross compiler or include other bash scripts.

We recommend using CMake and toolchain files to target other platforms like android, winrt, and webassembly (emscripten).
