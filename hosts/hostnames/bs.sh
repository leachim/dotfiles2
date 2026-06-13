#!/bin/bash
# Config for bs-* cluster nodes (ETH Zurich, Linux)
# Only contains settings unique to bs-* that differ from hpc.sh base config
# Note: History management functions (use_shared_history/use_separate_history) are in aliases.symlink
#
# macOS bs-* machines (e.g. bs-mbpas-0085) are handled by bs-mbpas.sh instead.

[[ "$(uname)" == "Darwin" ]] && return 0

# CUDA toolkit (overrides hpc.sh generic cuda). Bump this one line to switch versions.
export CUDA_HOME=$HOME/cuda-13.3
export CUDNN_PATH=$CUDA_HOME
export CPLUS_INCLUDE_PATH=$CUDA_HOME/include:$CPLUS_INCLUDE_PATH
export CPATH=$CUDA_HOME/include:$CPATH
export LIBRARY_PATH=$CUDA_HOME/lib64:$LIBRARY_PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export PATH=$CUDA_HOME/bin:$PATH

# MMSEQ
export PATH=/home/michaes/mmseqs/bin:$PATH

# GCC 12 environment (specific to bs-* Linux nodes)
export PATH=$HOME/gcc-12/bin:$PATH
export CC=$HOME/gcc-12/bin/gcc
export CXX=$HOME/gcc-12/bin/g++

# Compiler flags (specific to bs-* build environment)
export CFLAGS="-I$HOME/.local/include -I$HOME/gcc-12/include"
export CXXFLAGS="-I$HOME/gcc-12/include"
export LDFLAGS="-L$HOME/.local/lib -L$HOME/gcc-12/lib64"
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# Proxy settings (bs-* specific)
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
