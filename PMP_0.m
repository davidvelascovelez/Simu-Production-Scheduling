clear all
clc
%% Declaración de variables
NB=[1812,906,906,906,1632,816,816,816]; %Necesidades Brutas
IE_1=950; %Inventario en Exceso
PC=[0,1500,0,0,0,0,0,0]; %Pedidios en Curso
N=8;   %Num de períodos
SS=0;  %Stock de Seguridad
c_e=1000; %Costes de emisión
c_p=1; %Costes de posesión
NN=zeros(1,N); %Necesidades Netas
IE=zeros(1,N);
IE(1)=IE_1;

%% Importación de variables
T=readtable('Datos_entrada_0.xlsx','Sheet','PMP','Range','C4:Z9');
N=table2array(T(1,1));
NB=table2array(T(2,1:N));
PC=table2array(T(3,1:N));
IE_1=table2array(T(4,1));
SS=table2array(T(5,1));
c_e=table2array(T(6,1));
c_p=table2array(T(7,1));
NN=zeros(1,N); %Necesidades Netas
IE=zeros(1,N);
IE(1)=IE_1;


%% Cálculo de las NN
NN(1)=NB(1)-(IE_1-SS)-PC(1);
if NN(1)<0
    IE(2)=-NN(1);
    NN(1)=0;
end

for i=2:N
   NN(i)=NB(i)-(IE(i)-SS)-PC(i); 
   if NN(i)<0
    IE(i+1)=-NN(i);
    NN(i)=0;
    end
end
%% Pruebas
NN=[0,510,1480,200,1200,1800,0,200];
c_e=1500;
c_p=1;

%% Técnicas de dimensionado
[pmp,coste]=LoteLote(NN,c_e);
A=struct('tecnica',{'Lote a lote'},'pmp',[pmp],'coste',[coste]);

A.tecnica={'Lote a lote', 'Minimo coste unitario', 'Minimo coste total','Silver Meal','EOQ'};

[pmp,coste]=minimo_unitario(NN,c_e,c_p);
A.pmp=[A.pmp;pmp];
A.coste=[A.coste,coste];

[pmp,coste]=minimo_total(NN,c_e,c_p);
A.pmp=[A.pmp;pmp];
A.coste=[A.coste,coste];

[pmp,coste]=silver_meal(NN,c_e,c_p);
A.pmp=[A.pmp;pmp];
A.coste=[A.coste,coste];

[pmp,coste]=EOQ(NN,c_e,c_p);
A.pmp=[A.pmp;pmp];
A.coste=[A.coste,coste];

% [min_cost,pos]=min(A.coste);
% 
% fprintf('El PMP más económico es: \n')
% A.pmp(pos,:)
% fprintf('\n Mediante la técnica de:')
% string(A.tecnica(pos))




