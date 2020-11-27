function cost = findCost(beta, gamma, country)
    %% Converting csv data to matlab
    confirmed = readmatrix('covid_confirmed.csv');
    deaths = readmatrix('covid_deaths.csv');
    recovered = readmatrix('covid_recovered.csv');
    data = readtable('covid_confirmed.csv');

    confirmed = confirmed(2:end, 53:end);
    deaths = deaths(2:end, 53:end);
    recovered = recovered(2:end, 53:end);
    dates = table2array(data(1, 53:end));

    % If country name is passed as argument, use data for specific country.
    % Else, use global data.
    if nargin == 3
        country_cells = strfind(data.Var2, country);
        country_indices = find(~cellfun(@isempty, country_cells));
        confirmed_all = sum(confirmed(country_indices-1, :), 1);
        deaths_all = sum(deaths(country_indices-1, :), 1);
        recovered_all = sum(recovered(country_indices-1, :), 1);
        
        all_pops = load('pop.mat');
        all_pops = all_pops.country_pop;
        pop_index = find(all_pops == country);
        total_pop = str2num(all_pops(pop_index, 2));
        fig_title = country;
    elseif nargin == 2
        confirmed_all = sum(confirmed, 1);
        deaths_all = sum(deaths, 1);
        recovered_all = sum(recovered, 1);
        total_pop = 3.67049e+06;
        fig_title = "Global";
    else
        error("Must provide beta and gamma values.");
    end

    t1 = dates{1, 1};
    t2 = dates{1, end};
    t1 = strsplit(t1, "/");
    t2 = strsplit(t2, "/");
    t1 = datetime(2000 + str2num(t1{1, 3}), str2num(t1{1, 1}), str2num(t1{1, 2}), 0, 0, 0);
    t2 = datetime(2000 + str2num(t2{1, 3}), str2num(t2{1, 1}), str2num(t2{1, 2}), 0, 0, 0);
    t = t1:t2;

    %% Set up SIR model
    recovered_all = recovered_all + deaths_all;
    confirmed_all = confirmed_all - recovered_all;
    I0 = max(confirmed_all(1), 1);
    R0 = recovered_all(1);
    S0 = total_pop - I0 - R0;
    tspan = [0 length(t)*5];
    [S, I, R, tt] = generateSIR(S0, I0, R0, tspan, beta, gamma, total_pop);

    %% Calculate cost
    len_t = 1:length(t);
    ll=length(len_t);
    cost = 0;
    for j = 1:ll
        difference = abs(tt - len_t(j));
        [~,index] = min(difference);
        costI = abs(confirmed_all(j)-I(index))/confirmed_all(j);
        costJ = abs(recovered_all(j)-R(index))/recovered_all(j);
        cost = cost +(costI+costJ);
    end
end

function [S, I, R, tt] = generateSIR(S0, I0, R0, tspan, beta, gamma, N)
    y0 = [S0 I0 R0];
    [tt, yy] = ode23s(@(t, y) Diff(y, beta, gamma, N), tspan, y0);

    S = yy(:, 1);
    I = yy(:, 2);
    R = yy(:, 3);
end

function dSIR = Diff(y, beta, gamma, N)
    S = y(1);
    I = y(2);
    R = y(3);

    dSIR = [
        -beta * S * I/(N/1.6) ; 
        beta * S * I/(N/1.6) - gamma * I ; 
        gamma * I
    ];
end