classdef TestInputs < matlab.unittest.TestCase
% Tests the SpeakEasy 2 clustering algorithm returns community structure
% similar to the ground truth communities when dealing with simple, well
% structured graphs. Intended to verify that 1. the algorithm runs successful
% on different types (i.e. without crashing) and 2. the results are not
% terrible (i.e. we want to check changes to the algorithm haven't completely
% messed it up).

    properties
        graph;
        expected;
        seed = 555;
        sizes = [20 10 15 5 10 15 5 20];
        mu = 0.2;
    end

    properties (ClassSetupParameter)
        repr = igutils.representations();
        dtype = igutils.datatypes();
        isweighted = {true, false};
    end

    methods (TestClassSetup)
        function graphSetup(testCase, repr, dtype, isweighted)
            rng(testCase.seed);
            [testCase.graph, testCase.expected] = ...
                blockAdj(testCase.sizes, testCase.mu, repr, dtype, isweighted);
        end
    end

    methods (Test, TestTags = {'Unit'})
        function testClustering(testCase, repr, dtype, isweighted)
            actual = se2.cluster(testCase.graph, ...
                                 verbose=false, ...
                                 seed=randi([1, 1000]));
            nmi = igraph.compare(actual, testCase.expected, 'nmi');
            testCase.verifyGreaterThan(nmi, 0.9);
        end
    end
end
