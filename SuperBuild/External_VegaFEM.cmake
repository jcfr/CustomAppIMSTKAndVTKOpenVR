
set(proj VegaFEM)

# Set dependency list
set(${proj}_DEPENDENCIES "")
if(WIN32)
  list(APPEND ${proj}_DEPENDENCIES PThreads)
endif()

# Sanity checks
if(DEFINED ${proj}_DIR AND NOT EXISTS ${${proj}_DIR})
  message(FATAL_ERROR "${proj}_DIR variable is defined but corresponds to nonexistent directory")
endif()

if(Slicer_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling Slicer_USE_SYSTEM_${proj} is not supported !")
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(NOT DEFINED ${proj}_DIR
   AND NOT Slicer_USE_SYSTEM_${proj})

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
  set(EP_INSTALL_DIR ${CMAKE_BINARY_DIR}/${proj}-install)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    URL https://gitlab.kitware.com/iMSTK/vegafemv4.0/-/archive/build_model_reduction/vegafemv4.0-build_model_reduction.zip
    URL_MD5 3f04bb7c2ba080785bcadf44d1a462a3
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
      -DCMAKE_CXX_EXTENSIONS:BOOL=${CMAKE_CXX_EXTENSIONS}
      -DVegaFEM_ENABLE_PTHREADS_SUPPORT:BOOL=ON
      -DVegaFEM_ENABLE_OpenGL_SUPPORT:BOOL=OFF
      -DVegaFEM_BUILD_MODEL_REDUCTION:BOOL=OFF # See corresponding option in Exteral_iMSTK.cmake
      -DVegaFEM_BUILD_UTILITIES:BOOL=OFF
      -DCMAKE_INSTALL_PREFIX:PATH=${EP_INSTALL_DIR}
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

  # TODO: ExternalProject_GenerateProjectDescription_Step

  set(${proj}_DIR ${EP_INSTALL_DIR}/lib/cmake/VegaFEM)

  #-----------------------------------------------------------------------------
  # Launcher setting specific to build tree

  # NA

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

ExternalProject_Message(${proj} "${proj}_DIR:${${proj}_DIR}")

mark_as_superbuild(
  VARS
    ${proj}_DIR:PATH
  PROJECTS
    iMSTK
  )

