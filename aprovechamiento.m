function [aprov,cargas] = aprovechamiento(X,ind)
aprov=[];
a=ind;
cargas=zeros(length(X.ruta),4);

for i=length(X.ruta):-1:1
    a=a/X.ruta(i).a;
    cargas(i,X.ruta(i).ct)=round(a*X.ruta(i).t_carga,2);
    aprov=[aprov, round(a,2)];
end

end