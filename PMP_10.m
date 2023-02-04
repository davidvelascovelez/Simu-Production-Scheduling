clear all
clc
%% Estructura INPUT

NB=[2256,2256,2256,2256,2256,2256,2256,2256]; %Necesidades Brutas
IE_1=0; %Inventario en Exceso
PC=[4000,0,0,0,0,0,0,0]; %Pedidios en Curso
N=8;   %Num de períodos
SS=0;  %Stock de Seguridad
c_e=1000; %Costes de emisión
c_p=1; %Costes de posesión
NN=zeros(1,N); %Necesidades Netas
IE=zeros(1,N);
IE(1)=IE_1;

INPUT=struct('NB',NB,'IE_1',IE_1,'PC',PC,'SS',SS,'c_e',c_e,'c_p',c_p);

%% Llamada a funciones

LoteLote=PMP_10_LoteLote(INPUT);
Min_uni=PMP_10_minimo_unitario(INPUT);
Min_total=PMP_10_minimo_total(INPUT);
S_M=PMP_10_silver_meal(INPUT);
P_Cte=PMP_10_PeriodoCte(INPUT);
EOQ=PMP_10_EOQ(INPUT);



