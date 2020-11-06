cmake_minimum_required(VERSION 3.14 FATAL_ERROR)
project(tbb VERSION 2021.1 LANGUAGES CXX)

# Sources
file(GLOB_RECURSE sources
  include/tbb/*.h)

list(APPEND sources
  src/tbb/allocator.cpp
  src/tbb/arena_slot.cpp
  src/tbb/arena.cpp
  src/tbb/concurrent_bounded_queue.cpp
  src/tbb/concurrent_monitor.cpp
  src/tbb/dynamic_link.cpp
  src/tbb/exception.cpp
  src/tbb/global_control.cpp
  src/tbb/governor.cpp
  src/tbb/itt_notify.cpp
  src/tbb/main.cpp
  src/tbb/market.cpp
  src/tbb/misc_ex.cpp
  src/tbb/misc.cpp
  src/tbb/observer_proxy.cpp
  src/tbb/parallel_pipeline.cpp
  src/tbb/private_server.cpp
  src/tbb/profiling.cpp
  src/tbb/queuing_rw_mutex.cpp
  src/tbb/rml_tbb.cpp
  src/tbb/rtm_mutex.cpp
  src/tbb/rtm_rw_mutex.cpp
  src/tbb/semaphore.cpp
  src/tbb/small_object_pool.cpp
  src/tbb/task_dispatcher.cpp
  src/tbb/task_group_context.cpp
  src/tbb/task.cpp
  src/tbb/version.cpp)

# Library
add_library(tbb ${sources})
target_compile_definitions(tbb PRIVATE __TBB_BUILD __TBB_USE_ITT_NOTIFY)
target_compile_definitions(tbb PUBLIC __TBB_NO_IMPLICIT_LINKAGE)
target_include_directories(tbb PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)

if(WIN32)
  set(TBB_DEF_FILE_PREFIX "win64")
else()
  set(TBB_DEF_FILE_PREFIX "lin64")
endif()

if(BUILD_SHARED_LIBS)
  target_sources(tbb PRIVATE
    src/tbb/def/${TBB_DEF_FILE_PREFIX}-tbb.def)
endif()

if(MSVC)
  target_compile_options(tbb PRIVATE /volatile:iso /wd4324 /wd4530 /wd4577)
else()
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GCC")
    target_compile_options(tbb PRIVATE -flifetime-dse=1)
  endif()
  target_compile_options(tbb PRIVATE -mrtm -Wno-parentheses)
  target_link_libraries(tbb PRIVATE dl)
endif()

# Dependencies
find_package(Threads REQUIRED)
target_link_libraries(tbb PRIVATE Threads::Threads)

# Install
install(TARGETS tbb EXPORT tbb
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)

install(EXPORT tbb FILE TBBTargets.cmake NAMESPACE TBB::
  DESTINATION lib/cmake/TBB)

include(CMakePackageConfigHelpers)
configure_package_config_file(TBBConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/TBBConfig.cmake
  INSTALL_DESTINATION lib/cmake/TBB)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/TBBConfig.cmake
  DESTINATION lib/cmake/TBB)

if(NOT SKIP_INSTALL_HEADERS)
  install(DIRECTORY include/tbb DESTINATION include FILES_MATCHING
    PATTERN "tbbmalloc_proxy.h" EXCLUDE
    PATTERN "*.h")
endif()
