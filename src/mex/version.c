#include <mex.h>
#include <se2_version.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
  char const version_str[] = SE2_VERSION;
  plhs[0] = mxCreateString(version_str);
}
