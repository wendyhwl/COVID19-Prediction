function SIR(beta, gamma, country)
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

    %% Figure from base data
    figure
    plot(t, confirmed_all, t, deaths_all, t, recovered_all);
    xlabel("Date");
    ylabel("Number of People");
    title("COVID-19 Statistics: " + fig_title + " (\beta = " + beta + ", \gamma = " + gamma + ")");
    legend("Confirmed", "Deaths", "Recovered", "Location", "northwest");
    hold off;

    %% Set up SIR model
    recovered_all = recovered_all + deaths_all;
    confirmed_all = confirmed_all - recovered_all;
    I0 = max(confirmed_all(1), 1);
    R0 = recovered_all(1);
    S0 = total_pop - I0 - R0;
    tspan = linspace(0, length(t) * 8);
    [S, I, R, tt] = generateSIR(S0, I0, R0, tspan, beta, gamma, total_pop);

    %% Projecting to total population
    figure
    plot(tt, S, tt, I, tt, R);
    xlabel("Days");
    ylabel("Number of People");
    title("COVID-19 Population Projections: " + fig_title + " (\beta = " + beta + ", \gamma = " + gamma + ")");
    legend("Susceptible", "Infected", "Recovered", "Location", "northwest");
    hold off;

    %% Projections and actual numbers
    len_t = 0:length(t)-1;
    figure
    plot(len_t, confirmed_all, '-o', len_t, recovered_all, '-o', tt, S, tt, I, tt, R);
    xlabel("Days");
    ylabel("Number of People");
    %ylim([0 2000000]);
    title("COVID-19 Actual vs. Projected: " + fig_title + " (\beta = " + beta + ", \gamma = " + gamma + ")");
    legend("Actual infected", "Actual recovered", "Projected susceptible", "Projected infected", "Projected recovered", "Location", "northeast");

end

function [S, I, R, tt] = generateSIR(S0, I0, R0, tspan, beta, gamma, N)
    y0 = [S0 I0 R0];
    [tt, yy] = ode45(@(t, y) Diff(y, beta, gamma, N), tspan, y0);

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