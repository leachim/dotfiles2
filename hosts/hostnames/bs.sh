#!/bin/bash
# Config for bs-* cluster nodes (ETH Zurich)
# Only contains settings unique to bs-* that differ from hpc.sh base config
# Note: History management functions (use_shared_history/use_separate_history) are in aliases.symlink

# CUDA 12.8 specific (overrides hpc.sh generic cuda)
export CUDA_HOME=$HOME/cuda-12.8
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# MMSEQ
export PATH=/home/michaes/mmseqs/bin:$PATH
# GCC 12 environment (specific to bs-* nodes)
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

# squeue aliases (different from qqsqu in hpc.sh - note 'squ' vs 'qqsqu')
alias squ="squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\""
alias sqw="watch -n 10 'squeue -u \$(whoami) -o \"%.18i %.12P %.20j %.3T %.12M %.10l %.6D %.4C %R\"'"
alias sqwa="watch -n 10 'squeue -o \"%.18i %.12P %.20j %.8u %.3T %.12M %.10l %.6D %.4C %b %R\" | awk \"{if (NR==1) {print; next} if (\\\$10 ~ /gpu:/) {match(\\\$10, /[0-9]+\\\$/, a); \\\$10=a[0]} else if (\\\$10 ~ /N\/A/) {\\\$10=0} print}\" | column -t'"
