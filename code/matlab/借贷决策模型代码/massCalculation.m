function [M]=massCalculation(fit,min_flag);


Fmax=max(fit); Fmin=min(fit); Fmean=mean(fit); 
[i N]=size(fit);

if Fmax==Fmin
   M=ones(N,1);
else
    
   if min_flag==1 %for minimization
      best=Fmin;worst=Fmax; 
   else %for maximization
      best=Fmax;worst=Fmin; 
   end
  
   M=(fit-worst)./(best-worst); 

end

M=M./sum(M);