function G=Gconstant(iteration,max_it)
  alfa=20;G0=100;
  G=G0*exp(-alfa*iteration/max_it); 
