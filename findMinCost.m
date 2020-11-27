betas = 0.08:0.01:0.12;
gammas = 0.02:0.001:0.04;

total = length(betas)*length(gammas);
k = 1;
for i = 1:length(betas)
    for j =1:length(gammas)
       disp(k + "/" + total);
       cost = findCost(betas(i), gammas(j));
       all_cost(i,j) = cost;
       k = k+1;
    end
end
minValue = min(all_cost,[],'all')

[beta_index,gamma_index] = find(all_cost==minValue);
min_b=betas(beta_index)
min_g=gammas(gamma_index)