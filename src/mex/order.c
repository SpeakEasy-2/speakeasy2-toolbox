#include <mxIgraph.h>
#include <speak_easy_2.h>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, mxArray const* prhs[])
{
  mxIgraphSetDefaultHandlers();

  igraph_t graph;
  igraph_vector_t weights;
  se2_neighs neigh_list;
  igraph_matrix_int_t membership;
  igraph_matrix_int_t ordering;
  mxArray const* options = prhs[2];

  mxIgraphFromArray(prhs[0], &graph, &weights, options);
  IGRAPH_FINALLY(igraph_destroy, &graph);
  IGRAPH_FINALLY(igraph_vector_destroy, &weights);
  se2_igraph_to_neighbor_list(& graph, &weights, &neigh_list);
  igraph_destroy(& graph);
  igraph_vector_destroy(& weights);
  IGRAPH_FINALLY_CLEAN(2);
  IGRAPH_FINALLY(se2_neighs_destroy, &neigh_list);

  mxIgraphMatrixIntFromArray(prhs[1], &membership, true);
  IGRAPH_FINALLY(igraph_matrix_int_destroy, &membership);

  se2_order_nodes(& neigh_list, &membership, &ordering);
  igraph_matrix_int_destroy(& membership);
  se2_neighs_destroy(& neigh_list);
  IGRAPH_FINALLY_CLEAN(2);
  IGRAPH_FINALLY(igraph_matrix_int_destroy, &ordering);

  plhs[0] = mxIgraphMatrixIntToArray(& ordering, true);
  igraph_matrix_int_destroy(& ordering);
  IGRAPH_FINALLY_CLEAN(1);
}
