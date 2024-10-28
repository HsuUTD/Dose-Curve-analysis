format longG

% pick the Excel file with raw histogram data for all doses
% Formatting -
% columns 1&2: AFM histogram data for substrate height
% columns 4&5: AFM histogram data for film height
% Note: does not work with empty sheets, if a dose value is not present,
% just remove the sheet from the excel file
[file,path] = uigetfile('*.xlsx');

% Dose values included in excel file
doseValues = [10 20 40 60 80 100 200 400 600 800 1000 2000 4000 6000 8000];

histData = cell(1,size(doseValues,2));

% Read data for each dose
for i = 1:length(doseValues)
    try
        histData{i} = readmatrix(fullfile(path,file), 'Sheet', num2str(doseValues(i)));
    catch
        histData{i} = zeros(5);
    end
end

% Add all dose, thickness, and std data to a single array
doseData = [];
nonzero = false;
for i = 1:length(doseValues)
    dose = doseValues(i);
    data = histData{i};
    resistData = data(:,1:2);
    [resist_x0, resist_width] = manualHisFit(resistData);
    resist_sigma = resist_width / sqrt(2);

    substrateData = data(:,4:5);
    [substrate_x0, substrate_width] = manualHisFit(substrateData);
    substrate_sigma = substrate_width / sqrt(2);

    thickness = resist_x0 - substrate_x0;
    if thickness == 0
        standv = 0;
    elseif thickness < 0
        thickness = abs(thickness);
        standv = sqrt(resist_sigma^2 + substrate_sigma^2);
    else
        nonzero = true;
        standv = sqrt(resist_sigma^2 + substrate_sigma^2);
    end
    
    dataPoint = [dose thickness standv];
    if ~(thickness == 0 & nonzero)
        doseData = [doseData; dataPoint];
    end
end


% Take t0 average from points above 400uC and normalize thickness values
upperpoints = [];
sz = size(doseData(:,1));
for i = 1:sz
    if doseData(i,1) > 399
        upperpoints = [upperpoints doseData(i,2)];
    end
end
thk = mean(upperpoints);
thicknorm = zeros(sz);
stdnorm = zeros(sz);
for i = 1:sz
    thicknorm(i) = doseData(i,2) / thk;
    stdnorm(i) = doseData(i,3) / thk;
end

normalizedDoseData = [doseData(:,1),thicknorm,stdnorm];

% make error bar dose curve plot
hold on
errorbar(doseData(:,1),thicknorm,stdnorm,'sk','MarkerFaceColor','white')
set(gca, 'XScale', 'log')

ax = gca;
ax.TickLength = [0.025 0.035];
ax.LineWidth = 1.0;
legend('off')
xlim([9,10^4])
ylim([-0.05,1.3])
hold off


% Logistic Fuction fitting curve
dsfo = fitoptions('Method','NonlinearLeastSquares','Lower',[0,0],'Upper',[100,1000]);
dsft = fittype('1/(1+10^(a*log10(b/x)))','options',dsfo);

[dosefit,gof] = fit(doseData(:,1),thicknorm,dsft);

hold on
fun = plot(dosefit);
set(fun, 'color', 'black', 'LineWidth', 1)
xlabel('Dose (\muC/cm^{2})')
ylabel('Relative resist thickness')

%%%%%%%%%%%%%%%%%
% workaround to get rid of top and right axis ticks while keeping box outline
% get handle to current axes
a = gca;
% set box property to off and remove background color
set(a,'box','off','color','none')
% create new, empty axes with box but without ticks
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
b.LineWidth = 1.0;
% set original axes as active
axes(a)
% link axes in case of zooming
linkaxes([a b])
%%%%%%%%%%%%%%%%%

hold off

% Dose curve data
coeffvals = coeffvalues(dosefit);
a = coeffvals(1); % amplitude
b = coeffvals(2); % steepness
k = a*log(10)/4; % max slope (on log10 scale)
d50 = coeffvals(2); % midpoint

rsquare = gof.rsquare;
rmse = gof.rmse;

d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);

%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));


% fit curve data for external ploting
dosevals = logspace(-1,5).';

curvefit = dosefit(dosevals);

curvedata = [dosevals, curvefit];



% function for obtaining film thickness from AFM data
% 'data' should be formatted as 5 column matrix
% columns 1&2: AFM histrogram data of substrate height
% column 4&5: AFM histogram data of film height
function [x0, width] = manualHisFit(data)
    distance = data(:,1);
    distance = 1e9 * distance; % convert x-
    counts = data(:,2);
    [M,I] = max(counts);
    fo = fitoptions('Method','NonlinearLeastSquares', 'Start', [M, distance(I), 5, 0]);
    ft = fittype('a*exp(-((x-b)/c)^2)+d','options',fo);
    [f,gof] = fit(distance, counts, ft);
    coeffvals = coeffvalues(f);
    x0 = coeffvals(2);
    width = coeffvals(3);
end