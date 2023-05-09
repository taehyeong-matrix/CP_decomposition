# Finding Tensor Decompositions with Sparse Optimization
This repo contains code related to the paper "Finding Tensor Decompositions with Sparse Optimization".
This papar was written with the following co-authurs.
- Yeongrak Kim, Assistant Professor, Pusan National University.
- Jeong-Hoon Ju, Ph.D student, Pusan National University.


## Toolbox
The code works in MATLAB 2023a. And the following Toolboxes of MATLAB are required to run the code.

- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox

## Files
Each code is as follows.

- find_classic.m : Find CP decomposition of $2\times 2$ matrix multiplication with using $8$ rank 1 tensors
- find_strassen.m : Find CP decomposition of $2\times 2$ matrix multiplication with using $7$ rank 1 tensors which same as the Strassen's algorithm
- find_3_3.m : Find CP decomposition of determinant of $3\times 3$ matrices which is same to Derksen's $3\times 3$ deteriminant formula
- find_4_4.m : Find new formula of determinant of $4\times 4$ matrices
- det4.m : MATLAB function for computing determinant by using New formula

## Hardware
Each code was operated on the following hardware. Some codes require large amounts of RAM memory due to large matrices.

Except for the "find_4_4.m" code, it worked in the following hardware environment.
- CPU : 13th Gen Inter(R) Core(TM) i7-13700H, 24MB L3 Cache
- RAM : 32GB LPDDR5

The "find_4_4.m" code ran in the following hardware environment because the "parfor" of Parallel Computing Toolbox and the "lasso" function of Statistics and Machine Learning Toolbox required a large amount of memory.
- CPU : Xeon Gold 6242 16Core 2.8 Ghz,22MB Cache*2P
- RAM : 192GB 3200MHz (12EA * 16GB)

If you cannot run "find4_4.m" due to insufficient computer specifications, you can run "find3_3.m" to see how it works for matrices of size $4\times 4$.
Like Derksen's formula, we can find a determinant formula consisting of five terms through "find3_3.m".
