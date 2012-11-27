function(get_android_flags)
  
  set(MIR_NDK_PATH $ENV{MIR_NDK_PATH})
  
  #build flags for finding things in the sysroot
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} --sysroot=${MIR_NDK_PATH}/sysroot")
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} -isystem ${MID_NDK_PATH}/lib/gcc/arm-linux-androideabi/4.6.x-google/include-fixed")
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} -isystem ${MIR_NDK_PATH}/sysroot/usr/include")
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} -isystem ${MIR_NDK_PATH}/include/c++")
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} -isystem ${MIR_NDK_PATH}/include/c++/arm-linux-androideabi/armv7-a")

  #note: this has to go away before landing. works around a STL header problem
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS} -fpermissive")
  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS}  -msoft-float -fpic -ffunction-sections -fdata-sections -funwind-tables -fstack-protector -Wa,--noexecstack -Werror=format-security -fgcse-after-reload -frerun-cse-after-loop -frename-registers")

  set( ANDROID_CXX_FLAGS "${ANDROID_CXX_FLAGS}" PARENT_SCOPE)

  #compile definitions
  set( ANDROID_DEFINITIONS 
    -D_GLIBCXX_HAS_GTHREADS;
    -D_GLIBCXX_USE_C99_STDINT_TR1;
    -DHAVE_ANDROID_OS=1;
    -D_GLIBCXX_USE_SCHED_YIELD;
    -DHAVE_FUTEX; 
    -DHAVE_FUTEX_WRAPPERS=1; 
    -DHAVE_FORKEXEC; 
    -DHAVE_OOM_ADJ; 
    -DHAVE_ANDROID_IPC; 
    -DHAVE_POSIX_FILEMAP; 
    -DHAVE_TERMIO_H; 
    -DHAVE_SYS_UIO_H; 
    -DHAVE_SYMLINKS; 
    -DHAVE_IOCTL; 
    -DHAVE_POSIX_CLOCKS; 
    -DHAVE_TIMEDWAIT_MONOTONIC; 
    -DHAVE_EPOLL; 
    -DHAVE_ENDIAN_H; 
    -DHAVE_LITTLE_ENDIAN; 
    -DHAVE_BACKTRACE=0; 
    -DHAVE_DLADDR=0; 
    -DHAVE_CXXABI=0; 
    -DHAVE_SCHED_SETSCHEDULER; 
    -D__linux__; 
    -DHAVE_MALLOC_H; 
    -DHAVE_LINUX_LOCAL_SOCKET_NAMESPACE=1; 
    -DHAVE_INOTIFY=1; 
    -DHAVE_MADVISE=1; 
    -DHAVE_TM_GMTOFF=1; 
    -DHAVE_DIRENT_D_TYPE=1; 
    -DARCH_ARM; 
    -DOS_SHARED_LIB_FORMAT_STR="lib%s.so"; 
    -DHAVE__MEMCMP16=1; 
    -DMINCORE_POINTER_TYPE="unsigned char *"; 
    -DHAVE_SA_NOCLDWAIT; 
    -DOS_PATH_SEPARATOR='/';
    -DOS_CASE_SENSITIVE; 
    -DHAVE_SYS_SOCKET_H=1; 
    -DHAVE_PRCTL=1; 
    -DHAVE_WRITEV=1 ;
    -DHAVE_STDINT_H=1 ;
    -DHAVE_STDBOOL_H=1 ;
    -DHAVE_SCHED_H=1 ;
    -D__STDC_INT64__;
    -DANDROID_SMP;
  
    -DANDROID;
    -DGTEST_OS_LINUX_ANDROID;
    -DGTEST_HAS_CLONE=0;
    -DGTEST_HAS_POSIX_RE=0
  
    PARENT_SCOPE
    )

  set(EABI "arm-linux-androideabi")
  set(ANDROID_LINKER_XSC_SCRIPT "${MIR_NDK_PATH}/${EABI}/lib/ldscripts/armelf_linux_eabi.xsc")
  set(ANDROID_LINKER_X_SCRIPT "${MIR_NDK_PATH}/${EABI}/lib/ldscripts/armelf_linux_eabi.x")
  set(ANDROID_SO_CRTBEGIN "${MIR_NDK_PATH}/sysroot/usr/lib/crtbegin_so.o")
  set(ANDROID_SO_CRTEND "${MIR_NDK_PATH}/sysroot/usr/lib/crtend_so.o")
  set(ANDROID_SO_GCC "${MIR_NDK_PATH}/lib/gcc/${EABI}/4.6.x-google/libgcc.a")
  set(ANDROID_CRTBEGIN_DYNAMIC "${MIR_NDK_PATH}/sysroot/usr/lib/crtbegin_dynamic.o")
  set(ANDROID_CRTEND_ANDROID "${MIR_NDK_PATH}/sysroot/usr/lib/crtend_android.o")
  set(ANDROID_STDLIB_STRING "-Wl,-Bstatic -lsupc++ -Wl,-Bdynamic -lc -lstdc++ -lm") 
  set(ANDROID_STDGCC_STRING "-Wl,-Bstatic -lgcc") 

  # common linker flags
  set(ANDROID_LINKER_FLAGS "-Wl,-rpath,${MIR_NDK_PATH}/sysroot/usr/lib:${MIR_NDK_PATH}/${EABI}/lib" PARENT_SCOPE)

  #setup shared_object file generation 
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -nostdlib")  
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,-T,${ANDROID_LINKER_XSC_SCRIPT}")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,--gc-sections")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,-z,noexecstack")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,--icf=safe")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,--fix-cortex-a8")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS} -Wl,--no-undefined")
  set(ANDROID_SO_LINKER_FLAGS "${ANDROID_SO_LINKER_FLAGS}" PARENT_SCOPE)
  string(REGEX REPLACE
    "<LINK_LIBRARIES>"
    "${ANDROID_SO_CRTBEGIN} <LINK_LIBRARIES> ${ANDROID_STDLIB_STRING} ${ANDROID_STDGCC_STRING} ${ANDROID_SO_CRTEND}"
    CMAKE_CXX_CREATE_SHARED_LIBRARY
    "${CMAKE_CXX_CREATE_SHARED_LIBRARY}")
  set(CMAKE_CXX_CREATE_SHARED_LIBRARY ${CMAKE_CXX_CREATE_SHARED_LIBRARY} PARENT_SCOPE)

  #setup executable file generation 
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -nostdlib")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,-T,${ANDROID_LINKER_X_SCRIPT}")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,-dynamic-linker,/system/bin/linker")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,--gc-sections")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,-z,nocopyreloc")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,-z,noexecstack")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,--icf=safe")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS} -Wl,--fix-cortex-a8")
  set(ANDROID_EXE_LINKER_FLAGS "${ANDROID_EXE_LINKER_FLAGS}" PARENT_SCOPE)
  string(REGEX REPLACE
    "<OBJECTS>"
    "${ANDROID_CRTBEGIN_DYNAMIC} <OBJECTS> ${ANDROID_STDLIB_STRING}"  
    CMAKE_CXX_LINK_EXECUTABLE
    "${CMAKE_CXX_LINK_EXECUTABLE}")
  string(REGEX REPLACE
    "<LINK_LIBRARIES>"
    "<LINK_LIBRARIES> ${ANDROID_STDLIB_STRING} ${ANDROID_STDGCC_STRING} ${ANDROID_CRTEND_ANDROID}"
    CMAKE_CXX_LINK_EXECUTABLE
    "${CMAKE_CXX_LINK_EXECUTABLE}")
  set(CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_CXX_LINK_EXECUTABLE} PARENT_SCOPE)

endfunction(get_android_flags)
