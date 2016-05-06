clear all
populationSize = 100;
numberOfGenes = 40;
crossoverProbability = 0.9;
mutationProbability = 0.08;
tournamentSelectionParameter = 0.75;
numberOfGenerations = 300;

fitness = zeros(populationSize,1);

population = InitializePopulation(populationSize,numberOfGenes);

for iGeneration = 1:numberOfGenerations
    
    for i = 1:populationSize
        chromosome = population(i,:);
        x = DecodeChromosome(chromosome);
        f(i,:) = EvaluateIndividual(x); %[f1,f2]
    end
    
    [F,rank] = fast_non_dominated_sort(f); 
    fitness = rank;
    fP0 = f;
    
    for i = 1:2:populationSize
        %---Selection
        if(iGeneration>1) %Select based on rank and distance
            i1 = TournamentSelect2(fitness,crowdDistance,tournamentSelectionParameter);
            i2 = TournamentSelect2(fitness,crowdDistance,tournamentSelectionParameter);
        else % Select based on rank
            i1 = TournamentSelect(fitness,tournamentSelectionParameter);
            i2 = TournamentSelect(fitness,tournamentSelectionParameter);            
        end
        chromosome1 = population(i1,:);
        chromosome2 = population(i2,:);
        %---CrossOver
        r = rand;
        if (r < crossoverProbability)
            newChromosomePair = Cross(chromosome1,chromosome2);
            tempPopulation(i,:) = newChromosomePair(1,:);
            tempPopulation(i+1,:) = newChromosomePair(2,:);
        else
            tempPopulation(i,:) = chromosome1;
            tempPopulation(i+1,:) = chromosome2;
        end
    end % Loop over population
    %--- Mutation
    for i = 1:populationSize
        originalChromosome = tempPopulation(i,:);
        mutatedChromosome = Mutate(originalChromosome,mutationProbability);
        tempPopulation(i,:) = mutatedChromosome;
    end
    %-- evaluate Q0
      for i = 1:populationSize
        chromosome = tempPopulation(i,:);
        x = DecodeChromosome(chromosome);
        fQ0(i,:) = EvaluateIndividual(x); %[f1,f2]
      end
    %-- We have fQ0 amd fP0
    Q0 = tempPopulation; 
    P0 = population;
    R0 = [P0;Q0]; % The new population of size 2N
    
    fR0 = [fP0;fQ0] ;
    F = fast_non_dominated_sort(fR0);
    
    P1 = [];i = 1;crowdDistance=[];
    while(size(P1,1)+size(F(i).point,2)<= populationSize)
        newCrowdDistance=CrowdingDistanceAssignment(fR0(F(i).point,:),max(fR0),min(fR0));
        crowdDistance = [crowdDistance; newCrowdDistance];
        
        newR0=R0(F(i).point,:);
        P1 = [P1; newR0];
        i = i + 1;
    end;
    I_dist=CrowdingDistanceAssignment(fR0(F(i).point,:),max(fR0),min(fR0));
    [I_dist_sorted,crowdRank]=sort(I_dist);
    j=1;
    for i=(size(P1,1)+1):populationSize
       crowdDistance = [crowdDistance;  I_dist_sorted(j)];
       P1 = [P1; R0(crowdRank(j),:)];
       j=j+1;
    end
    
    population = P1; %P1 is the new population
end

%----------- PF is the level.1 of the last population
    for i = 1:populationSize
        chromosome = population(i,:);
        x = DecodeChromosome(chromosome);
        f(i,:) = EvaluateIndividual(x); %[f1,f2]
    end    
    PF = fast_non_dominated_sort(f);
    
    plot(f(PF(1).point,1),f(PF(1).point,2),'o')
    objective=[f(PF(1).point,1) f(PF(1).point,1)];
    save('objective.mat','objective');
