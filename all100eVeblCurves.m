% Fitting normalized EBL 100eV dose curve data to logistic/sigmoidal
% function
format longG

% Data for E-Beam 100eV plot
T100eV_set3 = readmatrix('122123_100eV_MV.xlsx', 'Sheet', 'new solution 1st set 100eV', 'Range', 'A1:C15');
T100eV_set4 = readmatrix('122123_100eV_MV.xlsx', 'Sheet', 'new solution 2nd set 100eV', 'Range', 'A1:C10');

T100eV_set5 = readmatrix('121523_100eV.xlsx', 'Sheet', 'Dry 2MOE batch 112023 1st set', 'Range', 'A1:C10');
T100eV_set6 = readmatrix('121523_100eV.xlsx', 'Sheet', 'Dry 2MOE batch 112023 2nd set', 'Range', 'A1:C10');
T100eV_set7 = readmatrix('121523_100eV.xlsx', 'Sheet', 'with optical 1st set 100 eV', 'Range', 'A1:C15');
T100eV_set8 = readmatrix('121523_100eV.xlsx', 'Sheet', 'with optical 2nd set 100 eV', 'Range', 'A1:C11');
T100eV_set9 = readmatrix('121523_100eV.xlsx', 'Sheet', 'without optical 1st set 100 eV', 'Range', 'A1:C15');
T100eV_set10 = readmatrix('121523_100eV.xlsx', 'Sheet', 'without optical 2nd set 100 eV', 'Range', 'A1:C10');
T100eV_set11 = readmatrix('021423_EBL_run.xlsx', 'Sheet', 'Sheet1', 'Range', 'A1:C15');
T100eV_set12 = readmatrix('050423_curvedata.xlsx', 'Sheet', 'Sheet1', 'Range', 'A1:C14');



% Normalize thickness and std
norm_set3 = mean(T100eV_set3(8:15,2));
norm_set4 = mean(T100eV_set4(8:10,2));
norm_set5 = mean(T100eV_set5(8:10,2));
norm_set6 = mean(T100eV_set6(8:10,2));
norm_set7 = mean(T100eV_set7(8:15,2));
norm_set8 = mean(T100eV_set8(8:11,2));
norm_set9 = mean(T100eV_set9(8:15,2));
norm_set10 = mean(T100eV_set10(8:10,2));
norm_set11 = mean(T100eV_set11(1:8,2));
norm_set12 = mean(T100eV_set12(7:14,2));


T100eV_set3(:,2) = T100eV_set3(:,2)/norm_set3;
T100eV_set3(:,3) = T100eV_set3(:,3)/norm_set3;
T100eV_set4(:,2) = T100eV_set4(:,2)/norm_set4;
T100eV_set4(:,3) = T100eV_set4(:,3)/norm_set4;
T100eV_set5(:,2) = T100eV_set5(:,2)/norm_set5;
T100eV_set5(:,3) = T100eV_set5(:,3)/norm_set5;
T100eV_set6(:,2) = T100eV_set6(:,2)/norm_set6;
T100eV_set6(:,3) = T100eV_set6(:,3)/norm_set6;
T100eV_set7(:,2) = T100eV_set7(:,2)/norm_set7;
T100eV_set7(:,3) = T100eV_set7(:,3)/norm_set7;
T100eV_set8(:,2) = T100eV_set8(:,2)/norm_set8;
T100eV_set8(:,3) = T100eV_set8(:,3)/norm_set8;
T100eV_set9(:,2) = T100eV_set9(:,2)/norm_set9;
T100eV_set9(:,3) = T100eV_set9(:,3)/norm_set9;
T100eV_set10(:,2) = T100eV_set10(:,2)/norm_set10;
T100eV_set10(:,3) = T100eV_set10(:,3)/norm_set10;
T100eV_set11(:,2) = T100eV_set11(:,2)/norm_set11;
T100eV_set11(:,3) = T100eV_set11(:,3)/norm_set11;
T100eV_set12(:,2) = T100eV_set12(:,2)/norm_set12;
T100eV_set12(:,3) = T100eV_set12(:,3)/norm_set12;


% Logistic function fitting
dsfo = fitoptions('Method','NonlinearLeastSquares','Lower',[0,0],'Upper',[100,1000]);
dsft = fittype('1/(1+10^(a*log10(b/x)))','options',dsfo);

[dosefit_set3,gof3] = fit(T100eV_set3(:,1),T100eV_set3(:,2),dsft);
[dosefit_set4,gof4] = fit(T100eV_set4(:,1),T100eV_set4(:,2),dsft);

[dosefit_set5,gof5] = fit(T100eV_set5(:,1),T100eV_set5(:,2),dsft);
[dosefit_set6,gof6] = fit(T100eV_set6(:,1),T100eV_set6(:,2),dsft);
[dosefit_set7,gof7] = fit(T100eV_set7(:,1),T100eV_set7(:,2),dsft);
[dosefit_set8,gof8] = fit(T100eV_set8(:,1),T100eV_set8(:,2),dsft);
[dosefit_set9,gof9] = fit(T100eV_set9(:,1),T100eV_set9(:,2),dsft);
[dosefit_set10,gof10] = fit(T100eV_set10(:,1),T100eV_set10(:,2),dsft);
[dosefit_set11,gof11] = fit(T100eV_set11(:,1),T100eV_set11(:,2),dsft);
[dosefit_set12,gof12] = fit(T100eV_set12(:,1),T100eV_set12(:,2),dsft);



% make error bar dose curve plots
hold on
errorbar(T100eV_set3(:,1),T100eV_set3(:,2),T100eV_set3(:,3),'sr','MarkerFaceColor','red')
errorbar(T100eV_set4(:,1),T100eV_set4(:,2),T100eV_set4(:,3),'s','Color', "#77AC30",'MarkerFaceColor', "#77AC30")

errorbar(T100eV_set7(:,1),T100eV_set7(:,2),T100eV_set7(:,3),'sb','MarkerFaceColor','blue')
errorbar(T100eV_set8(:,1),T100eV_set8(:,2),T100eV_set8(:,3),'s','Color',"#4DBEEE",'MarkerFaceColor',"#4DBEEE")
errorbar(T100eV_set9(:,1),T100eV_set9(:,2),T100eV_set9(:,3),'sm','MarkerFaceColor', 'magenta')
errorbar(T100eV_set10(:,1),T100eV_set10(:,2),T100eV_set10(:,3),'s','Color',"#EDB120",'MarkerFaceColor', "#EDB120")
errorbar(T100eV_set11(:,1),T100eV_set11(:,2),T100eV_set11(:,3),'s','Color',"#A2142F",'MarkerFaceColor',"#A2142F")
errorbar(T100eV_set12(:,1),T100eV_set12(:,2),T100eV_set12(:,3),'sk','MarkerFaceColor','black')



yticks([0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4]);
set(gca, 'XScale', 'log', 'YMinorTick', 'on');

ax = gca;
ax.TickLength = [0.025 0.035];
ax.LineWidth = 1.0;

xlim([1,10^4]);
ylim([-0.05,1.5]);

fun3 = plot(dosefit_set3);
set(fun3, 'color', 'red', 'LineWidth', 1);
fun4 = plot(dosefit_set4);
set(fun4, 'color', "#77AC30", 'LineWidth', 1);


fun7 = plot(dosefit_set7);
set(fun7, 'color', 'blue', 'LineWidth', 1);
fun8 = plot(dosefit_set8);
set(fun8, 'color', "#4DBEEE", 'LineWidth', 1);
fun9 = plot(dosefit_set9);
set(fun9, 'color', 'magenta', 'LineWidth', 1);
fun10 = plot(dosefit_set10);
set(fun10, 'color', "#EDB120", 'LineWidth', 1);
fun11 = plot(dosefit_set11);
set(fun11, 'color', "#A2142F", 'LineWidth', 1);
fun12 = plot(dosefit_set12);
set(fun12, 'color', 'black', 'LineWidth', 1);

xlabel('Dose (\muC/cm^{2})');
ylabel('Normalized Thickness');
legend('off');
legend('122123 New Solution 1st Set', '122123 New Solution 2nd Set', '121523 With optical 1st set', ...
    '121523 With optical 2nd set', '121523 Without optical 1st set','121523 Without optical 2nd set', ...
    '021423 EBL Run', '050423 EBL Run', 'Location', 'northwest');
legend('boxoff');

set(gcf, 'Position', [200 200 650 450]);

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


coeffvals_set3 = coeffvalues(dosefit_set3);
a = coeffvals_set3(1); % k
b = coeffvals_set3(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set3(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('new solution 1st set');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set4 = coeffvalues(dosefit_set4);
a = coeffvals_set4(1); % k
b = coeffvals_set4(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set4(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('new solution 2nd set');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set7 = coeffvalues(dosefit_set7);
a = coeffvals_set7(1); % k
b = coeffvals_set7(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set7(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('with optical 1st set 100 eV');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set8 = coeffvalues(dosefit_set8);
a = coeffvals_set8(1); % k
b = coeffvals_set8(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set8(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('with optical 2nd set 100 eV');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set9 = coeffvalues(dosefit_set9);
a = coeffvals_set9(1); % k
b = coeffvals_set9(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set9(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('without optical 1st set 100 eV');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set10 = coeffvalues(dosefit_set10);
a = coeffvals_set10(1); % k
b = coeffvals_set10(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set10(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('without optical 2nd set 100 eV');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set11 = coeffvalues(dosefit_set11);
a = coeffvals_set11(1); % k
b = coeffvals_set11(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set11(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('021423 EBL Run');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_set12 = coeffvalues(dosefit_set12);
a = coeffvals_set12(1); % k
b = coeffvals_set12(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_set12(2);
d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);
%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));
disp('050423 EBL Run');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);





% get numerical array for fit curves for external plotting
dosevalues = logspace(-1,5).';

curvefit_set11 = dosefit_set11(dosevalues);

curvedata = [dosevalues, curvefit_set11];
