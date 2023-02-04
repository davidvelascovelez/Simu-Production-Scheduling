clear all
clc

%% Datos y variables
Prevision=[];
Ped_comprom=[];
Ped_pendtes=[];
SS=0;
Necesidades_prod=[];
dias_prod=[20,20,22,20,22,21,20,22,22,20,21,20];
Plantilla=0;
Plantilla_fija=0;
Inv_ini=0;
he_o_d=8; %horas estandar por operario y dia
he_u_f=0; %horas estandar por unidad de familia
h_ex_m=0; %horas extra máximas diarias
h_prod_m=0; %horas de producción máximas diarias
C_mo=0; %Coste por h.e. en jornada regular
C_mo_ex=0; %Coste por h.e.en tiempo extra
C_mo_o=0; %Coste mano de obra ociosa
C_con=0; %Coste de contratación
C_desp=0; %Coste de despido
C_sub=0; %Coste por unidad subcontratada
C_pos=0; %Coste de posesión unitario

%% Pruebas
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


%% Estrategia de caza

Prod_regular=zeros(1,length(Necesidades_prod));%Producción regular
for i=1:length(Necesidades_prod)
    if Necesidades_prod(i)<=(Plantilla_max*he_o_d*dias_prod(i)/he_u_f)
       Prod_regular(i)=Necesidades_prod(i);
    else
        Prod_regular(i)=Plantilla_max*he_o_d*dias_prod(i)/he_u_f;
    end
end

MO=zeros(1,length(Prod_regular)); %Mano de obra

C_MO_O=zeros(1,length(Prod_regular)); %Costes mano de obra oficiosa

for i=1:length(Prod_regular)
   a=ceil(Prod_regular(i)*(he_u_f/dias_prod(i)/he_o_d));
   if a>=Plantilla_fija
       MO(i)=a;
   else
       MO(i)=Plantilla_fija;
       %Coste de mano de obra oficiosa
       C_MO_O(i)=(Plantilla_fija*dias_prod(i)*he_o_d-Prod_regular(i)*he_u_f)*C_mo_o;
   end
   
end
Prod_regular_c=floor(he_o_d/he_u_f*MO.*dias_prod);%Actualización de la prod reg en funcion del redondeo de MO
C_MO=Prod_regular*(he_u_f*C_mo); %Costes MO
H_MO_regular=he_o_d*MO.*dias_prod;

Var_MO=zeros(1,length(MO)); %Variación MO
aux1=MO(1)-Plantilla;
Var_MO(1)=aux1*(abs(aux1)>=Plantilla_fija)+(Plantilla_fija-Plantilla)*(abs(aux1)<Plantilla_fija);
for i=2:length(MO)
   Var_MO(i)=MO(i)-MO(i-1);
end
C_Var_MO=zeros(1,length(MO)); %Costes Variación MO
for i=1:length(Var_MO)
   if Var_MO(i)<=0
       C_Var_MO(i)=C_desp*abs(Var_MO(i));
   else
       C_Var_MO(i)=C_con*Var_MO(i);
   end
end

Inventario_final=zeros(1,length(Prod_regular));%Inventario final
Inventario_final(1)=Inv_ini+Prod_regular(1)-Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i);
end
C_Inv_final=C_pos*abs(Inventario_final);


Prod_he=zeros(1,length(Necesidades_prod));
Subcontratacion=zeros(1,length(Necesidades_prod));
C_Prod_he=zeros(1,length(Necesidades_prod));
C_Sub=zeros(1,length(Necesidades_prod));

%Matriz de costes y nivel de servicio
Costes=[C_MO;C_Var_MO;C_Prod_he;C_Sub;C_MO_O;C_Inv_final]
Coste_total=sum(sum(Costes))
Nivel_servicio=round((sum(Prod_regular)+sum(Prod_he)+sum(Subcontratacion)+sum(Inventario_final.*(Inventario_final<0)))/sum(Necesidades_prod)*100,1)

%% Estrategia de nivelación de mano de obra

Horizonte_planif=sum(dias_prod); %Horizonte de planificación del PAP en días
Niv_MO=ceil(sum(Necesidades_prod)/Horizonte_planif*he_u_f/8); %MO necesaria
Prod_regular=ceil(sum(Necesidades_prod)/Horizonte_planif)*dias_prod;

MO=Niv_MO*ones(1,length(Prod_regular));
C_MO=Prod_regular*(he_u_f*C_mo); %Costes MO
H_MO_regular=he_o_d*MO.*dias_prod;

Var_MO=zeros(1,length(MO)); %Variación MO
Var_MO(1)=MO(1)-Plantilla;
for i=2:length(MO)
   Var_MO(i)=MO(i)-MO(i-1);
end
C_Var_MO=zeros(1,length(MO)); %Costes Variación MO
for i=1:length(Var_MO)
   if Var_MO(i)<=0
       C_Var_MO(i)=C_desp*abs(Var_MO(i));
   else
       C_Var_MO(i)=C_con*Var_MO(i);
   end
end

Inventario_final=zeros(1,length(Prod_regular));%Inventario final
Inventario_final(1)=Inv_ini+Prod_regular(1)-Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i);
end

C_Inv_final=zeros(1,length(Prod_regular));%Costes inventario final
for i=1:length(C_Inv_final)
   if Inventario_final(i)<0
       C_Inv_final(i)=C_pos*abs(Inventario_final(i));
   else
       C_Inv_final(i)=(Inventario_final(i)+Inventario_final(i-1))/2*C_pos_u;
   end
end 


Prod_he=zeros(1,length(Necesidades_prod));
Subcontratacion=zeros(1,length(Necesidades_prod));
C_Prod_he=zeros(1,length(Necesidades_prod));
C_Sub=zeros(1,length(Necesidades_prod));
C_MO_O=zeros(1,length(Necesidades_prod));

%Matriz de costes y nivel de servicio
Costes=[C_MO;C_Var_MO;C_Prod_he;C_Sub;C_MO_O;C_Inv_final]
Coste_total=sum(sum(Costes))
Nivel_servicio=round((sum(Prod_regular)+sum(Prod_he)+sum(Subcontratacion)+sum(Inventario_final.*(Inventario_final<0)))/sum(Necesidades_prod)*100,1)

%% Estrategia de nivelación de la producción por periodo
MO=ceil((sum(Necesidades_prod)/length(Necesidades_prod)*he_u_f/he_o_d)./dias_prod);%Mano de Obra
H_MO_regular=he_o_d*MO.*dias_prod;
Prod_regular=floor(H_MO_regular/he_u_f);%Producción regular

C_MO=Prod_regular*(he_u_f*C_mo); %Costes MO

Var_MO=zeros(1,length(MO)); %Variación MO
aux1=MO(1)-Plantilla;
Var_MO(1)=aux1*(abs(aux1)>=Plantilla_fija)+(Plantilla_fija-Plantilla)*(abs(aux1)<Plantilla_fija);
for i=2:length(MO)
   Var_MO(i)=MO(i)-MO(i-1);
end
C_Var_MO=zeros(1,length(MO)); %Costes Variación MO
for i=1:length(Var_MO)
   if Var_MO(i)<=0
       C_Var_MO(i)=C_desp*abs(Var_MO(i));
   else
       C_Var_MO(i)=C_con*Var_MO(i);
   end
end

Inventario_final=zeros(1,length(Prod_regular)); %Inventario final
Inventario_final(1)=Inv_ini+Prod_regular(1)-Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i);
end
C_Inv_final=zeros(1,length(Prod_regular)); %Costes inventario final
for i=1:length(C_Inv_final)
   if Inventario_final(i)<0
       C_Inv_final(i)=C_pos*abs(Inventario_final(i));
   else
       C_Inv_final(i)=(Inventario_final(i)+Inventario_final(i-1))/2*C_pos_u;
   end
end
Prod_he=zeros(1,length(Necesidades_prod));
Subcontratacion=zeros(1,length(Necesidades_prod));
C_Prod_he=zeros(1,length(Necesidades_prod));
C_Sub=zeros(1,length(Necesidades_prod));
C_MO_O=zeros(1,length(Necesidades_prod));

%Matriz de costes y nivel de servicio
Costes=[C_MO;C_Var_MO;C_Prod_he;C_Sub;C_MO_O;C_Inv_final]
Coste_total=sum(sum(Costes))
Nivel_servicio=round((sum(Prod_regular)+sum(Prod_he)+sum(Subcontratacion)+sum(Inventario_final.*(Inventario_final<0)))/sum(Necesidades_prod)*100,1)


%% Estrategia mixta 1: caza + niv MO

moda=mode(Necesidades_prod);
indice_sim=0.3; %Indice de similitud para la nivelacion

Periodos_niv=(moda*(1-indice_sim)<=Necesidades_prod)&(Necesidades_prod<=moda*(1+indice_sim));
for i=2:length(Periodos_niv)
   if Periodos_niv(i-1)==1 && Periodos_niv(i+1)==1
      Periodos_niv(i)=1; 
   end
end
Prod_regular=zeros(1,length(Necesidades_prod));
%Caza
Prod_regular_c=zeros(1,length(Necesidades_prod));%Producción regular
for i=1:length(Necesidades_prod)
    if Necesidades_prod(i)<=(Plantilla_max*he_o_d*dias_prod(i)/he_u_f)
       Prod_regular_c(i)=Necesidades_prod(i);
    else
        Prod_regular_c(i)=Plantilla_max*he_o_d*dias_prod(i)/he_u_f;
    end
end
Prod_regular_c=(Periodos_niv==0).*Prod_regular_c;

MO_c=zeros(1,length(Prod_regular)); %Mano de obra
C_MO_O_c=zeros(1,length(Prod_regular)); %Costes mano de obra oficiosa

for i=1:length(Prod_regular_c)
   a=ceil(Prod_regular_c(i)*(he_u_f/dias_prod(i)/he_o_d));
   if a>=Plantilla_fija
       MO_c(i)=a;
   else
       MO_c(i)=Plantilla_fija;
       %Coste de mano de obra oficiosa
       C_MO_O_c(i)=(Plantilla_fija*dias_prod(i)*he_o_d-Prod_regular_c(i)*he_u_f)*C_mo_o;
   end
   
end

MO_c=(Periodos_niv==0).*MO_c;
Prod_regular_c=floor(he_o_d/he_u_f*MO_c.*dias_prod);%Actualización de la prod reg en funcion del redondeo de MO
C_MO_O_c=(Periodos_niv==0).*C_MO_O_c;

C_MO_c=Prod_regular_c*(he_u_f*C_mo); %Costes MO

% Nivelacion MO
Horizonte_planif=sum(dias_prod.*Periodos_niv); %Horizonte de planificación del PAP en días
Niv_MO=ceil(sum(Necesidades_prod.*Periodos_niv)/Horizonte_planif*he_u_f/8); %MO necesaria
%Prod_regular_niv=ceil(sum(Necesidades_prod.*Periodos_niv)/Horizonte_planif)*(dias_prod.*Periodos_niv);
Prod_regular_niv=floor(Niv_MO*he_o_d/he_u_f*dias_prod).*Periodos_niv;

MO_niv=Niv_MO*ones(1,length(Prod_regular)).*(Periodos_niv==1);%MO
C_MO_niv=Prod_regular_niv*(he_u_f*C_mo); %Costes MO

%Union caza+niv MO con 100% de nivel de servicio
MO=MO_c+MO_niv;
C_MO=C_MO_c+C_MO_niv;
C_MO_O=C_MO_O_c;
H_MO_regular=he_o_d*MO.*dias_prod;

Var_MO=zeros(1,length(MO)); %Variación MO
aux1=MO(1)-Plantilla;
Var_MO(1)=aux1*(abs(aux1)>=Plantilla_fija)+(Plantilla_fija-Plantilla)*(abs(aux1)<Plantilla_fija);
for i=2:length(MO)
   Var_MO(i)=MO(i)-MO(i-1);
end
C_Var_MO=zeros(1,length(MO)); %Costes Variación MO
for i=1:length(Var_MO)
   if Var_MO(i)<=0
       C_Var_MO(i)=C_desp*abs(Var_MO(i));
   else
       C_Var_MO(i)=C_con*Var_MO(i);
   end
end


Prod_he=zeros(1,length(Necesidades_prod));%Producción en horas extra
C_Prod_he=zeros(1,length(Necesidades_prod));%Coste prod he
Subcontratacion=zeros(1,length(Necesidades_prod));%Subcontratación
C_Sub=zeros(1,length(Necesidades_prod)); %Coste subcontratación

C_delta_he=(C_mo_ex-C_mo)*he_u_f; %Coste incremental de MO extra en u.m./unidad


Prod_regular=Prod_regular_c+Prod_regular_niv;
Inventario_final=zeros(1,length(Prod_regular)); %Inventario final
Inventario_final(1)=Inv_ini+Prod_regular(1)-Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i);
    if Inventario_final(i)<0
       Nec_nc=Necesidades_prod(i)-Prod_regular(i)-Inventario_final(i-1);%Necesidades no cubiertas [u]
       if C_delta_he<C_sub
           h_ex_disp=h_ex_m*(Prod_regular(i)*he_u_f); %Horas extra disponibles
           h_ex_todo=min(h_ex_disp,Nec_nc*he_u_f);
           Prod_he(i)=floor(h_ex_todo/he_u_f); 
           Subcontratacion(i)=Nec_nc-Prod_he(i);
       else
           Subcontratacion(i)=Nec_nc;
       end
       Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i)+Prod_he(i)+Subcontratacion(i);
    end
    
end
C_Prod_he=Prod_he*he_u_f*C_mo_ex;
C_Sub=Subcontratacion*(C_mo_ex+C_sub);

C_Inv_final=zeros(1,length(Prod_regular)); %Costes inventario final
C_Inv_final(1)=(Inventario_final(1)<0)*C_pos*abs(Inventario_final(1))+(Inventario_final(1)<=0)*(Inventario_final(i)+Inv_ini)/2*C_pos_u;
for i=2:length(C_Inv_final)
   if Inventario_final(i)<0
       C_Inv_final(i)=C_pos*abs(Inventario_final(i));
   else
       C_Inv_final(i)=(Inventario_final(i)+Inventario_final(i-1))/2*C_pos_u;
   end
end

%Matriz de costes y nivel de servicio
Costes=[C_MO;C_Var_MO;C_Prod_he;C_Sub;C_MO_O;C_Inv_final]
Coste_total=sum(sum(Costes))
Nivel_servicio=round((sum(Prod_regular)+sum(Prod_he)+sum(Subcontratacion)+sum(Inventario_final.*(Inventario_final<0)))/sum(Necesidades_prod)*100,1)


%% Garantizar el 100% de nivel de servicio
Prod_he=zeros(1,length(Necesidades_prod));%Producción en horas extra
C_Prod_he=zeros(1,length(Necesidades_prod));%Coste prod he
Subcontratacion=zeros(1,length(Necesidades_prod));%Subcontratación
C_Sub=zeros(1,length(Necesidades_prod)); %Coste subcontratación

C_delta_he=(C_mo_ex-C_mo)*he_u_f; %Coste incremental de MO extra en u.m./unidad

for i=1:length(Inventario_final)
   if Inventario_final(i)<0
       Nec_nc=Necesidades_prod(i)-Prod_regular(i)-Inventario_final(i-1);%Necesidades no cubiertas [u]
       if C_delta_he<C_sub
           h_ex_disp=h_ex_m*(Prod_regular(i)*he_u_f); %Horas extra disponibles
           h_ex_todo=min(h_ex_disp,Nec_nc*he_u_f);
           Prod_he(i)=h_ex_todo/he_u_f; 
           Subcontratacion(i)=Nec_nc-Prod_he(i);
       else
           Subcontratacion(i)=Nec_nc;
       end
   end
end
C_Prod_he=Prod_he*he_u_f*C_mo_ex;
C_Sub=Subcontratacion*(C_mo_ex+C_sub);

%Actualización inventario final
Inventario_final(1)=Inv_ini+Prod_regular(1)-Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-Necesidades_prod(i)+Prod_he(i)+Subcontratacion(i);
end
C_Inv_final=zeros(1,length(Prod_regular)); %Costes inventario final
C_Inv_final(1)=(Inventario_final(1)<0)*C_pos*abs(Inventario_final(1))+(Inventario_final(1)<=0)*(Inventario_final(i)+Inv_ini)/2*C_pos_u;
for i=2:length(C_Inv_final)
   if Inventario_final(i)<0
       C_Inv_final(i)=C_pos*abs(Inventario_final(i));
   else
       C_Inv_final(i)=(Inventario_final(i)+Inventario_final(i-1))/2*C_pos_u;
   end
end


