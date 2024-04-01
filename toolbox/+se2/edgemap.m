function edgemap(graph, membership)
    arguments
        graph (:, :);
        membership (:, :) {mustBeInteger, mustBeNonnegative};
    end

    order = se2.order(graph, membership);
    levels = size(membership, 1);

    graph =  graph / max(graph, [], 'all');
    h = createEdgeMap(graph, order);
    h.Parent.Parent.UserData = struct("level", 1);

    calculateBoundaries(h, membership, order, 1);
    drawClusters(h);

    callback = @(~, ~) zoomFcn(h, membership, order);
    zoom(h.Parent.Parent, 'on');
    set(zoom(h.Parent.Parent), 'ActionPostCallback', callback);

    if levels > 1
        addGUI(h, graph, membership, order, levels);
    end
end

function h = createEdgeMap(graph, order)
    h = image(cdata(graph, order, 1));
    h.AlphaData = graph(order(1, :), order(1, :));
end

function colors = cdata(graph, order, level)
    colors = zeros(size(graph, 1), size(graph, 1), 3);
    idx = graph(order(level, :), order(level, :)) > 0;
    colors(:, :, 1) = idx .* 0.404;
    colors(:, :, 2) = idx .* 0.035;
    colors(:, :, 3) = idx .* 0.11;
end

function calculateBoundaries(h, membership, order, level)
    fig = h.Parent.Parent;

    if ~(isfield(fig.UserData, 'lastLevel') && ...
         (fig.UserData.lastLevel == level))
        rng = 1:size(membership, 2);
        fig.UserData.leftBoundary = ...
            rng(diff([-1, membership(level, order(level, :))]) ~= 0);
        fig.UserData.rightBoundary = ...
            rng(diff([membership(level, order(level, :)), -1]) ~= 0);
        fig.UserData.lastLevel = level;
    end

    minSize = diff(h.Parent.XLim) / 50;
    idx = ...
        (fig.UserData.rightBoundary - fig.UserData.leftBoundary + 1) > minSize;
    fig.UserData.idx = idx;
end

function drawClusters(h)
    UserData = h.Parent.Parent.UserData;
    leftBoundary = UserData.leftBoundary;
    rightBoundary = UserData.rightBoundary;
    idx = UserData.idx;

    hold on
    for c = leftBoundary(idx)
        xline(c - 0.5, alpha = 0.1, linestyle='--');
        yline(c - 0.5, alpha = 0.1, linestyle='--');
    end

    for c = rightBoundary(idx)
        xline(c + 0.5, alpha = 0.1, linestyle='--');
        yline(c + 0.5, alpha = 0.1, linestyle='--');
    end
    hold off

    ticks = cumsum(rightBoundary - leftBoundary + 1);
    ticks = ticks - ((rightBoundary - leftBoundary + 1) / 2);
    labels = strsplit(sprintf("%d ", 1:length(ticks)));
    labels(~idx) = ".";
    h.Parent.XTick = ticks;
    h.Parent.XTickLabel = labels;
    h.Parent.YTick = ticks;
    h.Parent.YTickLabel = labels;
    h.Parent.TickLength = [0 0];
end

function clearClusters(h)
    for child = h.Parent.Children'
        if isa(child, 'matlab.graphics.chart.decoration.ConstantLine')
            delete(child);
        end
    end
end

function zoomFcn(h, membership, order)
    fig = h.Parent.Parent;
    level = fig.UserData.level;
    prevIdx = fig.UserData.idx;
    calculateBoundaries(h, membership, order, level);
    newIdx = fig.UserData.idx;
    if ~isequal(prevIdx, newIdx)
        clearClusters(h);
        drawClusters(h);
    end
end

function switchLevel(button, h, graph, membership, order, ~)
    level = str2num(button.SelectedObject.String);
    h.Parent.Parent.UserData.level = level;

    h.CData = cdata(graph, order, level);
    h.AlphaData = graph(order(level, :), order(level, :));

    clearClusters(h);
    calculateBoundaries(h, membership, order, level);
    drawClusters(h);
end

function addGUI(h, graph, membership, order, levels)
    callback = @(button, eventdata) switchLevel(button, h, graph, ...
                                                membership, order, eventdata);
    bgPos = h.Parent.Position;
    bgPos(1) = bgPos(1) + bgPos(3) + 0.01;
    bgPos(3) = (1 - (bgPos(1))) * 0.8;
    bg = uibuttongroup("Title", "Scale", ...
                       "Units", "Normalized", ...
                       "Position", bgPos, ...
                       "SelectionChangedFcn", callback);
    pos = [0.1, 0.9, 0.5, 0.1];
    buttons = [];
    for l = 1:levels
        buttons(end+1) = uicontrol(bg, "Style", "radiobutton", ...
                                   "Units", "Normalized", ...
                                   "Position", pos, ...
                                   "String", sprintf("%d", l));
        pos(2) = pos(2) - 0.1;
    end
end
