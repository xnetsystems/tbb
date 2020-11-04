vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO oneapi-src/oneTBB
  REF v2021.1-beta10
  SHA512 d5c67ea5b494d7580771e44adea736c369358dfa99c8a1cdda6d190663f17e675d45503fb7d4ffb207aea28c8ead462b857bded0c5645c201df4c361de9bf09a
  HEAD_REF onetbb_2021
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/TBBConfig.cmake.in DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS_DEBUG
    -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/TBB)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
