function indices = order(graph, membership)
%ORDER provide indices to reorder nodes based on membership
%   INDICES = ORDER(MEMBERSHIP) use the membership found by SPEAKEASY2 to order
%   nodes. Nodes are ordered based on the community they are in, such that
%   nodes in the largest community are placed in the lowest indices and nodes
%   in the smallest community are placed in the highest indices.
%
%   The resulting indices can be used to index the original adjacency matrix
%   as: ADJ(INDICES, INDICES). When using IMAGESC, the nodes of each community
%   will be grouped together.
%
%   This is equivalent to calling speakeasy2 with two output arguments (like
%   [MEMBERSHIP, INDICES] = SPEAKEASY2(ADJ)).
%
%   See also SPEAKEASY2.

    arguments
        graph (:, :) {mustBeNumeric};
        membership (:, :) {mustBeInteger, mustBeNonnegative};
    end

    indices = mexOrder(graph, membership);
end
