function [memb, ordering] = speakeasy2(graph, graphOpts, opts, attribute)
%SPEAKEASY2 community detection
%   MEMBERSHIP = SPEAKEASY2(GRAPH) Cluster the GRAPH.
%
%   [MEMB, ORDERING] = SPEAKEASY2(GRAPH) provide an index vector to order nodes
%   based on the community they are in, in order from largest community to
%   smallest. This can be used with HEATMAP or IMAGESC to help display
%   communities. Ordering can also be created with SE2.ORDER.
%
%   GRAPH = SPEAKEASY2(GRAPH, ..., 'result', NAME) if GRAPH can hold an
%   attribute (if represented by a MATLAB graph, default), the results are
%   attached to the graph as node attribute NAME.
%
%   MEMBERSHIP = SPEAKEASY2(G, 'PARAM1', VAL1, 'PARAM2', VAL2, ...) the
%   behavior of speakeasy2 can be modified through name-value pairs. Available
%   options are described in the table below.
%
%        Name              Description
%       ------------------------------------------------------------------
%        isdirected        Whether the graph is directed or not. By default,
%                          guesses based on whether the adjacency matrix is
%                          symmetric or triangular.
%        discardTransient  The number of partitions to ignore before tracking
%                          (default 3).
%        independentRuns   Number of independent runs to perform (default 10).
%        maxThreads        Number of threads to use. By default (when set to 0)
%                          is independentRuns. If the number of available cores
%                          is greater than maxThreads than each run will be
%                          perform on a separate core. If maxThreads is greater
%                          than the number of available cores than the max
%                          number of cores will be used.
%        seed              A random seed to set igraph's RNG with. By default
%                          this value is randomly generated by MATLAB's random
%                          number generator, so reproducible results can be
%                          obtained by setting MATLAB's RNG with RNG and
%                          ignoring this option.
%        targetClusters    The expected number of clusters to find. This
%                          option determines the number of tags to use in the
%                          initial conditions, but does not constrain the final
%                          number of clusters detected. Default is dependent on
%                          the size of the graph.
%        targetPartitions  Number of partitions to find per independent run
%                          (default 5).
%        subcluster        Depth of clustering (default 1). If greater than 1,
%                          perform recursive clusering on each community found
%                          at the previous level.
%        minCluster        Minimum cluster to subcluster (default 5). If a
%                          community is less than this size, it will not be
%                          clustered any further.
%        verbose           Whether to print information about progress
%                          (default false)
%
%   See also SE2.ORDER

    arguments
        graph {igutils.mustBeGraph};
        graphOpts.?igutils.GraphInProps;
        opts.discardTransient (1, 1) {mustBePositive, mustBeInteger} = 3;
        opts.independentRuns (1, 1) {mustBePositive, mustBeInteger} = 10;
        opts.maxThreads (1, 1) {mustBeNonnegative, mustBeInteger} = 0;
        opts.multiCommunity (1, 1) {mustBePositive, mustBeInteger} = 1;
        opts.nodeConfidence (1, 1) logical = false;
        opts.seed (1, 1) {mustBePositive, mustBeInteger} = randi([1, 9999]);
        opts.subcluster (1, 1) {mustBePositive, mustBeInteger} = 1;
        opts.minCluster (1, 1) {mustBePositive, mustBeInteger} = 5;
        opts.targetClusters (1, 1) {mustBePositive, mustBeInteger} = ...
            defaultTargetClusters(graph);
        opts.targetPartitions (1, 1) {mustBePositive, mustBeInteger} = 5;
        opts.verbose = false;
        attribute.results (1, :) char ...
            {igutils.mustHoldNodeAttr(graph, attribute.results)} = '';
    end

    graphOpts = namedargs2cell(graphOpts);
    graphOpts = igutils.setGraphInProps(graph, graphOpts{:});

    if opts.multiCommunity ~= 1
        error("SE2:NotImplemented", ...
              "Multicommunity detection has not been implemented.");
    end

    if opts.nodeConfidence
        error("SE2:NotImplemented", ...
              "Node confidence has not been implemented.");
    end

    if nargout == 2
        [memb, ordering] = mexSE2(graph, opts, graphOpts);
    else
        memb = mexSE2(graph, opts, graphOpts);
    end

    if ~isempty(attribute.results)
        graph.Nodes.(attribute.results) = memb';
        memb = graph;
    end
end

function n = defaultTargetClusters(graph)
    nNodes = igraph.numnodes(graph);
    n = ceil(nNodes / 100);
    if n < 10
        n = 10;
    end

    if nNodes < 10
        n = nNodes;
    end
end
