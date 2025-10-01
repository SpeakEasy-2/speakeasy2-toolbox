file(GLOB tests CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/*.m)

foreach(test_file ${tests})
  get_filename_component(test_name ${test_file} NAME_WE)
  matlab_add_unit_test(
    NAME
    ${test_name}
    UNITTEST_FILE
    ${test_file}
    CUSTOM_TEST_COMMAND
    "run(runner, suite), exit(max([ans(1, :).Failed]))"
    UNITTEST_PRECOMMAND
    "import matlab.unittest.plugins.XMLPlugin; suite = testsuite('${test_name}'); runner = testrunner('textoutput'); xmlFile = '${CMAKE_CURRENT_BINARY_DIR}/test_${test_name}_results.xml'; p = XMLPlugin.producingJUnitFormat(xmlFile); addPlugin(runner, p);"
    ADDITIONAL_PATH
    ${PROJECT_SOURCE_DIR}/toolbox
    ${PROJECT_BINARY_DIR}/mex)
endforeach()
