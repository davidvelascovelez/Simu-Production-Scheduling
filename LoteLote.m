function [PMP,Coste] = LoteLote(NN,C_e)
PMP=NN;
Coste=0;
for i=1:length(NN)
   if NN(i)>0
      Coste=Coste+C_e; 
   end
end
end