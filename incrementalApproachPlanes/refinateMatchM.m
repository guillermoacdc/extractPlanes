function matchM = refinateMatchM(localPlanes,particlesVector,matchM)
%REFINATEMATCHM Depura la matriz matchM para evitar múltiples planos
%locales apuntando a la mism partícula. El plano de menor distancia es el
%plano que se prioriza
Nlp=size(matchM,1);
Npv=size(matchM,2);
for i=1:Npv
%     validate if there are multiple local planes pointing to a single
%     particle
    rows=find(matchM(:,i)==true);
    Nr=size(rows,1);
    if Nr>1
        distances=zeros(Nr,1);
        for j=1:Nr
            distances(j)=norm(localPlanes(rows(j)).geometricCenter-particlesVector(i).position);
        end
%       dejar vigente de forma exclusiva la relacion con el plano más
%       cercano
        [~,index]=min(distances);
        matchM(:,i)=myBoolean(zeros(Nlp,1));
        matchM(index,i)=true;        
    end
end


end

