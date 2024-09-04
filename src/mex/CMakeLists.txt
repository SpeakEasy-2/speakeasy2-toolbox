set(ut_lib "libut")
cmake_path(APPEND_STRING ut_lib ${CMAKE_SHARED_LIBRARY_SUFFIX})
set(Matlab_UT_LIBRARY ${Matlab_ROOT_DIR})
cmake_path(APPEND Matlab_UT_LIBRARY
	"bin" ${Matlab_ARCH} ${ut_lib})

matlab_add_mex(NAME mexSE2
  MODULE
  SRC SpeakEasy2.c
  LINK_TO SpeakEasy2 mxIgraph ${Matlab_UT_LIBRARY}
  R2018a
)

target_include_directories(mexSE2
  PRIVATE ${Matlab_INCLUDE_DIRS}
)

matlab_add_mex(NAME mexOrder
  MODULE
  SRC order.c
  LINK_TO SpeakEasy2 mxIgraph
  R2018a
)

target_include_directories(mexOrder
  PRIVATE ${Matlab_INCLUDE_DIRS}
)

matlab_add_mex(NAME mexKnn
  MODULE
  SRC knn_graph.c
  LINK_TO SpeakEasy2 mxIgraph
  R2018a
)

target_include_directories(mexKnn
  PRIVATE ${Matlab_INCLUDE_DIRS}
)

matlab_add_mex(NAME mexVersion
  MODULE
  SRC version.c
  LINK_TO SpeakEasy2
  R2018a
)

target_include_directories(mexVersion
  PRIVATE ${Matlab_INCLUDE_DIRS}
)

matlab_add_mex(NAME isdirected
  MODULE
  SRC isdirected.c
  LINK_TO mxIgraph SpeakEasy2
  R2018a
)

target_include_directories(isdirected
  PRIVATE ${Matlab_INCLUDE_DIRS}
)
