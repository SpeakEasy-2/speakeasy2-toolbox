function plan = buildfile
    plan = buildplan(localfunctions);
    plan.DefaultTasks = "test";

    plan("test").Dependencies = ["testToolbox"];
end

function testTask(~)
end

function testToolboxTask(~)
    oldPath = addpath("toolbox");

    try
        runtests("tests");
    catch
        path(oldPath);
    end

    path(oldPath);
end
