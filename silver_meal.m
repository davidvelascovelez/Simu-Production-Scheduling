function [PMP,Coste] =silver_meal(NN,C_e,C_p)
Periodo_lote=[];
Q_acum=0;
Q=[];
C_pos=[];

SM=[];

PMP=zeros(1,length(NN));

p_inicio=1;
p_cuenta=[];
c_min=0;
pos=0;
cero=0;
Coste=0;

while sum(PMP)<sum(NN)
   
    for i=p_inicio:length(NN)
        if NN(i)~=0
           p_cuenta=[p_cuenta,i];
           Q_acum=Q_acum+NN(i);
           Q=[Q,Q_acum];
           if (i-p_cuenta(1))==0
               C_pos=[0];
               SM=[C_e];
           else
               SM=[SM, (C_e+C_pos(length(C_pos))+C_p*(i-p_cuenta(1))*NN(i))/length(p_cuenta)];
               C_pos=[C_pos, C_pos(length(C_pos))+C_p*(i-p_cuenta(1))*NN(i)];
           end
           
        end
    end
    
    [c_min,pos]=min(SM);
    Coste=Coste+C_pos(pos)+C_e;
    for i=p_cuenta(1):(pos+p_cuenta(1)-1)
       if NN(i)==0
          cero=cero+1;
       end
    end
    %PMP(pos+p_cuenta(1)-1+cero)=Q(pos)
    PMP(p_cuenta(1))=Q(pos);
    p_inicio=pos+p_cuenta(1)+cero;
    
    p_cuenta=[];
    Q_acum=0;
    Q=[];
    C_pos=[];
    
    SM=[];
    cero=0;
    
end

end