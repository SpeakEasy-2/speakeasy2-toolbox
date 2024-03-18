#include <mxIgraph.h>
#include <speak_easy_2.h>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, mxArray const* prhs[])
{
  igraph_vector_int_t membership;
  igraph_vector_int_t ordering;

  mxIgraphMembershipFromArray(prhs[0], &membership);

  se2_order_nodes(&membership, &ordering);

  // Use membership converter because it increments 0-based index -> 1-based.
  plhs[0] = mxIgraphMembershipToArray(&ordering);
  igraph_vector_int_destroy(&ordering);
}
