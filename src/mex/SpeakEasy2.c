#include <mxIgraph.h>
#include <speak_easy_2.h>

#include <string.h>

#define STREQ(a, b) strcmp((a), (b)) == 0

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
  mxIgraphSetDefaultHandlers();

  igraph_t graph;
  igraph_vector_t weights;
  se2_neighs neigh_list;
  mxArray const *method_options = prhs[1];
  igraph_matrix_int_t membership;

  se2_options opts = {
    .discard_transient =
    mxIgraphIntegerFromOptions(method_options, "discardTransient"),
    .independent_runs =
    mxIgraphIntegerFromOptions(method_options, "independentRuns"),
    .max_threads = mxIgraphIntegerFromOptions(method_options, "maxThreads"),
    .minclust = mxIgraphIntegerFromOptions(method_options, "minCluster"),
    .node_confidence =
    mxIgraphBoolFromOptions(method_options, "nodeConfidence"),
    .random_seed = mxIgraphIntegerFromOptions(method_options, "seed"),
    .subcluster = mxIgraphIntegerFromOptions(method_options, "subcluster"),
    .target_clusters =
    mxIgraphIntegerFromOptions(method_options, "targetClusters"),
    .target_partitions =
    mxIgraphIntegerFromOptions(method_options, "targetPartitions"),
    .verbose = mxIgraphBoolFromOptions(method_options, "verbose")
  };

  mxIgraphFromArray(prhs[0], &graph, &weights, method_options);
  IGRAPH_FINALLY(igraph_destroy, &graph);
  IGRAPH_FINALLY(igraph_vector_destroy, &weights);

  se2_igraph_to_neighbor_list( &graph, &weights, &neigh_list);
  igraph_destroy( &graph);
  igraph_vector_destroy( &weights);
  IGRAPH_FINALLY_CLEAN(2);

  IGRAPH_FINALLY(se2_neighs_destroy, &neigh_list);

  speak_easy_2( &neigh_list, &opts, &membership);
  IGRAPH_FINALLY(igraph_matrix_int_destroy, &membership);

  if (nlhs == 2) {
    igraph_matrix_int_t ordering;
    se2_order_nodes( &neigh_list, &membership, &ordering);
    IGRAPH_FINALLY(igraph_matrix_int_destroy, &ordering);

    plhs[1] = mxIgraphMatrixIntToArray( &ordering, true);
    igraph_matrix_int_destroy( &ordering);
    IGRAPH_FINALLY_CLEAN(1);
  }

  plhs[0] = mxIgraphMatrixIntToArray( &membership, true);

  igraph_matrix_int_destroy( &membership);
  se2_neighs_destroy( &neigh_list);
  IGRAPH_FINALLY_CLEAN(2);
}
