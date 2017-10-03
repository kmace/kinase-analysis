#!/bin/bash

src_dir=$1
output_dir=$2

mkdir -p ${output_dir}

parallel bash run_meme.sh {} ${output_dir} ::: ${src_dir}/*.txt
