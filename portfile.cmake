vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO oneapi-src/oneTBB
  REF v2020.3
  SHA512 ea1ffd22c7234d715b8c46a4e51b40719c7a9b8837ab3166f1da5a2c6061167c2be2126b1d74fd361eec6975b8fce0df26829ca2e7af8029edbb52e40f23d630
  HEAD_REF tbb_2020
  PATCHES
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
