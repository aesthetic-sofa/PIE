%% Engine setup - based on Toyota 2JZ data
cylinders_number=6; %[1]
piston_mass=380; %[g]
conrod_mass=635; %[g]
crank_mass=1430; %[g]
conrod_length=142; %[mm]
crank_length=43; %[mm]
crank_angles=[0 120 240 240 120 0]; %[deg]
piston_mass_variation_factor=0; %[%]
conrod_cog_factor=3; %[1]
idle_revs=650; %[rpm]
limiter_revs=6800; %[rpm]
max_power_revs=5600; %[rpm]
max_torque_revs=3600; %[rpm]

myFactory=EngineFactory();
myEngine=myFactory.buildEngine(cylinders_number,...
    piston_mass/1000, conrod_mass/1000,...
    conrod_length/1000, conrod_cog_factor, crank_mass/1000,...
    crank_length/1000, crank_angles*pi/180, piston_mass_variation_factor/100);

%% System characteristics (shut down engine)

myDyno=Dyno(0*(2*pi/60), 0*(2*pi/60),...
    0, myEngine);
modes=myDyno.findModes(myDyno.engine.mounts.k, myDyno.engine.block.inertia_tensor); %[1]
omega_n=myDyno.findOmega_n(myDyno.engine.mounts.k, myDyno.engine.block.inertia_tensor); %[rad/s]
zeta = myDyno.proportionalDamping(myDyno.engine.mounts.damping, ...
    myDyno.engine.mounts.stiffness, omega_n); %[1]
omega_d = myDyno.omegaDamped(omega_n, zeta); %[rad/s]

% We now convert natural frequencies to rpms and Hz for easier
% interpretation
omega_n_rpm=omega_n*30/pi; %[rpm]
omega_d_rpm=omega_d*30/pi; %[rpm]
omega_n_hz=omega_n/(2*pi); %[Hz]
omega_d_hz=omega_d/(2*pi); %[Hz]

% omega_n_rpm plot
figure("Name", 'Natural frequencies [rpm]', 'NumberTitle', 'off');
bar(categorical({'\omega_1' '\omega_2' '\omega_3' '\omega_4' '\omega_5' '\omega_6'}) ...
    ,omega_n_rpm, 'FaceColor', 'none', 'LineWidth',1.5, 'EdgeColor', 'w')
yline(idle_revs,'--','idle', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(limiter_revs,'--r','limiter', 'LineWidth',2, 'LabelVerticalAlignment','bottom', 'FontName', 'Bahnschrift');
yline(max_power_revs,'--','max power', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(max_torque_revs,'--','max torque', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
title('Natural frequencies [rpm]', 'Color', 'w')
xlabel('Natural frequencies')
ylabel('[rpm]')
ax=gca;
ax.FontName= 'Bahnschrift'
text(1:length(omega_n_rpm),omega_n_rpm,num2str(round(omega_n_rpm)),'vert','bottom','horiz','center', 'Color', 'w', 'FontName', 'Bahnschrift');
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w');  
save_path = '../graphics/omega_n_rpm';
export_fig('-m3', save_path, '-png', '-transparent');

% omega_n_hz plot
figure("Name", 'Natural frequencies [Hz]', 'NumberTitle', 'off');
bar(categorical({'\omega_1' '\omega_2' '\omega_3' '\omega_4' '\omega_5' '\omega_6'}) ...
    ,omega_n_hz, 'FaceColor', 'none', 'LineWidth',1.5, 'EdgeColor', 'w')
yline(idle_revs/60,'--','idle', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(limiter_revs/60,'--r','limiter', 'LineWidth',2, 'LabelVerticalAlignment','bottom', 'FontName', 'Bahnschrift');
yline(max_power_revs/60,'--','max power', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(max_torque_revs/60,'--','max torque', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
title('Natural frequencies [Hz]', 'Color', 'w')
xlabel('Natural frequencies')
ylabel('[Hz]')
ax=gca;
ax.FontName= 'Bahnschrift'
text(1:length(omega_n_hz),omega_n_hz,num2str(round(omega_n_hz)),'vert','bottom','horiz','center', 'Color', 'w', 'FontName', 'Bahnschrift');
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w');  
save_path = '../graphics/omega_n_hz';
export_fig('-m3', save_path, '-png', '-transparent');

% omega_d_rpm plot
figure("Name", 'Damped natural frequencies [rpm]', 'NumberTitle', 'off');
bar(categorical({'\omega_1' '\omega_2' '\omega_3' '\omega_4' '\omega_5' '\omega_6'}) ...
    ,omega_d_rpm, 'FaceColor', 'none', 'LineWidth',1.5, 'EdgeColor', 'w')
yline(idle_revs,'--','idle', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(limiter_revs,'--r','limiter', 'LineWidth',2, 'LabelVerticalAlignment','bottom', 'FontName', 'Bahnschrift');
yline(max_power_revs,'--','max power', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(max_torque_revs,'--','max torque', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
title('Damped natural frequencies [rpm]', 'Color', 'w')
xlabel('Damped natural frequencies')
ylabel('[rpm]')
ax=gca;
ax.FontName= 'Bahnschrift'
text(1:length(omega_d_rpm),omega_d_rpm,num2str(round(omega_d_rpm)),'vert','bottom','horiz','center', 'Color', 'w', 'FontName', 'Bahnschrift');
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w');  
save_path = '../graphics/omega_d_rpm';
export_fig('-m3', save_path, '-png', '-transparent');

% omega_d_hz plot
figure("Name", 'Damped natural frequencies [Hz]', 'NumberTitle', 'off');
bar(categorical({'\omega_1' '\omega_2' '\omega_3' '\omega_4' '\omega_5' '\omega_6'}) ...
    ,omega_d_hz, 'FaceColor', 'none', 'LineWidth',1.5, 'EdgeColor', 'w')
yline(idle_revs/60,'--','idle', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(limiter_revs/60,'--r','limiter', 'LineWidth',2, 'LabelVerticalAlignment','bottom', 'FontName', 'Bahnschrift');
yline(max_power_revs/60,'--','max power', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
yline(max_torque_revs/60,'--','max torque', 'LineWidth',2, 'Color','#FF7300', 'FontName', 'Bahnschrift');
title('Damped natural frequencies [Hz]', 'Color', 'w')
xlabel('Damped natural frequencies')
ylabel('[Hz]')
ax=gca;
ax.FontName= 'Bahnschrift'
text(1:length(omega_d_hz),omega_d_hz,num2str(round(omega_d_hz)),'vert','bottom','horiz','center', 'Color', 'w', 'FontName', 'Bahnschrift');
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w');  
save_path = '../graphics/omega_d_hz';
export_fig('-m3', save_path, '-png', '-transparent');

% zeta plot
figure("Name", 'Zeta', 'NumberTitle', 'off');
bar(categorical({'\zeta_1' '\zeta_2' '\zeta_3' '\zeta_4' '\zeta_5' '\zeta_6'}) ...
    ,zeta, 'FaceColor', 'none', 'LineWidth',1.5, 'EdgeColor', 'w')
title('Damping ratio (\zeta)', 'Color', 'w')
xlabel('Damping ratio (\zeta)')
ax=gca;
ax.FontName= 'Bahnschrift'
text(1:length(zeta),zeta,num2str(zeta),'vert','bottom','horiz','center', 'Color', 'w', 'FontName', 'Bahnschrift');
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w');  
save_path = '../graphics/zeta';
export_fig('-m3', save_path, '-png', '-transparent');

% modal shapes plot
figure('Name', 'Mode Shapes', 'NumberTitle','off');
newcolors = {'#FFFFFF','#FF7300','#FCA311',	'#14bf11','#ff0000', '#9fb3e0'};
colororder(newcolors)
plot([0:7], [zeros(1, 6); modes; zeros(1, 6)], 'DisplayName', 'Mode shapes', 'LineWidth', 1.5);
title('Mode shapes',  'Color', 'w')
xlabel('Components') 
ylabel('Coefficient')
xticklabels({''; '1st'; '2nd'; '3rd'; '4th'; '5th'; '6th'; ''})
legend({'1st mode', '2nd mode', '3rd mode', '4th mode', '5th mode', '6th mode'}, 'Box', 'off', 'TextColor', 'w')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'BahnSchrift');  
save_path = '../graphics/mode_shapes';
export_fig('-m3', save_path, '-png', '-transparent');


%% Steady rpms testing - idle
testing_time=1.5;
myDyno=Dyno(idle_revs*(2*pi/60), idle_revs*(2*pi/60),...
    testing_time, myEngine);
myForcing=myDyno.fullForcingMeasurement();
myResponse=myDyno.displacementAndAngles();
myTransmission=myDyno.transmittedForcesAndMoments(myResponse);
myIdentity=myTransmission+myDyno.inertiaForces(myResponse)-myForcing;

% Forces plot
figure('Name', 'Forces', 'NumberTitle','off');
hold on
title('Forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myForcing(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments plot
figure('Name', 'Moments', 'NumberTitle','off');
hold on
title('Moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myForcing(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacements plot
figure('Name', 'Displacements', 'NumberTitle','off');
hold on
title('Displacements [m]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [m]')
plot(myDyno.time, myResponse(1,:), 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(2,:), 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(3,:), 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_displacements';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles plot
figure('Name', 'Angles', 'NumberTitle','off');
hold on
title('Angles [rad]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [rad]')
plot(myDyno.time, myResponse(4,:), 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(5,:), 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(6,:), 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_angles';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces plot
figure('Name', 'Transmitted forces', 'NumberTitle','off');
hold on
title('Transmitted forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myTransmission(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_transmitted_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments plot
figure('Name', 'Transmitted moments', 'NumberTitle','off');
hold on
title('Transmitted moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myTransmission(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_transmitted_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Identity check plot
figure('Name', 'Identity check', 'NumberTitle','off');
hold on
title("D'Alembert equation \epsilon [N or Nm]" ,  'Color', 'w')
xlabel('Time [s]') 
ylabel('\epsilon [N or Nm]')
plot(myDyno.time, myIdentity(1,:), 'DisplayName', '\epsilon_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myIdentity(2,:), 'DisplayName', '\epsilon_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myIdentity(3,:), 'DisplayName', '\epsilon_z', 'LineWidth', 1.5, 'Color', '#FCA311');
plot(myDyno.time, myIdentity(4,:), 'DisplayName', '\epsilon_\theta_x', 'LineWidth', 1.5, 'Color', '#14bf11');
plot(myDyno.time, myIdentity(5,:), 'DisplayName', '\epsilon_\theta_y', 'LineWidth', 1.5, 'Color', '#ff0000');
plot(myDyno.time, myIdentity(6,:), 'DisplayName', '\epsilon_\theta_z', 'LineWidth', 1.5, 'Color', '#9fb3e0');
legend({'\epsilon_x' '\epsilon_y' '\epsilon_z' '\epsilon_\theta_x' '\epsilon_\theta_y' '\epsilon_\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/idle_identity';
export_fig('-m3', save_path, '-png', '-transparent');

% Forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Forces spectrum', 'NumberTitle','off');
hold on
title("Forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myForcing(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments spectrum plot
figure('Name', 'Moments spectrum', 'NumberTitle','off');
hold on
title("Moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myForcing(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacement spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Displacements spectrum', 'NumberTitle','off');
hold on
title("Displacements spectrum [m]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [m]')
forcingSpectrum = fft(myResponse(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z', '', '', '', '', '', ''}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
% for i=1:6
%     xline(omega_n_hz(i),'--',strcat('\omega_', num2str(i)), 'LineWidth',2, 'Color','#14bf11', 'FontName', 'Bahnschrift');
% end
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_displacements_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles spectrum plot
figure('Name', 'Angles spectrum', 'NumberTitle','off');
hold on
title("Angles spectrum [rad]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [rad]')
forcingSpectrum = fft(myResponse(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_angles_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Transmitted forces spectrum', 'NumberTitle','off');
hold on
title("Transmitted forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myTransmission(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_transmitted_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments spectrum plot
figure('Name', 'Transmitted moments spectrum', 'NumberTitle','off');
hold on
title("Transmitted moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myTransmission(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/idle_transmitted_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

%% Steady rpms testing - limiter
testing_time=1.5;
myDyno=Dyno(limiter_revs*(2*pi/60), limiter_revs*(2*pi/60),...
    testing_time, myEngine);
myForcing=myDyno.fullForcingMeasurement();
myResponse=myDyno.displacementAndAngles();
myTransmission=myDyno.transmittedForcesAndMoments(myResponse);
myIdentity=myTransmission+myDyno.inertiaForces(myResponse)-myForcing;

% Forces plot
figure('Name', 'Forces', 'NumberTitle','off');
hold on
title('Forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myForcing(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments plot
figure('Name', 'Moments', 'NumberTitle','off');
hold on
title('Moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myForcing(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacements plot
figure('Name', 'Displacements', 'NumberTitle','off');
hold on
title('Displacements [m]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [m]')
plot(myDyno.time, myResponse(1,:), 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(2,:), 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(3,:), 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_displacements';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles plot
figure('Name', 'Angles', 'NumberTitle','off');
hold on
title('Angles [rad]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [rad]')
plot(myDyno.time, myResponse(4,:), 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(5,:), 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(6,:), 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_angles';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces plot
figure('Name', 'Transmitted forces', 'NumberTitle','off');
hold on
title('Transmitted forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myTransmission(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_transmitted_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments plot
figure('Name', 'Transmitted moments', 'NumberTitle','off');
hold on
title('Transmitted moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myTransmission(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_transmitted_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Identity check plot
figure('Name', 'Identity check', 'NumberTitle','off');
hold on
title("D'Alembert equation \epsilon [N or Nm]" ,  'Color', 'w')
xlabel('Time [s]') 
ylabel('\epsilon [N or Nm]')
plot(myDyno.time, myIdentity(1,:), 'DisplayName', '\epsilon_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myIdentity(2,:), 'DisplayName', '\epsilon_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myIdentity(3,:), 'DisplayName', '\epsilon_z', 'LineWidth', 1.5, 'Color', '#FCA311');
plot(myDyno.time, myIdentity(4,:), 'DisplayName', '\epsilon_\theta_x', 'LineWidth', 1.5, 'Color', '#14bf11');
plot(myDyno.time, myIdentity(5,:), 'DisplayName', '\epsilon_\theta_y', 'LineWidth', 1.5, 'Color', '#ff0000');
plot(myDyno.time, myIdentity(6,:), 'DisplayName', '\epsilon_\theta_z', 'LineWidth', 1.5, 'Color', '#9fb3e0');
legend({'\epsilon_x' '\epsilon_y' '\epsilon_z' '\epsilon_\theta_x' '\epsilon_\theta_y' '\epsilon_\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/limiter_identity';
export_fig('-m3', save_path, '-png', '-transparent');

% Forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Forces spectrum', 'NumberTitle','off');
hold on
title("Forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myForcing(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments spectrum plot
figure('Name', 'Moments spectrum', 'NumberTitle','off');
hold on
title("Moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myForcing(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacement spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Displacements spectrum', 'NumberTitle','off');
hold on
title("Displacements spectrum [m]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [m]')
forcingSpectrum = fft(myResponse(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z', '', '', '', '', '', ''}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
% for i=1:6
%     xline(omega_n_hz(i),'--',strcat('\omega_', num2str(i)), 'LineWidth',2, 'Color','#14bf11', 'FontName', 'Bahnschrift');
% end
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_displacements_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles spectrum plot
figure('Name', 'Angles spectrum', 'NumberTitle','off');
hold on
title("Angles spectrum [rad]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [rad]')
forcingSpectrum = fft(myResponse(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_angles_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Transmitted forces spectrum', 'NumberTitle','off');
hold on
title("Transmitted forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myTransmission(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_transmitted_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments spectrum plot
figure('Name', 'Transmitted moments spectrum', 'NumberTitle','off');
hold on
title("Transmitted moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myTransmission(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/limiter_transmitted_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');


%% Steady rpms testing - maximum power point
testing_time=1.5;
myDyno=Dyno(max_power_revs*(2*pi/60), max_power_revs*(2*pi/60),...
    testing_time, myEngine);
myForcing=myDyno.fullForcingMeasurement();
myResponse=myDyno.displacementAndAngles();
myTransmission=myDyno.transmittedForcesAndMoments(myResponse);
myIdentity=myTransmission+myDyno.inertiaForces(myResponse)-myForcing;

% Forces plot
figure('Name', 'Forces', 'NumberTitle','off');
hold on
title('Forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myForcing(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments plot
figure('Name', 'Moments', 'NumberTitle','off');
hold on
title('Moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myForcing(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacements plot
figure('Name', 'Displacements', 'NumberTitle','off');
hold on
title('Displacements [m]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [m]')
plot(myDyno.time, myResponse(1,:), 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(2,:), 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(3,:), 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_displacements';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles plot
figure('Name', 'Angles', 'NumberTitle','off');
hold on
title('Angles [rad]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [rad]')
plot(myDyno.time, myResponse(4,:), 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(5,:), 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(6,:), 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_angles';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces plot
figure('Name', 'Transmitted forces', 'NumberTitle','off');
hold on
title('Transmitted forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myTransmission(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_transmitted_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments plot
figure('Name', 'Transmitted moments', 'NumberTitle','off');
hold on
title('Transmitted moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myTransmission(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_transmitted_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Identity check plot
figure('Name', 'Identity check', 'NumberTitle','off');
hold on
title("D'Alembert equation \epsilon [N or Nm]" ,  'Color', 'w')
xlabel('Time [s]') 
ylabel('\epsilon [N or Nm]')
plot(myDyno.time, myIdentity(1,:), 'DisplayName', '\epsilon_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myIdentity(2,:), 'DisplayName', '\epsilon_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myIdentity(3,:), 'DisplayName', '\epsilon_z', 'LineWidth', 1.5, 'Color', '#FCA311');
plot(myDyno.time, myIdentity(4,:), 'DisplayName', '\epsilon_\theta_x', 'LineWidth', 1.5, 'Color', '#14bf11');
plot(myDyno.time, myIdentity(5,:), 'DisplayName', '\epsilon_\theta_y', 'LineWidth', 1.5, 'Color', '#ff0000');
plot(myDyno.time, myIdentity(6,:), 'DisplayName', '\epsilon_\theta_z', 'LineWidth', 1.5, 'Color', '#9fb3e0');
legend({'\epsilon_x' '\epsilon_y' '\epsilon_z' '\epsilon_\theta_x' '\epsilon_\theta_y' '\epsilon_\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/max_power_identity';
export_fig('-m3', save_path, '-png', '-transparent');

% Forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Forces spectrum', 'NumberTitle','off');
hold on
title("Forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myForcing(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments spectrum plot
figure('Name', 'Moments spectrum', 'NumberTitle','off');
hold on
title("Moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myForcing(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacement spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Displacements spectrum', 'NumberTitle','off');
hold on
title("Displacements spectrum [m]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [m]')
forcingSpectrum = fft(myResponse(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z', '', '', '', '', '', ''}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
% for i=1:6
%     xline(omega_n_hz(i),'--',strcat('\omega_', num2str(i)), 'LineWidth',2, 'Color','#14bf11', 'FontName', 'Bahnschrift');
% end
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_displacements_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles spectrum plot
figure('Name', 'Angles spectrum', 'NumberTitle','off');
hold on
title("Angles spectrum [rad]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [rad]')
forcingSpectrum = fft(myResponse(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_angles_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Transmitted forces spectrum', 'NumberTitle','off');
hold on
title("Transmitted forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myTransmission(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_transmitted_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments spectrum plot
figure('Name', 'Transmitted moments spectrum', 'NumberTitle','off');
hold on
title("Transmitted moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myTransmission(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/max_power_transmitted_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

%% Speed ramp testing - from idle to limiter
testing_time=5;
myDyno=Dyno(idle_revs*(2*pi/60), limiter_revs*(2*pi/60),...
    testing_time, myEngine);
myForcing=myDyno.fullForcingMeasurement();
myResponse=myDyno.displacementAndAngles();
myTransmission=myDyno.transmittedForcesAndMoments(myResponse);
myIdentity=myTransmission+myDyno.inertiaForces(myResponse)-myForcing;

% Forces plot
figure('Name', 'Forces', 'NumberTitle','off');
hold on
title('Forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myForcing(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments plot
figure('Name', 'Moments', 'NumberTitle','off');
hold on
title('Moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myForcing(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacements plot
figure('Name', 'Displacements', 'NumberTitle','off');
hold on
title('Displacements [m]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [m]')
plot(myDyno.time, myResponse(1,:), 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(2,:), 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(3,:), 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_displacements';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles plot
figure('Name', 'Angles', 'NumberTitle','off');
hold on
title('Angles [rad]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [rad]')
plot(myDyno.time, myResponse(4,:), 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myResponse(5,:), 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myResponse(6,:), 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_angles';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces plot
figure('Name', 'Transmitted forces', 'NumberTitle','off');
hold on
title('Transmitted forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myTransmission(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_transmitted_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments plot
figure('Name', 'Transmitted moments', 'NumberTitle','off');
hold on
title('Transmitted moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myTransmission(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myTransmission(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myTransmission(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_transmitted_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Identity check plot
figure('Name', 'Identity check', 'NumberTitle','off');
hold on
title("D'Alembert equation \epsilon [N or Nm]" ,  'Color', 'w')
xlabel('Time [s]') 
ylabel('\epsilon [N or Nm]')
plot(myDyno.time, myIdentity(1,:), 'DisplayName', '\epsilon_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myIdentity(2,:), 'DisplayName', '\epsilon_y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myIdentity(3,:), 'DisplayName', '\epsilon_z', 'LineWidth', 1.5, 'Color', '#FCA311');
plot(myDyno.time, myIdentity(4,:), 'DisplayName', '\epsilon_\theta_x', 'LineWidth', 1.5, 'Color', '#14bf11');
plot(myDyno.time, myIdentity(5,:), 'DisplayName', '\epsilon_\theta_y', 'LineWidth', 1.5, 'Color', '#ff0000');
plot(myDyno.time, myIdentity(6,:), 'DisplayName', '\epsilon_\theta_z', 'LineWidth', 1.5, 'Color', '#9fb3e0');
legend({'\epsilon_x' '\epsilon_y' '\epsilon_z' '\epsilon_\theta_x' '\epsilon_\theta_y' '\epsilon_\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/speed_ramp_identity';
export_fig('-m3', save_path, '-png', '-transparent');

% Forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Forces spectrum', 'NumberTitle','off');
hold on
title("Forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myForcing(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments spectrum plot
figure('Name', 'Moments spectrum', 'NumberTitle','off');
hold on
title("Moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myForcing(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Displacement spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Displacements spectrum', 'NumberTitle','off');
hold on
title("Displacements spectrum [m]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [m]')
forcingSpectrum = fft(myResponse(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Displacement, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Displacement, x' 'Displacement, y' 'Displacement, z', '', '', '', '', '', ''}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
% for i=1:6
%     xline(omega_n_hz(i),'--',strcat('\omega_', num2str(i)), 'LineWidth',2, 'Color','#14bf11', 'FontName', 'Bahnschrift');
% end
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_displacements_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Angles spectrum plot
figure('Name', 'Angles spectrum', 'NumberTitle','off');
hold on
title("Angles spectrum [rad]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [rad]')
forcingSpectrum = fft(myResponse(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myResponse(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myResponse(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', '\theta_z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'\theta_x' '\theta_y' '\theta_z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_angles_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Transmitted forces spectrum', 'NumberTitle','off');
hold on
title("Transmitted forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myTransmission(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_transmitted_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Transmitted moments spectrum plot
figure('Name', 'Transmitted moments spectrum', 'NumberTitle','off');
hold on
title("Transmitted moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myTransmission(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myTransmission(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myTransmission(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/speed_ramp_transmitted_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');
%% Piston tolerances testing - max power point
piston_mass_variation_factor=3.5;
myEngine=myFactory.buildEngine(cylinders_number,...
    piston_mass/1000, conrod_mass/1000,...
    conrod_length/1000, conrod_cog_factor, crank_mass/1000,...
    crank_length/1000, crank_angles*pi/180, piston_mass_variation_factor/100);

testing_time=0.5;

myDyno=Dyno(max_power_revs*(2*pi/60), max_power_revs*(2*pi/60),...
    testing_time, myEngine);
myForcing=myDyno.fullForcingMeasurement();

% Forces plot
figure('Name', 'Forces', 'NumberTitle','off');
hold on
title('Forces [N]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [N]')
plot(myDyno.time, myForcing(1,:), 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(2,:), 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(3,:), 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/real_pistons_max_power_forces';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments plot
figure('Name', 'Moments', 'NumberTitle','off');
hold on
title('Moments [Nm]',  'Color', 'w')
xlabel('Time [s]') 
ylabel('Intensity [Nm]')
plot(myDyno.time, myForcing(4,:), 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
plot(myDyno.time, myForcing(5,:), 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
plot(myDyno.time, myForcing(6,:), 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', 'FontName', 'Bahnschrift');  
save_path = '../graphics/real_pistons_max_power_moments';
export_fig('-m3', save_path, '-png', '-transparent');

% Forces spectrum plot
N = length(myDyno.time);
samplingFreq = 1/myDyno.time_step;
dF = samplingFreq/N;
freq = 0:dF:samplingFreq/2;

figure('Name', 'Forces spectrum', 'NumberTitle','off');
hold on
title("Forces spectrum [N]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [N]')
forcingSpectrum = fft(myForcing(1,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(2,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(3,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Force, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Force, x' 'Force, y' 'Force, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/real_pistons_max_power_forces_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');

% Moments spectrum plot
figure('Name', 'Moments spectrum', 'NumberTitle','off');
hold on
title("Moments spectrum [Nm]" ,  'Color', 'w')
xlabel('Frequency [Hz]') 
ylabel('Intensity [Nm]')
forcingSpectrum = fft(myForcing(4,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, x', 'LineWidth', 1.5, 'Color', '#FFFFFF');
forcingSpectrum = fft(myForcing(5,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, y', 'LineWidth', 1.5, 'Color', '#FF7300');
forcingSpectrum = fft(myForcing(6,:));
loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N, 'DisplayName', 'Moment, z', 'LineWidth', 1.5, 'Color', '#FCA311');
legend({'Moment, x' 'Moment, y' 'Moment, z'}, 'Box', 'off', 'TextColor', 'w', 'Location', 'southoutside', 'Orientation', 'horizontal')
box off
set(gca, 'color', 'none', 'XColor','w', 'YColor','w', ...
    'FontName', 'Bahnschrift', 'XScale', 'log', 'YScale', 'log');  
save_path = '../graphics/real_pistons_max_power_moments_spectrum';
export_fig('-m3', save_path, '-png', '-transparent');