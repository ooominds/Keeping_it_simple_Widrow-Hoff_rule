#include "mex.h"
void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
  mwSize nRowSparse,nColSparse,nRowDense,nColDense,nnz;
  mwIndex *Ir,*Jc;
  mwIndex numElemInCol;
  mwIndex ic,ir,idx;
  mwIndex row,col;
  double *prSparse; 
  double *prDense; 
  if(nrhs != 2) {mexErrMsgIdAndTxt("ooominds:addSparseToDense:nrhs","Two inputs required.");}
  /* Check that first argument is sparse) */
  if(!mxIsSparse(prhs[0])) {mexErrMsgIdAndTxt("ooominds:addSparseToDense","First argument must be a Sparse Matrix");}
  
    /* Get the size and pointers to input sparse matrix */
    nRowSparse  = mxGetM(prhs[0]);
    nColSparse  = mxGetN(prhs[0]);
    /* pointer to matrix elements in sparse matrix */
    prSparse = mxGetPr(prhs[0]);
    /* pointers to indices in sparse matrix */
    Ir = mxGetIr(prhs[0]);
    Jc = mxGetJc(prhs[0]);
    nnz = mxGetNzmax(prhs[0]);
    
    /* Get the size and pointers to input dense matrix */
    nRowDense  = mxGetM(prhs[1]);
    nColDense  = mxGetN(prhs[1]);
    /* Check that sizes are compatible */
    /* TODO */
    prDense = mxGetPr(prhs[1]);
    /*mexPrintf("%d\n",nnz);*/
    
    idx = 0;
    for(ic=0; ic<nColSparse; ic++)
    {
        numElemInCol = Jc[ic+1] - Jc[ic];
        for(ir=0; ir<numElemInCol; ir++)
        {
            /*mexPrintf("%d %d %f\n",Ir[idx],ic,prSparse[idx]);*/
            prDense[Ir[idx] + ic*nRowDense] = prDense[Ir[idx] + ic*nRowDense] + prSparse[idx];
            idx = idx + 1;
        }
    }
    
    
}