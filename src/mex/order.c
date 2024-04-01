#include <mxIgraph.h>
#include <speak_easy_2.h>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, mxArray const* prhs[])
{
  igraph_t graph;
  igraph_vector_t weights;
  igraph_matrix_int_t membership;
  igraph_matrix_int_t ordering;

  mxIgraphGetGraph(prhs[0], &graph, &weights, mxIgraphIsDirected(prhs[0]));
  mxIgraphMatrixIntFromArray(prhs[1], &membership, true);

  se2_order_nodes(&graph, &weights, &membership, &ordering);
  igraph_destroy(&graph);
  igraph_vector_destroy(&weights);
  igraph_matrix_int_destroy(&membership);

  plhs[0] = mxIgraphMatrixIntToArray(&ordering, true);
  igraph_matrix_int_destroy(&ordering);
}
