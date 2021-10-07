
set(proj Assimp)

# Set dependency list
set(${proj}_DEPENDENCIES "")

# Sanity checks
if(DEFINED ${proj}_ROOT_DIR AND NOT EXISTS ${${proj}_ROOT_DIR})
  message(FATAL_ERROR "${proj}_ROOT_DIR variable is defined but corresponds to nonexistent directory")
endif()

if(Slicer_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling Slicer_USE_SYSTEM_${proj} is not supported !")
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if((NOT DEFINED ${proj}_ROOT_DIR
   OR NOT DEFINED ${proj}_LIB_DIR) AND NOT Slicer_USE_SYSTEM_${proj})

  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj})
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
  set(EP_INSTALL_DIR ${CMAKE_BINARY_DIR}/${proj}-install)

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    URL https://gitlab.kitware.com/iMSTK/assimp/-/archive/fixCompilationError/assimp-fixCompilationError.zip
    URL_MD5 fab081af9dbd73a9a5c61cd33dd93340
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
    SOURCE_DIR ${EP_SOURCE_DIR}
    BINARY_DIR ${EP_BINARY_DIR}
    CMAKE_CACHE_ARGS
      -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
      -DASSIMP_BUILD_ASSIMP_TOOLS:BOOL=OFF
      -DASSIMP_BUILD_TESTS:BOOL=OFF
      -DASSIMP_NO_EXPORT:BOOL=ON
      -DLIBRARY_SUFFIX:STRING=
      -DCMAKE_INSTALL_PREFIX:PATH=${EP_INSTALL_DIR}
    INSTALL_DIR ${EP_INSTALL_DIR}
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

  # TODO: ExternalProject_GenerateProjectDescription_Step

  set(${proj}_ROOT_DIR ${EP_INSTALL_DIR})
  set(${proj}_LIB_DIR "lib")

  #-----------------------------------------------------------------------------
  # Launcher setting specific to build tree

  # NA

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

ExternalProject_Message(${proj} "${proj}_ROOT_DIR:${${proj}_ROOT_DIR}")
ExternalProject_Message(${proj} "${proj}_LIB_DIR:${${proj}_LIB_DIR}")

mark_as_superbuild(
  VARS
    ${proj}_ROOT_DIR:PATH
    ${proj}_LIB_DIR:STRING
  PROJECTS
    iMSTK
  )

