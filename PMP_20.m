clear 
clc
Ruta_entrada='App Simulación de la Producción_Ejemplos.xlsm';
Ruta_salida='C:\Users\David\Desktop\TFG-App Simulación Planificación Producción\CODE\export.xls';

%% Lectura xlsx
NB=xlsread(Ruta_entrada,4,'E14:P14');
IE_1=xlsread(Ruta_entrada,4,'E15');
PC=xlsread(Ruta_entrada,4,'E16:P16');
SS=xlsread(Ruta_entrada,4,'L8');
c_e=xlsread(Ruta_entrada,4,'F8');
c_p=xlsread(Ruta_entrada,4,'F9');
N=xlsread(Ruta_entrada,4,'L9');

INPUT=struct('NB',NB(1:N),'IE_1',IE_1,'PC',PC(1:N),'SS',SS,'c_e',c_e,'c_p',c_p);
%% Llamada a funciones

LoteLote=PMP_10_LoteLote(INPUT);
Min_uni=PMP_10_minimo_unitario(INPUT);
Min_total=PMP_10_minimo_total(INPUT);
S_M=PMP_10_silver_meal(INPUT);
P_Cte=PMP_10_PeriodoCte(INPUT);
EOQ=PMP_10_EOQ(INPUT);

%% Export datos xlsx
%Caza
writematrix(LoteLote.Tabla,Ruta_salida,'Sheet','LoteLote','Range','A4');
writematrix(LoteLote.Coste,Ruta_salida,'Sheet','LoteLote','Range','A2');

writematrix(Min_uni.Tabla,Ruta_salida,'Sheet','Min_uni','Range','A4');
writematrix(Min_uni.Coste,Ruta_salida,'Sheet','Min_uni','Range','A2');

writematrix(Min_total.Tabla,Ruta_salida,'Sheet','Min_total','Range','A4');
writematrix(Min_total.Coste,Ruta_salida,'Sheet','Min_total','Range','A2');

writematrix(S_M.Tabla,Ruta_salida,'Sheet','S_M','Range','A4');
writematrix(S_M.Coste,Ruta_salida,'Sheet','S_M','Range','A2');

writematrix(P_Cte.Tabla,Ruta_salida,'Sheet','P_Cte','Range','A4');
writematrix(P_Cte.Coste,Ruta_salida,'Sheet','P_Cte','Range','A2');

writematrix(EOQ.Tabla,Ruta_salida,'Sheet','EOQ','Range','A4');
writematrix(EOQ.Coste,Ruta_salida,'Sheet','EOQ','Range','A2');
