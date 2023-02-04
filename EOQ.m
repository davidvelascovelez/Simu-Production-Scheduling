function [PMP,Coste] = EOQ(NN,C_e,C_p)

D=sum(NN);
Q=round(sqrt(2*D*C_e/(C_p*length(NN))));
IE=zeros(1,length(NN)+1);
PMP=zeros(1,length(NN));

for i=1:length(NN)
   if (NN(i)-IE(i))>0
      PMP(i)=Q*ceil((NN(i)-IE(i))/Q);
      IE(i+1)=Q-(NN(i)-IE(i));
   else
       IE(i+1)=IE(i)-NN(i);
   end
end
Coste=sum(PMP~=0)*C_e+sum(IE)*C_p;
end