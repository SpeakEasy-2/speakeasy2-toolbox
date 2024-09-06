function g = knnGraph(mat, k, isweighted, graphOpts)
%KNNGRAPH calculate k-nearest neighbors graph
%   GRAPH = KNNGRAPH(MAT, K) use euclidean distance to determine the pairwise
%   distance between columns and return a graph with K edges starting from each
%   column and going to the closest K other columns.
%
%   GRAPH = KNNGRAPH(MAT, K, ISWEIGHTED) if ISWEIGHTED is true the returned
%   graph will be weighted by the inverse of the euclidean distances between
%   connected columns. (ISWEIGHTED default is false.)
%
%   GRAPH = KNNGRAPH(MAT, K, 'PARAM1', VAL1, 'PARAM2', VAL2, ...) igraph graph
%   out options can be provided to modified the returned graph. Can supply a
%   representation with the 'repr' name, a datatype with the 'dtype' name, and
%   a weight attribute name to store the weights in the case ISWEIGHTED is true
%   and 'repr' is 'graph'.
%
%   KNN-graphs can be useful for pre-processing columns of data to be used in a
%   graph clustering algorithm.
%
%   See also SPEAKEASY2.

    arguments
       mat (:, :) double;
       k (1, 1) {mustBeInteger, mustBeNonnegative};
       isweighted (1, 1) logical = false;
       graphOpts.?igutils.GraphOutProps;
    end

    graphOpts = namedargs2cell(graphOpts);
    graphOpts = igutils.setGraphOutProps(graphOpts{:});

    g = mexKnn(mat, k, isweighted, graphOpts);
end
