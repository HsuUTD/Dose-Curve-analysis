% Fitting normalized 3 dose curves to logistic/sigmoidal funtion and
% plotting for E-beam paper
format longG

% Data for dose curve plots
T_E_gun = readmatrix('240724_Dose curve summary.xlsx', 'Sheet', 'In-nitrate E-gun', 'Range', 'A2:C7');
T_EBL = readmatrix('240724_Dose curve summary.xlsx', 'Sheet', 'EBL Indium nitrate', 'Range', 'A2:C16');
T_SnOxo = readmatrix('240724_Dose curve summary.xlsx', 'Sheet', 'SnOxo E-gun ', 'Range', 'A2:C9');

% Normalize thickness and std
norm_E_gun = T_E_gun(1,2);
norm_SnOxo = T_SnOxo(3,2);
norm_EBL = mean(T_EBL(1:8,2));

T_E_gun(:,2) = T_E_gun(:,2)/norm_E_gun;
T_E_gun(:,3) = T_E_gun(:,3)/norm_E_gun;
T_EBL(:,2) = T_EBL(:,2)/norm_EBL;
T_EBL(:,3) = T_EBL(:,3)/norm_EBL;
T_SnOxo(:,2) = T_SnOxo(:,2)/norm_SnOxo;
T_SnOxo(:,3) = T_SnOxo(:,3)/norm_SnOxo;


% Logistic function fitting
dsfo = fitoptions('Method','NonlinearLeastSquares','Lower',[0,0],'Upper',[100,1000]);
dsft = fittype('1/(1+10^(a*log10(b/x)))','options',dsfo);

[dosefit_E_gun,gof1] = fit(T_E_gun(:,1),T_E_gun(:,2),dsft);
[dosefit_EBL,gof2] = fit(T_EBL(:,1),T_EBL(:,2),dsft);
[dosefit_SnOxo,gof3] = fit(T_SnOxo(:,1),T_SnOxo(:,2),dsft);

% make error bar dose curve plots
hold on
errorbar(T_EBL(:,1),T_EBL(:,2),T_EBL(:,3),'sk','MarkerFaceColor','black');
errorbar(T_E_gun(:,1),T_E_gun(:,2),T_E_gun(:,3),'^r','MarkerFaceColor','red');
errorbar(T_SnOxo(:,1),T_SnOxo(:,2),T_SnOxo(:,3),'db','MarkerFaceColor','blue');

yticks([0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4]);
set(gca, 'XScale', 'log', 'YMinorTick', 'on');

ax = gca;
ax.TickLength = [0.025 0.035];
ax.LineWidth = 1.0;

xlim([1,10^4]);
ylim([-0.05,1.5]);

fun1 = plot(dosefit_E_gun);
set(fun1, 'color', 'red', 'LineWidth', 1);
fun2 = plot(dosefit_EBL);
set(fun2, 'color', 'black', 'LineWidth', 1);
fun3 = plot(dosefit_SnOxo);
set(fun3, 'color', 'blue', 'LineWidth', 1);


xlabel('Dose (\muC/cm^{2})');
ylabel('Normalized Thickness');
legend('off');
legend('EBL: Indium Nitrate','E-Beam: Indium Nitrate', 'E-Beam: SnOxo', 'Location', 'northwest');
legend('boxoff');
%pbaspect([2 1.5 1]);

set(gcf, 'Position', [200 200 400 300]);

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
coeffvals_Egun = coeffvalues(dosefit_E_gun);
a = coeffvals_Egun(1); % k
b = coeffvals_Egun(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_Egun(2);

d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);

%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));

disp('E-gun');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_EBL = coeffvalues(dosefit_EBL);
a = coeffvals_EBL(1); % k
b = coeffvals_EBL(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_EBL(2);

d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);

%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));

disp('EBL');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);


coeffvals_SnOxo = coeffvalues(dosefit_SnOxo);
a = coeffvals_SnOxo(1); % k
b = coeffvals_SnOxo(2);
k = a*log(10)/4; % max slope
d50 = coeffvals_SnOxo(2);

d100 = 10^(0.5/k + log10(d50));
d0 = 10^(log10(d50) - 0.5/k);

%extrapolated contrast gamma from maximum slope
gamma = 1 / (log10(d100/d0));

disp('SnOxo');
disp('D100');
disp(d100);
disp('gamma');
disp(gamma);

% get numerical array for fit curves for external plotting
dosevalues = logspace(-1,5).';

curvefit_EBL = dosefit_EBL(dosevalues);
curvefit_E_gun = dosefit_E_gun(dosevalues);
curvefit_SnOxo = dosefit_SnOxo(dosevalues);

curvedata = [dosevalues, curvefit_EBL, curvefit_E_gun, curvefit_SnOxo];



