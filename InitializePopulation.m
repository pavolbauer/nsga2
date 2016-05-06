function population = InitializePopulation(populationSize, numberOfGenes)

population = fix(2.0*rand(populationSize,numberOfGenes));
