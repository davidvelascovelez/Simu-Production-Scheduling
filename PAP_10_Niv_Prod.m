function OUTPUT = PAP_10_Niv_Prod(INPUT)

MO=ceil((sum(INPUT.Necesidades_prod)/length(INPUT.Necesidades_prod)*INPUT.he_u_f/INPUT.he_o_d)./INPUT.dias_prod);%Mano de Obra
H_MO_regular=INPUT.he_o_d*MO.*INPUT.dias_prod;
Prod_regular=floor(H_MO_regular/INPUT.he_u_f);%Producción regular

C_MO=Prod_regular*(INPUT.he_u_f*INPUT.C_mo); %Costes MO

Var_MO=zeros(1,length(MO)); %Variación MO
aux1=MO(1)-INPUT.Plantilla;
Var_MO(1)=aux1*(abs(aux1)>=INPUT.Plantilla_fija)+(INPUT.Plantilla_fija-INPUT.Plantilla)*(abs(aux1)<INPUT.Plantilla_fija);
for i=2:length(MO)
   Var_MO(i)=MO(i)-MO(i-1);
end
C_Var_MO=zeros(1,length(MO)); %Costes Variación MO
for i=1:length(Var_MO)
   if Var_MO(i)<=0
       C_Var_MO(i)=INPUT.C_desp*abs(Var_MO(i));
   else
       C_Var_MO(i)=INPUT.C_con*Var_MO(i);
   end
end

Inventario_final=zeros(1,length(Prod_regular)); %Inventario final
Inventario_final(1)=INPUT.Inv_ini+Prod_regular(1)-INPUT.Necesidades_prod(1);
for i=2:length(Prod_regular)
    Inventario_final(i)=Inventario_final(i-1)+Prod_regular(i)-INPUT.Necesidades_prod(i);
end
C_Inv_final=zeros(1,length(Prod_regular)); %Costes inventario final
for i=1:length(C_Inv_final)
   if Inventario_final(i)<0
       C_Inv_final(i)=INPUT.C_pos*abs(Inventario_final(i));
   else
       C_Inv_final(i)=(Inventario_final(i)+Inventario_final(i-1))/2*INPUT.C_pos_u;
   end
end
Prod_he=zeros(1,length(INPUT.Necesidades_prod));
Subcontratacion=zeros(1,length(INPUT.Necesidades_prod));
C_Prod_he=zeros(1,length(INPUT.Necesidades_prod));
C_Sub=zeros(1,length(INPUT.Necesidades_prod));
C_MO_O=zeros(1,length(INPUT.Necesidades_prod));

%Matriz de costes y nivel de servicio
Costes=[C_MO;C_Var_MO;C_Prod_he;C_Sub;C_MO_O;C_Inv_final];
Tabla=[INPUT.Necesidades_prod;INPUT.dias_prod;Prod_regular;Prod_he;Subcontratacion;...
    H_MO_regular;MO;C_MO;C_MO_O;Var_MO;C_Var_MO;C_Prod_he;C_Sub;Inventario_final;C_Inv_final;sum(Costes)];
Coste_total=sum(sum(Costes));
Nivel_servicio=round((sum(Prod_regular)+sum(Prod_he)+sum(Subcontratacion)+sum(Inventario_final.*(Inventario_final<0)))/sum(INPUT.Necesidades_prod)*100,1);

%OUTPUT
OUTPUT=struct('Tabla',Tabla,'Coste_total',Coste_total,'Nivel_servicio',Nivel_servicio);

end