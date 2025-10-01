function [adj, membership] = blockAdj(sizes, mu, repr, dtype, isweighted)
    nNodes = sum(sizes);
    [adj, membership] = blockdiagonal(sizes, dtype);

    if mu > 0
        flips = rand(nNodes) < mu;
        adj = (adj | flips) - (adj & flips);
    end

    if isweighted
        noise = rand(nNodes) * 0.2;
        if strcmpi(repr, 'full')
            adj = adj + noise;
        else
            adj = adj .* noise;
        end

        adj = adj / max(adj, [], 'all');
    end

    switch repr
      case 'sparse'
        adj = sparse(adj);
      case 'graph'
        adj = digraph(adj);
    end
end

function [adj, membership] = blockdiagonal(sizes, dtype)
    nCommunities = length(sizes);
    membership = zeros(1, sum(sizes));
    adj = zeros(sum(sizes), dtype);

    idx = 1;
    for i = 1:nCommunities
        idxEnd = idx + sizes(i) - 1;
        membership(idx:idxEnd) = i;
        adj(idx:idxEnd, idx:idxEnd) = 1;
        idx = idxEnd + 1;
    end
end
