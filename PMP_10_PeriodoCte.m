function OUTPUT= PMP_10_PeriodoCte(INPUT)

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

Costes_Periodos=zeros(1,length(NN));
M_pmp=zeros(length(NN));
for N=2:length(NN)

PMP=zeros(1,length(NN));
Coste=0;
C_pos=0;
for i=1:N:length(NN)
    aux=i+N-1; 
    if aux >length(NN)
        aux=length(NN);
    end
     for j=i:aux
        PMP(i)=PMP(i)+NN(j);
        C_pos=C_pos+INPUT.c_p*NN(j)*(j-i);
     end
     Coste=Coste+INPUT.c_e+C_pos;
     C_pos=0;
end
Costes_Periodos(N)=Coste;
M_pmp(N,:)=PMP;
end
Costes_Periodos=Costes_Periodos(2:end);
[Coste,N]=min(Costes_Periodos);
PMP=M_pmp(N+1,:);

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