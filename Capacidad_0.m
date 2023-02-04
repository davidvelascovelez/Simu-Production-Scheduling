clear all
clc

%% Operaciones
O1=struct('t_carga',[0.15],'ct',[1],'a',[0.9]);
O2=struct('t_carga',[0.11],'ct',[2],'a',[0.95]);
O3=struct('t_carga',[0.12],'ct',[3],'a',[0.9]);
O4=struct('t_carga',[0.15],'ct',[3],'a',[0.8]);
O5=struct('t_carga',[0.25],'ct',[1],'a',[0.95]);
O6=struct('t_carga',[0.16],'ct',[3],'a',[0.9]);
O7=struct('t_carga',[0.03],'ct',[4],'a',[0.9]);
O8=struct('t_carga',[0.32],'ct',[2],'a',[0.9]);
O9=struct('t_carga',[0.1],'ct',[4],'a',[0.95]);
O10=struct('t_carga',[0.42],'ct',[1],'a',[0.9]);
%% Listas de materiales

C22=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
C21=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
C23=struct('componente',[],'composicion',[],'ruta',[],'aprov',[],'cargas',[]);
A=struct('componente',[C21,C22],'composicion',[2,1],'ruta',[O7,O8],'aprov',[],'cargas',[]);
P1=struct('componente',[A,C23],'composicion',[2,1],'ruta',[O1,O2,O3],'aprov',[],'cargas',[]);
B=struct('componente',[C22],'composicion',[2],'ruta',[O9,O10],'aprov',[],'cargas',[]);
P2=struct('componente',[B,C23],'composicion',[1,2],'ruta',[O4,O5,O6],'aprov',[],'cargas',[]);


%% Cálculos 
[P1.aprov,P1.cargas]=aprovechamiento(P1,1);
[A.aprov,A.cargas]=aprovechamiento(A,P1.composicion(1)*P1.aprov(end));
[P2.aprov,P2.cargas]=aprovechamiento(P2,1);
[B.aprov,B.cargas]=aprovechamiento(B,P2.composicion(1)*P2.aprov(end));

Cargas_P1=sum([P1.cargas;A.cargas]);
Cargas_P2=sum([P2.cargas;B.cargas]);

%% Desviaciones
%Datos: PMP de productos y Capacidad Estandar Disponible
PMP_1=[0 4000 0 4000 0 4000 0 4000 0 4000 0 0];
PMP_2=[0 0 3500 0 3500 0 3500 0 0 0 3500 0];
ced_ct1=[1960 1960 1960 1960 1960 1960 1960 1960 1160 1160 1160 1160];
ced_ct2=[2320 2320 2320 2320 2320 2320 2320 2320 1440 1440 1440 1440];
ced_ct3=[880 880 880 880 880 880 880 880 520 520 520 520];
ced_ct4=[480 480 480 480 480 480 480 480 320 320 320 320];
ced=[ced_ct1;ced_ct2;ced_ct3;ced_ct4];

Desviacion_acumulada=zeros(4,12);
Desviacion=zeros(4,12);
for i=1:4
    acum=0;
    desv=zeros(1,12);
    desv_ac=zeros(1,12);
   desv=ced(i,:)-(Cargas_P1(i)*PMP_1+Cargas_P2(i)*PMP_2);
   for j=1:length(desv)
       acum=acum+desv(j);
       desv_ac(j)=acum;
   end
   Desviacion_acumulada(i,:)=desv_ac;
   Desviacion(i,:)=desv;
end

Desviacion
Desviacion_acumulada