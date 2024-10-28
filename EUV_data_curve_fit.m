% Fitting EUV dose curve to logistic/sigmoidal function and plotting
% Including vertical offset for minimum thickness
format longG

% Data for dose curve plots
T_data = readmatrix('data/EUV.xlsx', 'Sheet', 'Sheet1', 'Range', 'A1:B12');

% Calculate the fixed vertical offset
D = min(T_data(:,2));

% Modified logistic function fitting
% A: amplitude, B: steepness, C: midpoint
dsfo = fitoptions('Method','NonlinearLeastSquares',...
                  'Lower',[0,-Inf,0],...
                  'Upper',[Inf,Inf,Inf],...
                  'StartPoint',[max(T_data(:,2))-D, 1, median(T_data(:,1))]);
dsft = fittype(['A/(1+10^(B*log10(C/x)))+' num2str(D)],'options',dsfo);

[dosefit,gof] = fit(T_data(:,1),T_data(:,2),dsft);

% make error bar dose curve plot
figure;
hold on
scatter(T_data(:,1),T_data(:,2),'k','filled');

ax = gca;
ax.TickLength = [0.025 0.035];
ax.LineWidth = 1.0;

fun = plot(dosefit);
set(fun, 'color', 'red', 'LineWidth', 1);

xlabel('Dose (\muC/cm^{2})');
ylabel('Thickness');
legend('Data', 'Fitted Curve', 'Location', 'northwest');
legend('boxoff');

set(gcf, 'Position', [200 200 400 300]);

%%%%%%%%%%%%%%%%%
% workaround to get rid of top and right axis ticks while keeping box outline
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
b.LineWidth = 1.0;
axes(a)
linkaxes([a b])
%%%%%%%%%%%%%%%%%

hold off

% Dose curve data
coeffvals = coeffvalues(dosefit);
A = coeffvals(1); % amplitude
B = coeffvals(2); % steepness
k = B*log(10)/4; % max slope (on log10 scale)
C = coeffvals(3); % midpoint


% Calculate D0, D50, D100
d50 = C;
d0 = 10^(log10(C) - 0.5/k);
d100 = 10^(log10(C) + 0.5/k);

%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));

disp('Results:');
disp(['D100: ', num2str(d100)]);
disp(['gamma: ', num2str(gamma)]);

% get numerical array for fit curve for external plotting
dosevals = linspace(0, 70, 71).';
curvefit = dosefit(dosevals);

curvedata = [dosevals, curvefit];