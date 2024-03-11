# SpeakEasy 2: Champagne MATLAB toolbox
[Genome Biology article.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-023-03062-0)

A MATLAB toolbox for calling the SpeakEasy 2 (SE2) community detection algorithm. Calls [the SpeakEasy2 C library](https://github.com/SpeakEasy-2/libspeakeasy2). Clusters graphs represented as adjacency matrices (see [matlab-igraph](https://github.com/DavidRConnell/matlab-igraph) for working with graphs in MATLAB).

## Installation

### Prebuilt toolboxes (recommended)

The toolbox can be installed via MATLAB's add-on manager (accessed inside the MATLAB IDE, see [Get and Manage Add-Ons](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).) This will also provide notifications about updates. Alternatively, the toolbox can be download from the GitHub release page.

### Building from source

This package uses CMake and git submodules for handling some of the dependencies. External dependencies are `bison`, `flex`, and `libxml2`.

To setup clone the git repo and download the git submodules using:

```bash
git clone "https://github.com/SpeakEasy-2/speakeasy2-toolbox"
git submodule update --init --recursive
```

For CMake run:
```bash
cmake -B build .
cmake --build build
```

This will build mex files to `./build/src/mex` to run the toolbox in the current directory, you can link all mex files to `toolbox/private`. This will allow the mex files to be rebuilt without needing to repeatedly copy them to the toolbox.

## Use

```matlab
adj = igraph.famous("Zachary"); % Requires matlab-igraph toolbox
membership = speakeasy2(adj);
igraph.plot(adj, membership=membership)
```

## Options

The options can also be found by running `help speakeasy2`.

| Option | type | default | effect |
|--------|------|---------|--------|
| independentRuns | integer | 10 | number of independent runs to perform. Each run gets its own set of initial conditions. |
| targetPartitions | integer | 5 | Number of partitions to find per independent run. |
| discardTransient | integer | 3 | Ignore this many partitions before tracking. |
| targetClusters | integer | dependent on size of graph | Expected number of clusters to find. Used for creating the initial conditions. The final partition is not constrained to having this many clusters. |
| seed | integer | randomly generated | a random seed for reproducibility. |
| maxThreads | integer | Value returned by `omp_get_num_threads` | number of parallel threads to use. (Use 1 to prevent parallel processing.)|
| verbose | boolean | false | Whether to print extra information about the running process. |

Use name-value pairs for setting options:

```matlab
speakeasy2(adj, 'seed', 1234, 'verbose', true, 'independentRuns', 5);
```

Or options can also be supplied in `name=value` format:

``` matlab
speakeasy2(adj, discardTransient=5, verbose=true);
```

See `help speakeasy2` for more information.
