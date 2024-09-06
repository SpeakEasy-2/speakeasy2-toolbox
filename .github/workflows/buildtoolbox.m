function buildtoolbox(toolboxFolder, outDir, version)
    versionNumber = regexp(version, "v(\d+\.\d+\.\d+)", "tokens");
    versionNumber = versionNumber{1};

    releaseName = strjoin(['speakeasy2', version], '_');

    uuid = "d6b3abc6-7541-4fb2-b636-fc353c928a87";
    opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, uuid);

    opts.ToolboxName = "SpeakEasy2";
    opts.ToolboxVersion = versionNumber;
    opts.ToolboxGettingStartedGuide = fullfile(toolboxFolder, ...
                                               "GettingStarted.mlx");

    opts.AuthorName = "David R. Connell";
    opts.Summary = "SpeakEasy2 community detection algorithm.";
    opts.Description = ...
        "A rewrite of the SpeakEasy2 community detection algorithm in C " + ...
        "for improved performance.";

    if ~exist(outDir, "dir")
        mkdir(outDir);
    end
    opts.OutputFile = fullfile(outDir, releaseName);

    opts.MinimumMatlabRelease = "R2019b";
    opts.MaximumMatlabRelease = "";

    opts.RequiredAddons = ...
        struct("Name", "matlab-igraph", ...
               "Identifier", "e100c63a-9d55-4527-9e0b-a43d8ff89d03", ...
               "EarliestVersion", "0.2.0", ...
               "LatestVersion", "10.0.0", ...
               "DownloadURL", "");

    matlab.addons.toolbox.packageToolbox(opts);
end
