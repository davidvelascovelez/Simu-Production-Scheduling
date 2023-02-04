clear 
clc
Ruta_entrada='App Simulación de la Producción_Ejemplos.xlsm';
Ruta_salida='C:\Users\David\Desktop\TFG-App Simulación Planificación Producción\CODE\export.xls';

%% Lectura xlsx
Prevision=xlsread(Ruta_entrada,2,'E20:P20');
Ped_comprom=xlsread(Ruta_entrada,2,'E21:P21');
Ped_pendtes=xlsread(Ruta_entrada,2,'E22:P22');
SS=xlsread(Ruta_entrada,2,'O10');
Necesidades_prod=xlsread(Ruta_entrada,2,'E23:P23');
dias_prod=[20,20,22,20,22,21,20,22,22,20,21,20];
Plantilla=xlsread(Ruta_entrada,2,'E8');
Plantilla_fija=xlsread(Ruta_entrada,2,'E9');
Plantilla_max=xlsread(Ruta_entrada,2,'E10');
Inv_ini=xlsread(Ruta_entrada,2,'O9');
he_o_d=xlsread(Ruta_entrada,2,'E11'); %horas estandar por operario y dia
he_u_f=xlsread(Ruta_entrada,2,'O8'); %horas estandar por unidad de familia
h_ex_m=xlsread(Ruta_entrada,2,'E13'); %Horas extra máximas sobre la jornada regular 
h_prod_m=xlsread(Ruta_entrada,2,'E12'); %horas de producción máximas diarias
C_mo=xlsread(Ruta_entrada,2,'J8'); %Coste por h.e. en jornada regular
C_mo_ex=xlsread(Ruta_entrada,2,'J9'); %Coste por h.e.en tiempo extra
C_mo_o=(1+xlsread(Ruta_entrada,2,'J10'))*C_mo; %Coste pot h.e. de mano de obra ociosa
C_con=xlsread(Ruta_entrada,2,'J11'); %Coste de contratación
C_desp=xlsread(Ruta_entrada,2,'J12'); %Coste de despido
C_sub=xlsread(Ruta_entrada,2,'J13'); %Coste por unidad subcontratada (u.m.)
C_pos=xlsread(Ruta_entrada,2,'J14'); %Coste de posesión unitario
C_pos_u=xlsread(Ruta_entrada,2,'J15'); %Coste de posesión unitario nivelacion
C_r=xlsread(Ruta_entrada,2,'J16'); %Coste serivr con retraso, u.m. por unidad y periodo retrasado
indice_sim=xlsread(Ruta_entrada,2,'O16'); %Indice de similitud para la estrategia mixta 1: Caza+Niv MO

INPUT=struct('Prevision',Prevision,'Ped_comprom',Ped_comprom,'Ped_pendtes',Ped_pendtes,...
    'SS',SS,'Necesidades_prod',Necesidades_prod,'dias_prod',dias_prod,'Plantilla',Plantilla,...
    'Plantilla_fija',Plantilla_fija,'Plantilla_max',Plantilla_max,'Inv_ini',Inv_ini,...
    'he_o_d',he_o_d,'he_u_f',he_u_f,'h_ex_m',h_ex_m,'h_prod_m',h_prod_m,'C_mo',C_mo,...
    'C_mo_ex',C_mo_ex,'C_mo_o',C_mo_o,'C_con',C_con,'C_desp',C_desp,'C_sub',C_sub,...
    'C_pos',C_pos,'C_pos_u',C_pos_u,'C_r',C_r,'Indice_mix1',indice_sim);

%% Llamada a funciones

CAZA=PAP_10_Caza(INPUT);
NIV_MO=PAP_10_Niv_MO(INPUT);
NIV_PROD=PAP_10_Niv_Prod(INPUT);
MIX1=PAP_10_Mix1(INPUT);

%% Export datos xlsx
%Caza
writematrix(CAZA.Tabla,Ruta_salida,'Sheet','CAZA','Range','A4');
writematrix(CAZA.Coste_total,Ruta_salida,'Sheet','CAZA','Range','A2');
writematrix(CAZA.Nivel_servicio,Ruta_salida,'Sheet','CAZA','Range','C2');

%Nivelación de la mano de obra
writematrix(NIV_MO.Tabla,Ruta_salida,'Sheet','NIV_MO','Range','A4');
writematrix(NIV_MO.Coste_total,Ruta_salida,'Sheet','NIV_MO','Range','A2');
writematrix(NIV_MO.Nivel_servicio,Ruta_salida,'Sheet','NIV_MO','Range','C2');

%Nivelación de la producción
writematrix(NIV_PROD.Tabla,Ruta_salida,'Sheet','NIV_PROD','Range','A4');
writematrix(NIV_PROD.Coste_total,Ruta_salida,'Sheet','NIV_PROD','Range','A2');
writematrix(NIV_PROD.Nivel_servicio,Ruta_salida,'Sheet','NIV_PROD','Range','C2');

%Estrategia mixta 1:Caza + Niv de la mano de obra
writematrix(MIX1.Tabla,Ruta_salida,'Sheet','MIX1','Range','A4');
writematrix(MIX1.Coste_total,Ruta_salida,'Sheet','MIX1','Range','A2');
writematrix(MIX1.Nivel_servicio,Ruta_salida,'Sheet','MIX1','Range','C2');
