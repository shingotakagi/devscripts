@echo off 
rem - this prevents the remarks and commands from showing



rem - About this Script.
rem - ------------------------------------------------------------------------------------------
rem - This batch script brings up an initial msys2 shell, targeting Windows platform.
rem - The default is to build for 64 bit windows
rem - Other platforms (like android) will start with this shell as the kernel.
rem - The cmake toolchain file for these other platforms will strictly enforce which compilers get used.
rem - The other cmake files will adjust paths to libraries by switching on the ARCH variable.
rem - ------------------------------------------------------------------------------------------



rem - Create a windows shortcut to this script for fast startup.
rem - ------------------------------------------------------------------------------------------
rem - Enter the following as the target for your windows shortcut.
rem - The /c closes the first cmd shell. Use /k if you don't want to close the first shell.
rem - %comspec% /c ""E:\src\devscripts\msys2\launch_msys2.bat" "
rem - ------------------------------------------------------------------------------------------



rem - Adjust these local script variables to accomodate your environment.
rem - ------------------------------------------------------------------------------------------
rem - visual studio native 64 bit shell
rem - if you want to use the 32 bit compiler then use, x86
rem - if you want to use the 32 to 64 bit cross compiler, use x86_amd64
SET LLL_VS_SCRIPT="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64 
rem - msys2 install location
SET LLL_MSYS2_DIR="E:\installs\msys2"
rem - ------------------------------------------------------------------------------------------






rem - load visual studio environment variables
call %LLL_VS_SCRIPT%

rem - if there's no arguments we start an msys2 interactive shell
if "%1"=="" goto INTERACTIVE

rem - otherwise we run the script in the first argument instead of launching an interactive shell
%LLL_MSYS2_DIR%\usr\bin\bash.exe -f %1 %2
echo "Done building in msys2 environment";
goto DONE

:INTERACTIVE
rem - start msys2 shell 
rem - the -use-full-path makes the msys2 shell inherit the env vars from the windows command shell.
rem - we can also uncomment this line from msys2_shell.cmd --> *rem* set MSYS2_PATH_TYPE=inherit 
call %LLL_MSYS2_DIR%\msys2_shell.cmd -use-full-path

:DONE


