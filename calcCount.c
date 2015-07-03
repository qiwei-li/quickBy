void calcCount(int *keys, double *values, int *numKeys, int *numValues, int *ans)
{
  for(int i=0; i<*numValues; i++){
    ans[keys[i]-1] = ans[keys[i]-1]+1;
  }
}


