function [PMP,Coste] =minimo_total(NN,C_e,C_p)
Q_acum=0;
Q=[];
C_pos=[];
C_em=[];
Desviacion=[];
Coste=0;

PMP=zeros(1,length(NN));

p_inicio=1;
p_cuenta=[];
c_min=0;
pos=0;
cero=0;


while sum(PMP)<sum(NN)
   
    for i=p_inicio:length(NN)
        if NN(i)~=0
           p_cuenta=[p_cuenta,i];
           Q_acum=Q_acum+NN(i);
           Q=[Q,Q_acum];
           if (i-p_cuenta(1))==0
               C_pos=[0];
           else
                C_pos=[C_pos, C_pos(length(C_pos))+C_p*(i-p_cuenta(1))*NN(i)];
           end
           C_em=[C_em,C_e];
           Desviacion=abs(C_pos-C_em); 
        end
    end
    
    [c_min,pos]=min(Desviacion);
    Coste=Coste+C_e+C_pos(pos);
    for i=p_cuenta(1):(pos+p_cuenta(1)-1)
       if NN(i)==0
          cero=cero+1; 
       end
    end
    %PMP(pos+p_cuenta(1)-1+cero)=Q(pos);
    PMP(p_cuenta(1))=Q(pos);
    p_inicio=pos+p_cuenta(1)+cero;
    
    p_cuenta=[];
    Q_acum=0;
    Q=[];
    C_pos=[];
    C_em=[];
    Desviacion=[];
    cero=0;
    
end

end