#include <mxIgraph.h>
#include <speak_easy_2.h>

#include <string.h>

#define STREQ(a, b) strcmp((a), (b)) == 0

igraph_bool_t is_initialized = false;
bool utIsInterruptPending(void);

static igraph_bool_t checkUserInterrupt(void)
{
  return utIsInterruptPending();
}

static void se2_init(void)
{
  se2_set_check_user_interrupt_func(checkUserInterrupt);
  se2_set_int_printf_func(mexPrintf);

  igraph_set_error_handler(mxIgraphErrorHandlerMex);
  igraph_set_warning_handler(mxIgraphWarningHandlerMex);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
  if (!is_initialized) {
    se2_init();
    is_initialized = true;
  }

  igraph_t graph;
  igraph_vector_t weights;
  se2_neighs neigh_list;
  mxArray const *method_options = prhs[1];
  igraph_matrix_int_t membership;

  igraph_set_error_handler(mxIgraphErrorHandlerMex);

  igraph_bool_t isdirected = mxIgraphGetBool(method_options, "isdirected")
                             ? IGRAPH_DIRECTED
                             : IGRAPH_UNDIRECTED;
  se2_options opts = {
    .discard_transient =
    mxIgraphGetInteger(method_options, "discardTransient"),
    .independent_runs = mxIgraphGetInteger(method_options, "independentRuns"),
    .max_threads = mxIgraphGetInteger(method_options, "maxThreads"),
    .minclust = mxIgraphGetInteger(method_options, "minCluster"),
    .node_confidence = mxIgraphGetBool(method_options, "nodeConfidence"),
    .random_seed = mxIgraphGetInteger(method_options, "seed"),
    .subcluster = mxIgraphGetInteger(method_options, "subcluster"),
    .target_clusters = mxIgraphGetInteger(method_options, "targetClusters"),
    .target_partitions =
    mxIgraphGetInteger(method_options, "targetPartitions"),
    .verbose = mxIgraphGetBool(method_options, "verbose")
  };

  mxIgraphGetGraph(prhs[0], &graph, &weights, isdirected);
  IGRAPH_FINALLY(igraph_destroy, &graph);
  IGRAPH_FINALLY(igraph_vector_destroy, &weights);

  se2_igraph_to_neighbor_list(&graph, &weights, &neigh_list);
  igraph_destroy(&graph);
  igraph_vector_destroy(&weights);
  IGRAPH_FINALLY_CLEAN(2);

  IGRAPH_FINALLY(se2_neighs_destroy, &neigh_list);

  speak_easy_2(&neigh_list, &opts, &membership);
  IGRAPH_FINALLY(igraph_matrix_int_destroy, &membership);

  if (nlhs == 2) {
    igraph_matrix_int_t ordering;
    se2_order_nodes(&neigh_list, &membership, &ordering);
    IGRAPH_FINALLY(igraph_matrix_int_destroy, &ordering);

    plhs[1] = mxIgraphMatrixIntToArray(&ordering, true);
    igraph_matrix_int_destroy(&ordering);
    IGRAPH_FINALLY_CLEAN(1);
  }

  plhs[0] = mxIgraphMatrixIntToArray(&membership, true);

  igraph_matrix_int_destroy(&membership);
  se2_neighs_destroy(&neigh_list);
  IGRAPH_FINALLY_CLEAN(2);
}
