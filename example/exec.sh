#!/usr/bin/env bash
gfortran -c subrutinas/parametros.f90 -o ejecutables/parametros
gfortran -c subrutinas/otras_funciones.f90 -o ejecutables/otras_funciones
gfortran -c subrutinas/modulo_OA1D.f90 -o ejecutables/modulo_OA1D
gfortran OA1D_example.f90 subrutinas/*.f90 -o ejecutables/OA1D_example -L/usr/local/lib/ -llapack -lblas
./ejecutables/OA1D_example
