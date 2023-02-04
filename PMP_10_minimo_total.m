function OUTPUT =PMP_10_minimo_total(INPUT)
%Calculo de las NN
IE=zeros(1,length(INPUT.NB));
IF=zeros(1,length(INPUT.NB));

NN(1)=INPUT.NB(1)-(INPUT.IE_1-INPUT.SS)-INPUT.PC(1);
if NN(1)<0
    IE(2)=-NN(1);
    NN(1)=0;
end
for i=2:length(INPUT.NB)
   NN(i)=INPUT.NB(i)-(IE(i)-INPUT.SS)-INPUT.PC(i); 
   if NN(i)<0
    IE(i+1)=-NN(i);
    NN(i)=0;
    end
end

%Tecnica de dimensionado
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
                C_pos=[C_pos, C_pos(length(C_pos))+INPUT.c_p*(i-p_cuenta(1))*NN(i)];
           end
           C_em=[C_em,INPUT.c_e];
           Desviacion=abs(C_pos-C_em); 
        end
    end
    
    [c_min,pos]=min(Desviacion);
    Coste=Coste+INPUT.c_e+C_pos(pos);
    for i=p_cuenta(1):(pos+p_cuenta(1)-1)
       if NN(i)==0
          cero=cero+1; 
       end
    end
    
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

%Cálculo Inventario en Exceso
IE(1)=INPUT.IE_1;
for i=2:length(NN)
   IE(i)=PMP(i-1)-NN(i-1);
end
IE=IE.*(IE>0);

%Cálculo del inventario final
for i=1:length(NN)
   IF(i)=PMP(i)+IE(i)-NN(i);
end
IF=IF.*(IF>0);

%Datos de salida
Tabla=[INPUT.NB;INPUT.PC;NN;IE;PMP;IF];

OUTPUT=struct('Tabla',Tabla,'Coste',Coste);

end