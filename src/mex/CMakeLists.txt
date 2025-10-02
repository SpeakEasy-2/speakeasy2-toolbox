file(GLOB src_files CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/*.c)

foreach(src_file ${src_files})
  get_filename_component(src_name ${src_file} NAME_WE)
  matlab_add_mex(
    NAME ${src_name}
    MODULE
    SRC ${src_file} NO_IMPLICIT_LINK_TO_MATLAB_LIBRARIES
    LINK_TO SpeakEasy2 mxIgraph ${Matlab_MEX_LIBRARY} ${Matlab_MX_LIBRARY}
    R2018a)

  target_include_directories(${src_name} PRIVATE ${Matlab_INCLUDE_DIRS})
endforeach()
