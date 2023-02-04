clear all
clc
%% Estructura INPUT
P1_c_A=2;
P1_c_c21=2;
P1_c_c22=1;
P1_c_c23=1;
P2_c_B=1;
P2_c_c22=2;
P2_c_c23=2;

P1_c=struct('A',P1_c_A,'C21',P1_c_c21,'C22',P1_c_c22,'C23',P1_c_c23);
P2_c=struct('B',P2_c_B,'C22',P2_c_c22,'C23',P2_c_c23);

O_tc=zeros(1,10);
O_a=zeros(1,10);
O_ct=zeros(1,10);
%Tiempos de carga
O_tc(1)=0.15;
O_tc(2)=0.11;
O_tc(3)=0.12;
O_tc(4)=0.15;
O_tc(5)=0.25;
O_tc(6)=0.16;
O_tc(7)=0.03;
O_tc(8)=0.32;
O_tc(9)=0.1;
O_tc(10)=0.42;
%Centro de trabajo
O_ct(1)=1;
O_ct(2)=2;
O_ct(3)=3;
O_ct(4)=3;
O_ct(5)=1;
O_ct(6)=3;
O_ct(7)=4;
O_ct(8)=2;
O_ct(9)=4;
O_ct(10)=1;
%Aprovechamiento 
O_a(1)=0.9;
O_a(2)=0.95;
O_a(3)=0.9;
O_a(4)=0.8;
O_a(5)=0.95;
O_a(6)=0.9;
O_a(7)=0.9;
O_a(8)=0.9;
O_a(9)=0.95;
O_a(10)=0.9;
%PMP
PMP_1=[0 4000 0 4000 0 4000 0 4000 0 4000 0 0];
PMP_2=[0 0 3500 0 3500 0 3500 0 0 0 3500 0];
%Capacidad estardar disponible
ced_ct1=ones(1,12);
ced_ct2=ones(1,12);
ced_ct3=ones(1,12);
ced_ct4=ones(1,12);

C_s=zeros(4,3);
C_s(1,1)=1960;
C_s(1,2)=1960;
C_s(1,3)=1160;
C_s(2,1)=2320;
C_s(2,2)=2320;
C_s(2,3)=1440;
C_s(3,1)=880;
C_s(3,2)=880;
C_s(3,3)=520;
C_s(4,1)=480;
C_s(4,2)=480;
C_s(4,3)=320;

ced_ct1(1:4)=C_s(1,1)*ced_ct1(1:4);
ced_ct1(5:8)=C_s(1,2)*ced_ct1(5:8);
ced_ct1(9:12)=C_s(1,3)*ced_ct1(9:12);

ced_ct2(1:4)=C_s(2,1)*ced_ct2(1:4);
ced_ct2(5:8)=C_s(2,2)*ced_ct2(5:8);
ced_ct2(9:12)=C_s(2,3)*ced_ct2(9:12);

ced_ct3(1:4)=C_s(3,1)*ced_ct3(1:4);
ced_ct3(5:8)=C_s(3,2)*ced_ct3(5:8);
ced_ct3(9:12)=C_s(3,3)*ced_ct3(9:12);

ced_ct4(1:4)=C_s(4,1)*ced_ct4(1:4);
ced_ct4(5:8)=C_s(4,2)*ced_ct4(5:8);
ced_ct4(9:12)=C_s(4,3)*ced_ct4(9:12);

ced=[ced_ct1;ced_ct2;ced_ct3;ced_ct4];

INPUT=struct('PMP1',PMP_1,'PMP2',PMP_2,'t_c',O_tc,'c_t',O_ct,'a',O_a,'CED',ced);


%% Organización
% Operaciones
O1=struct('t_carga',INPUT.t_c(1),'ct',INPUT.c_t(1),'a',INPUT.a(1));
O2=struct('t_carga',INPUT.t_c(2),'ct',INPUT.c_t(2),'a',INPUT.a(2));
O3=struct('t_carga',INPUT.t_c(3),'ct',INPUT.c_t(3),'a',INPUT.a(3));
O4=struct('t_carga',INPUT.t_c(4),'ct',INPUT.c_t(4),'a',INPUT.a(4));
O5=struct('t_carga',INPUT.t_c(5),'ct',INPUT.c_t(5),'a',INPUT.a(5));
O6=struct('t_carga',INPUT.t_c(6),'ct',INPUT.c_t(6),'a',INPUT.a(6));
O7=struct('t_carga',INPUT.t_c(7),'ct',INPUT.c_t(7),'a',INPUT.a(7));
O8=struct('t_carga',INPUT.t_c(8),'ct',INPUT.c_t(8),'a',INPUT.a(8));
O9=struct('t_carga',INPUT.t_c(9),'ct',INPUT.c_t(9),'a',INPUT.a(9));
O10=struct('t_carga',INPUT.t_c(10),'ct',INPUT.c_t(10),'a',INPUT.a(10));

% Listas de materiales

C22=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
C21=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
C23=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
A=struct('componente',[C21,C22],'composicion',[P1_c.C21,P1_c.C22],'ruta',[O7,O8],'aprov',[],'cargas',[]);
P1=struct('componente',[A,C23],'composicion',[P1_c.A,P1_c.C23],'ruta',[O1,O2,O3],'aprov',[],'cargas',[]);
B=struct('componente',[C22],'composicion',[P2_c.C22],'ruta',[O9,O10],'aprov',[],'cargas',[]);
P2=struct('componente',[B,C23],'composicion',[P2_c.B,P2_c.C23],'ruta',[O4,O5,O6],'aprov',[],'cargas',[]);


%% Cálculos 
[P1.aprov,P1.cargas]=aprovechamiento(P1,1);
[A.aprov,A.cargas]=aprovechamiento(A,P1.composicion(1)*P1.aprov(end));
[P2.aprov,P2.cargas]=aprovechamiento(P2,1);
[B.aprov,B.cargas]=aprovechamiento(B,P2.composicion(1)*P2.aprov(end));

Cargas_P1=sum([P1.cargas;A.cargas]);
Cargas_P2=sum([P2.cargas;B.cargas]);

% Desviaciones

Desviacion_acumulada=zeros(4,12);
Desviacion=zeros(4,12);
for i=1:4
    acum=0;
    desv=zeros(1,12);
    desv_ac=zeros(1,12);
   desv=INPUT.CED(i,:)-(Cargas_P1(i)*INPUT.PMP1+Cargas_P2(i)*INPUT.PMP2);
   for j=1:length(desv)
       acum=acum+desv(j);
       desv_ac(j)=acum;
   end
   Desviacion_acumulada(i,:)=desv_ac;
   Desviacion(i,:)=desv;
end

%% Estructura OUTPUT

Desviacion;
Desviacion_acumulada;

C_P1_ct1=Cargas_P1(1)*INPUT.PMP1;
C_P2_ct1=Cargas_P2(1)*INPUT.PMP2;
P_cap_ct1=C_P1_ct1+C_P2_ct1;
T_CT1=[C_P1_ct1;C_P2_ct1;P_cap_ct1;INPUT.CED(1,:);Desviacion(1,:);Desviacion_acumulada(1,:)];

C_P1_ct2=Cargas_P1(2)*INPUT.PMP1;
C_P2_ct2=Cargas_P2(2)*INPUT.PMP2;
P_cap_ct2=C_P1_ct2+C_P2_ct2;
T_CT2=[C_P1_ct2;C_P2_ct2;P_cap_ct2;INPUT.CED(2,:);Desviacion(2,:);Desviacion_acumulada(2,:)];

C_P1_ct3=Cargas_P1(3)*INPUT.PMP1;
C_P2_ct3=Cargas_P2(3)*INPUT.PMP2;
P_cap_ct3=C_P1_ct3+C_P2_ct3;
T_CT3=[C_P1_ct3;C_P2_ct3;P_cap_ct3;INPUT.CED(3,:);Desviacion(3,:);Desviacion_acumulada(3,:)];

C_P1_ct4=Cargas_P1(4)*INPUT.PMP1;
C_P2_ct4=Cargas_P2(4)*INPUT.PMP2;
P_cap_ct4=C_P1_ct4+C_P2_ct4;
T_CT4=[C_P1_ct4;C_P2_ct4;P_cap_ct4;INPUT.CED(4,:);Desviacion(4,:);Desviacion_acumulada(4,:)];

OUTPUT=struct('CT1',T_CT1,'CT2',T_CT2,'CT3',T_CT3,'CT4',T_CT4);
