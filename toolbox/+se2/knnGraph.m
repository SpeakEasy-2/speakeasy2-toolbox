function g = knnGraph(mat, k, isWeighted)
%KNNGRAPH calculate k-nearest neighbors graph
%   GRAPH = KNNGRAPH(MAT, K) use euclidean distance to determine the pairwise
%   distance between columns and return a graph with K edges starting from each
%   column and going to the closest K other columns.
%
%   GRAPH = KNNGRAPH(MAT, K, ISWEIGHTED) if ISWEIGHTED is true the returned
%   graph will be weighted by the inverse of the euclidean distances between
%   connected columns. (ISWEIGHTED default is false.)
%
%   KNN-graphs can be useful for pre-processing columns of data to be used in a
%   graph clustering algorithm.
%
%   See also SPEAKEASY2.

    arguments
       mat (:, :) double;
       k (1, 1) {mustBeInteger, mustBeNonnegative};
       isWeighted (1, 1) logical = false;
    end

    adjOptions = struct('makeSparse', true, 'dtype', 'double');
    g = mexKnn(mat, k, isWeighted, adjOptions);
end
