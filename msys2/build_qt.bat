#echo off

rem Make sure run this script a visual studio 2017 command prompt.

rem Configure.
configure -opensource

rem Set env variable to build in parallel over multiple cores.
set CL=/MP

rem Build.
nmake

