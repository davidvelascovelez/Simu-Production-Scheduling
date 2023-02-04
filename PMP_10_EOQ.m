function OUTPUT = PMP_10_EOQ(INPUT)

%Calculo de las NN

IF=zeros(1,length(INPUT.NB));
IE=zeros(1,length(INPUT.NB));
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
D=sum(NN);
Q=round(sqrt(2*D*INPUT.c_e/(INPUT.c_p*length(NN))));
IE=zeros(1,length(NN)+1);
PMP=zeros(1,length(NN));

for i=1:length(NN)
   if (NN(i)-IE(i))>0
      PMP(i)=Q*ceil((NN(i)-IE(i))/Q);
      IE(i+1)=PMP(i)-(NN(i)-IE(i));
   else
       IE(i+1)=IE(i)-NN(i);
   end
end
Coste=sum(PMP~=0)*INPUT.c_e+sum(IE)*INPUT.c_p;

IE=IE(1:length(NN));

%Cálculo del inventario final
for i=1:length(NN)
   IF(i)=PMP(i)+IE(i)-NN(i);
end
IF=IF.*(IF>0);

%Datos de salida
Tabla=[INPUT.NB;INPUT.PC;NN;IE;PMP;IF];

OUTPUT=struct('Tabla',Tabla,'Coste',Coste);
end