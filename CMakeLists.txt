cmake_minimum_required(VERSION 3.6)


##### プロジェクト固有の設定 #####
# プロジェクト名の設定
set(PROJECT_NAME "HelloOpenCL")

# 言語の設定 (CXX/C)
set(LANG "C")

# 追加パッケージの設定
set(USE_OPENCL TRUE)
set(USE_CUDA FALSE)
set(USE_OPENCV FALSE)

# デバッグの設定
set(DBG_ARGS "../HelloOpenCL/hello.cl")
set(DBG_DEBUGGER "WindowsLocalDebugger")
set(DBG_ENV "")

# ソースの設定
add_executable(${PROJECT_NAME}
  ./${PROJECT_NAME}/hello.c
)


##### プロジェクト共通設定 #####
# ソリューションファイル名の指定
project(${PROJECT_NAME})

# スタートアッププロジェクトの設定（3.6以降）
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})

# デバッグ設定ファイルの生成
if (MSVC)
set(FILE_DATA [=[
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="REPLACE_MSVC_VERSION" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <LocalDebuggerCommandArguments>REPLACE_DBG_ARGS</LocalDebuggerCommandArguments>
    <DebuggerFlavor>REPLACE_DBG_DEBUGGER</DebuggerFlavor>
    <LocalDebuggerEnvironment>REPLACE_DBG_ENV</LocalDebuggerEnvironment>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <LocalDebuggerCommandArguments>REPLACE_DBG_ARGS</LocalDebuggerCommandArguments>
    <DebuggerFlavor>REPLACE_DBG_DEBUGGER</DebuggerFlavor>
    <LocalDebuggerEnvironment>REPLACE_DBG_ENV</LocalDebuggerEnvironment>
  </PropertyGroup>
</Project>
]=])
string(REGEX REPLACE "REPLACE_MSVC_VERSION" "${MSVC_VERSION}" FILE_DATA "${FILE_DATA}")
string(REGEX REPLACE "REPLACE_DBG_ARGS" "${DBG_ARGS}" FILE_DATA "${FILE_DATA}")
string(REGEX REPLACE "REPLACE_DBG_DEBUGGER" "${DBG_DEBUGGER}" FILE_DATA "${FILE_DATA}")
string(REGEX REPLACE "REPLACE_DBG_ENV" "${DBG_ENV}" FILE_DATA "${FILE_DATA}")
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.vcxproj.user" "${FILE_DATA}")
endif (MSVC)

# 言語の指定
enable_language(${LANG})

# コンパイラバージョンの設定
if (${LANG} STREQUAL "C")
  set(CMAKE_C_STANDARD 11)    # for C
elseif (${LANG} STREQUAL "CXX")
  set(CMAKE_CXX_STANDARD 11)  # for C++
else ()
endif ()

# コンパイルオプションの指定
if (${LANG} STREQUAL "C")       # for C
  if (MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /TC /W4")
  elseif (GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
  else ()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
  endif ()
elseif (${LANG} STREQUAL "CXX") # for C++
  if (MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /TP /W4 /EHsc")
  elseif (GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
  else ()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
  endif ()
else ()
endif ()

# パッケージの検索
if ((DEFINED USE_OPENCL) AND (${USE_OPENCL}))
  find_package(OpenCL REQUIRED)
endif ()
if ((DEFINED USE_CUDA) AND (${USE_CUDA}))
  find_package(CUDA REQUIRED)
endif ()
if ((DEFINED USE_OPENCV) AND (${USE_OPENCV}))
  find_package(OpenCV REQUIRED)
endif ()

# パッケージの追加
if ((DEFINED USE_OPENCL) AND (OpenCL_FOUND))  # OpenCL
  # メッセージの出力
  message("OpenCL headers and libraries added.")
  # インクルードパスの追加
  include_directories(${OpenCL_INCLUDE_DIRS})
  # リンクターゲットの追加
  target_link_libraries(${PROJECT_NAME} ${OpenCL_LIBRARIES})
endif ()
if ((DEFINED USE_CUDA) AND (CUDA_FOUND))      # CUDA
  # メッセージの出力
  message("CUDA headers and libraries added.")
  # インクルードパスの追加
  include_directories(${CUDA_INCLUDE_DIRS})
  # リンクターゲットの追加
  target_link_libraries(${PROJECT_NAME} ${CUDA_LIBRARIES})
endif ()
if ((DEFINED USE_OPENCV) AND (OpenCV_FOUND))  # OpenCV
  # メッセージの出力
  message("OpenCV headers and libraries added.")
  # インクルードパスの追加
  include_directories(${OpenCV_INCLUDE_DIRS})
  # リンクターゲットの追加
  target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})
endif ()

# その他インクルードパスの追加
include_directories(
)

# その他リンクターゲットの追加
target_link_libraries(${PROJECT_NAME}
)
