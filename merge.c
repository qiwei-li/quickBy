void merge(int *longKey, double *shortValues, int *numValues, double *longAns){
  for(int i = 0; i < *numValues; i++){
  	longAns[i] = shortValues[longKey[i]-1];
  } 
}


