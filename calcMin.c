void calcMin(int *keys, double *values, int *numKeys, int *numValues, double *ans)
{

  for(int i=0; i<*numValues; i++){
  	if (values[i]<ans[keys[i]-1])
  	{
  		ans[keys[i]-1] = values[i];	
  	}
  }
}