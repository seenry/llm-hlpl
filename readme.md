A quick way to install everything needed to generate LLVM-IR from Flash-X source code. Note: make sure you have access to the Flash-X repo since otherwise you won't be able to clone it.

## Getting Started
```
# This will install everything into `pwd`/llm-hlpl
git clone git@github.com:seenry/llm-hlpl.git
cd llm-hlpl
. ./install.sh
```

## Flash-X
Running `. ./install.sh` will invoke `./set_env.sh` but if you start a new session, make sure to run `source ./set_env.sh` (also note that `set_env.sh` is sensitive to where you run it i.e. it uses `pwd`)

To build the deforming bubble test case:
```
# source ./set_env.sh
cp $HERE/FlashFiles/deform.par $HERE/Flash-X/source/Simulation/SimulationMain/incompFlow/DeformingBubble/tests/test.par
cd $HERE/Flash-X
./setup incompFlow/DeformingBubble -auto -2d -nxb=16 -nyb=16 +noio +pm4dev -site=$SITE_NAME -gridinterpolation=native --without-unit=Grid/GridSolvers/HYPRE -parfile=tests/test.par && cd object && make
```

To generate llvm-ir for a given file:
```
cd $HERE/Flash-X/object
flang -S -O0 -fdefault-real-8 -Wuninitialized -emit-llvm <input_file>.F90 -o <output_file>.ll
```
