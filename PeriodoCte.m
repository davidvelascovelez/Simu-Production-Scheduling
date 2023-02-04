function [PMP,Coste]= PeriodoCte(NN,N,C_e,C_p)
%C_p -> Costes de posesión unitarios
PMP=zeros(1,length(NN));
Coste=0;
C_pos=0;
for i=1:N:length(NN)
    aux=i+N-1; %Para no sobrepasar la longitud del vector
    if aux >length(NN)
        aux=length(NN);
    end
     for j=i:aux
        PMP(i)=PMP(i)+NN(j);
        C_pos=C_pos+C_p*NN(j)*(j-i);
     end
     Coste=Coste+C_e+C_pos;
     C_pos=0;
end
end
