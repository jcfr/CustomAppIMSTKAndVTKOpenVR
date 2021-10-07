set(proj iMSTK)

# Set dependency list
set(${proj}_DEPENDS
  Assimp
  g3log
  LibNiFalcon
  Libusb
  OpenVR
  tbb
  VegaFEM
  VTK
  )

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj)

if(${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED ${proj}_DIR AND NOT EXISTS ${${proj}_DIR})
  message(FATAL_ERROR "${proj}_DIR [${${proj}_DIR}] variable is defined but corresponds to nonexistent directory")
endif()

if(NOT DEFINED ${proj}_DIR AND NOT ${SUPERBUILD_TOPLEVEL_PROJECT}_USE_SYSTEM_${proj})

  ExternalProject_SetIfNotDefined(
    ${SUPERBUILD_TOPLEVEL_PROJECT}_${proj}_GIT_REPOSITORY
    "${EP_GIT_PROTOCOL}://github.com/jcfr/iMSTK"
    QUIET
    )

  ExternalProject_SetIfNotDefined(
    ${SUPERBUILD_TOPLEVEL_PROJECT}_${proj}_GIT_TAG
    "19510a7b9d848aecf7b8275ef5cd721a19868e28" # update-build-system-to-streamline-application-integration
    QUIET
    )

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    GIT_REPOSITORY "${${SUPERBUILD_TOPLEVEL_PROJECT}_${proj}_GIT_REPOSITORY}"
    GIT_TAG "${${SUPERBUILD_TOPLEVEL_PROJECT}_${proj}_GIT_TAG}"
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      # Compiler settings
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
      -DCMAKE_CXX_EXTENSIONS:BOOL=${CMAKE_CXX_EXTENSIONS}
      # Output directories
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${EP_BINARY_DIR}/bin
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${EP_BINARY_DIR}/lib
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${EP_BINARY_DIR}/lib
      # Options
      -DiMSTK_SUPERBUILD:BOOL=OFF
      -DiMSTK_BUILD_TESTING:BOOL=OFF
      -DiMSTK_BUILD_EXAMPLES:BOOL=OFF
      -DiMSTK_USE_MODEL_REDUCTION:BOOL=OFF
      # Dependencies
      -DVTK_DIR:PATH=${VTK_DIR}
      -Dtbb_ROOT_DIR:PATH=${TBB_INSTALL_DIR}/tbb${tbb_ver}
      -Dtbb_LIB_DIR:STRING=${tbb_libdir}
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDS}
    )
  set(${proj}_DIR ${${proj}_BINARY_DIR}/InnerBuild)
  mark_as_superbuild(${proj}_DIR)

  # library paths
  # \todo: <CMAKE_CFG_INTDIR doesn't work for now. Just add the types manually
  # See: https://issues.slicer.org/view.php?id=4682
  set(${proj}_LIBRARY_PATHS_LAUNCHER_BUILD
    ${${proj}_RUNTIME_OUTPUT_DIRECTORY}/Debug
    ${${proj}_RUNTIME_OUTPUT_DIRECTORY}/MinSizeRel
    ${${proj}_RUNTIME_OUTPUT_DIRECTORY}/RelWithDebInfo
    ${${proj}_RUNTIME_OUTPUT_DIRECTORY}/Release)
  mark_as_superbuild(
    VARS ${proj}_LIBRARY_PATHS_LAUNCHER_BUILD
    LABELS "LIBRARY_PATHS_LAUNCHER_BUILD"
  )

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDS})
endif()

mark_as_superbuild(${proj}_DIR:PATH)

