
 clear all;clc
 N=50; 
 max_it=100; 
 ElitistCheck=1; Rpower=1;
 min_flag=1; % 1: minimization, 0: maximization

 F_index=-1;
 [Fbest,Lbest,BestChart,MeanChart]=GSA(F_index,N,max_it,ElitistCheck,min_flag,Rpower);
 Fbest
 Lbest
 semilogy(BestChart,'k');


