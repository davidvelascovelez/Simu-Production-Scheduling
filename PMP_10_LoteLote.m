function OUTPUT = PMP_10_LoteLote(INPUT)

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

%Técnica de dimensionado
PMP=NN;
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

for i=1:length(NN)-1
   DP(i)=PMP(i)-NN(i);
end

%Cálculo de costes
Coste=0;
for i=1:length(NN)
   if NN(i)>0
      Coste=Coste+INPUT.c_e; 
   end
end

%Datos de salida
Tabla=[INPUT.NB;INPUT.PC;NN;IE;PMP;IF];

OUTPUT=struct('Tabla',Tabla,'Coste',Coste);

end