function versionstr = version()
%VERSION the speakeasy2 package version
%   SPEAKEASY2('VERSION') display the toolbox version.
%   VERSION = SPEAKEASY2('VERSION') return the toolbox version string.

    if nargout == 0
        fprintf("  SpeakEasy2 version: %s\n", mexVersion());
    else
        versionstr = mexVersion();
    end
end
