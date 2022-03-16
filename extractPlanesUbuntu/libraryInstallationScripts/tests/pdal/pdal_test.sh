#!/bin/bash
path_home_user=$(eval echo ~$USER)
pdal translate mesh_fixed.ply ${path_home_user}/mesh_fixed_out.ply --writers.ply.dims="X=float32,Y=float32,Z=float32"