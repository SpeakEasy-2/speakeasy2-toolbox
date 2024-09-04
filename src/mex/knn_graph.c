#include <mxIgraph.h>
#include <speak_easy_2.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
  igraph_matrix_t mat;
  igraph_integer_t const k = mxGetScalar(prhs[1]);
  igraph_bool_t const is_weighted = mxGetScalar(prhs[2]);
  mxArray const *adj_options = prhs[3];
  igraph_t graph;
  igraph_vector_t weights;

  igraph_set_error_handler(mxIgraphErrorHandlerMex);

  mxIgraphMatrixFromArray(prhs[0], &mat, false);

  se2_knn_graph(&mat, k, &graph, is_weighted ? &weights : NULL);
  igraph_matrix_destroy(&mat);

  plhs[0] =
    mxIgraphCreateAdj(&graph, is_weighted ? &weights : NULL, adj_options);

  if (is_weighted) {
    igraph_vector_destroy(&weights);
  }

  igraph_destroy(&graph);
}
