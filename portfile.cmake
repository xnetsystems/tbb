vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO intel/tbb
  REF v2020.2
  SHA512 b9a5d0e814ebd2e69690585bcfb5a545c06f030e193154bef161ac59066044109f8a0305a9ba535c447739da3380c351067db19c38de4bf96ec742b044f39885
  HEAD_REF tbb_2020.2
  PATCHES
    fix-comparison-operator.patch
    fix-static-build.patch
    fix-warnings.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/TBBConfig.cmake.in DESTINATION ${SOURCE_PATH})

set(WITH_PSTL OFF)
if(pstl IN_LIST FEATURES)
  set(WITH_PSTL ON)
endif()

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS
    -DWITH_PSTL=${WITH_PSTL}
  OPTIONS_DEBUG
    -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/TBB)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
