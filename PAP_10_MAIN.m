clear all
clc

%% Estructura INPUT
Prevision=[];
Ped_comprom=[];
Ped_pendtes=[];
SS=0;
Necesidades_prod=[15000,15000,10000,5000,5000,5000,10000,5000,5000,10000,15000,20000];
dias_prod=[20,20,22,20,22,21,20,22,22,20,21,20];
Plantilla=150;
Plantilla_fija=50;
Plantilla_max=150;
Inv_ini=0;
he_o_d=8; %horas estandar por operario y dia
he_u_f=1.5; %horas estandar por unidad de familia
h_ex_m=0.1; %Horas extra máximas sobre la jornada regular 
h_prod_m=800; %horas de producción máximas diarias
C_mo=1000; %Coste por h.e. en jornada regular
C_mo_ex=1500; %Coste por h.e.en tiempo extra
C_mo_o=1.1*C_mo; %Coste pot h.e. de mano de obra ociosa
C_con=100000; %Coste de contratación
C_desp=150000; %Coste de despido
C_sub=1000; %Coste por unidad subcontratada (u.m.)
C_pos=1500; %Coste de posesión unitario
C_pos_u=200; %Coste de posesión unitario nivelacion
C_r=1500; %Coste serivr con retraso, u.m. por unidad y periodo retrasado
indice_sim=0.3; %Indice de similitud para la estrategia mixta 1: Caza+Niv MO

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


