if(NOT CMAKE_TOOLCHAIN_FILE)
  message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE required for android. See ${CMAKE_SOURCE_DIR}/cmake/README.md")
elseif(NOT SDK_PLATFORM)
  message(FATAL_ERROR "Toolchain did not define SDK_PLATFORM. Possibly outdated depends.")
endif()

set(ARCH_DEFINES -DTARGET_POSIX -DTARGET_LINUX -D_LINUX -DTARGET_ANDROID)
set(SYSTEM_DEFINES -D__STDC_CONSTANT_MACROS -D_LARGEFILE64_SOURCE
                   -D_FILE_OFFSET_BITS=64 -D__USE_FILE_OFFSET64=1)

# Main cpp
set(CORE_MAIN_SOURCE ${CMAKE_SOURCE_DIR}/xbmc/platform/android/activity/XBMCApp.cpp)

set(PLATFORM_DIR linux)
if(WITH_ARCH)
  set(ARCH ${WITH_ARCH})
else()
  if(CPU STREQUAL armeabi-v7a)
    set(ARCH arm)
    set(NEON True)
    set(NEON_FLAGS "-mfpu=neon -mvectorize-with-neon-quad")
  elseif(CPU STREQUAL arm64-v8a)
    set(ARCH aarch64)
    set(NEON True)
  elseif(CPU STREQUAL i686)
    set(ARCH i486-linux)
    set(NEON False)
  else()
    message(SEND_ERROR "Unknown CPU: ${CPU}")
  endif()
endif()

set(ENABLE_X11 OFF CACHE BOOL "" FORCE)
set(ENABLE_AML OFF CACHE BOOL "" FORCE)
set(ENABLE_OPTICAL OFF CACHE BOOL "" FORCE)
set(ENABLE_MDNS OFF CACHE BOOL "" FORCE)

list(APPEND DEPLIBS android log jnigraphics mediandk androidjni)
