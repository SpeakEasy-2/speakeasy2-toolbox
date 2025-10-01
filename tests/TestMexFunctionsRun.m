classdef TestMexFunctionsRun < matlab.unittest.TestCase
% Set of tests to verify MEX functions can be run on all expected data types
% without crashing. Only checks that the function completes, not whether it
% gives correct results.

    properties
        seed = 4839;
    end

    properties (TestParameter)
        repr = igutils.representations();
        dtype = igutils.datatypes();
        isweighted = {true, false};
    end

    methods (Test, TestTags = {'Unit'})
        function testKNNGraph(testCase, isweighted)
            rng(testCase.seed);
            mat = randn(100);
            graph = se2.knnGraph(mat, 5, isweighted);
            se2.cluster(graph, independentRuns=2, seed=randi([0, 1000]));

            testCase.verifyTrue(true);
        end

        function testOrederNodes(testCase, repr, dtype, isweighted)
            rng(testCase.seed);
            se2Seed = randi([0, 1000]);
            sizes = randi([4, 10], [1, 8]);
            graph = blockAdj(sizes, 0.1, repr, dtype, isweighted);
            memb = se2.cluster(graph, independentRuns=2, seed=se2Seed);
            se2.order(graph, memb);

            testCase.verifyTrue(true);
        end
    end
end
