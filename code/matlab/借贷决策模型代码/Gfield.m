function a=Gfield(M,X,G,Rnorm,Rpower,ElitistCheck,iteration,max_it);

[N,dim]=size(X);
 final_per=2; 

 if ElitistCheck==1
     kbest=final_per+(1-iteration/max_it)*(100-final_per); 
     kbest=round(N*kbest/100);
 else
     kbest=N; 
 end
    [Ms ds]=sort(M,'descend');
 for i=1:N
     E(i,:)=zeros(1,dim);
     for ii=1:kbest
         j=ds(ii);
         if j~=i
            R=norm(X(i,:)-X(j,:),Rnorm);
         for k=1:dim 
             E(i,k)=E(i,k)+rand*(M(j))*((X(j,k)-X(i,k))/(R^Rpower+eps));
         end
         end
     end
 end

a=E.*G; 


