function versionstr = version()
%VERSION the speakeasy2 package version
%   SPEAKEASY2('VERSION') display the toolbox version.
%   VERSION = SPEAKEASY2('VERSION') return the toolbox version string.
%
%   Equivalent to calling SPEAKEASY2("VERSION").

    if nargout == 0
        disp(sprintf("  SpeakEasy2 version: %s", mexVersion()));
    else
        versionstr = mexVersion();
    end
end
