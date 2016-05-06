function I_dist=CrowdingDistanceAssignment(I,fmax,fmin)
    %input: I - (population x function evaluation in m objectives)
    
    l=size(I,1); %size of population in set I
    m=size(I,2); %number of objectives
    I_dist=zeros(l,1);

    for i=1:m %loop over objectives
        [~,idx]=sort(I(:,i)); %sort according to the best values
        
        I_dist(idx(1))=inf; %set boundary solutions to infinity
        I_dist(idx(l))=inf;

        for j=2:l-1
            I_dist(idx(j))=I_dist(idx(j))+((I(idx(j+1),i)-I(idx(j-1),i))/ ...
                (fmax(i)-fmin(i))); %calculate crowding distance
        end
    end
end