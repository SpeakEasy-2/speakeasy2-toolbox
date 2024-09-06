matlab_add_mex(
  NAME mexSE2
  MODULE
  SRC SpeakEasy2.c
  LINK_TO SpeakEasy2 mxIgraph R2018a)

target_include_directories(mexSE2 PRIVATE ${Matlab_INCLUDE_DIRS})

matlab_add_mex(
  NAME mexOrder
  MODULE
  SRC order.c
  LINK_TO SpeakEasy2 mxIgraph R2018a)

target_include_directories(mexOrder PRIVATE ${Matlab_INCLUDE_DIRS})

matlab_add_mex(
  NAME mexKnn
  MODULE
  SRC knn_graph.c
  LINK_TO SpeakEasy2 mxIgraph R2018a)

target_include_directories(mexKnn PRIVATE ${Matlab_INCLUDE_DIRS})

matlab_add_mex(
  NAME mexVersion
  MODULE
  SRC version.c
  LINK_TO SpeakEasy2 R2018a)

target_include_directories(mexVersion PRIVATE ${Matlab_INCLUDE_DIRS})
