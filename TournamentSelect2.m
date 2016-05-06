function iSelected = TournamentSelect2(rank,crowdDistance,tournamentSelectionParameter)

populationSize = size(rank,2);
iTmp1 = 1 + fix(rand*populationSize);
iTmp2 = 1 + fix(rand*populationSize);
r = rand;
if (r < tournamentSelectionParameter)
    if (rank(iTmp1) <= rank(iTmp2))||((rank(iTmp1) == rank(iTmp2))&&(crowdDistance(iTmp1) > crowdDistance(iTmp2)))
        iSelected = iTmp1;
    else
        iSelected = iTmp2;
    end
else
    if (rank(iTmp1) <= rank(iTmp2))||((rank(iTmp1) == rank(iTmp2))&&(crowdDistance(iTmp1) > crowdDistance(iTmp2)))
        iSelected = iTmp2;
    else
        iSelected = iTmp1;
    end
end