%% Rafael Cordero - June 2020

% Script to load ECG and SCG data and define it correctly for processing in Simulink.

clear
close all
clc
bdclose('all')
    
% Figure Display settings.
get(0,'Factory');
set(0,'defaultfigurecolor',[1 1 1]);
set(0,'DefaultFigureWindowStyle','docked');

% Loading user-specified data.
startingFolder = 'C:\Users\Rafael\Dropbox\Post-Doc Research\Data';
defaultFileName = fullfile(startingFolder);
[file_name, folder] = uigetfile(defaultFileName, 'Select a file');

if file_name == 0% If the user clicked the 'Cancel' button.
    return;
end

fullfileName = fullfile(folder, file_name);
load(fullfileName);

save_name = fullfileName(strfind(fullfileName,save_name):end-4);

% Specifying figure-saving folder
% figureFolder = 'C:\Users\Rafael\Dropbox\Post-Doc Research\Saved Figures\Complete Analysis';
% mkdir(figureFolder, save_name) % Creating the folder to store the figures.

clear ans defaultFileName file_name folder startingFolder fullfileName

%%  ----------------------------------------- 0.0 Channel  Identification  ----------------------------------------- %%

% Identifying which channels correspond to the ECGs and which to the Cardiac Vibrations.
for i=1:length(channels)
    
    
    % Identifying ECG channels.
    if contains(channels(i),'ECGI','IgnoreCase',true) || contains(channels(i),'ECG I','IgnoreCase',true) || contains(channels(i),'ECG1','IgnoreCase',true) || contains(channels(i),'ECG 1','IgnoreCase',true)
        ecgs.signals.ecgI=data(:,i);
    end
    
    if contains(channels(i),'ECGII','IgnoreCase',true) || contains(channels(i),'ECG II','IgnoreCase',true) || contains(channels(i),'ECG2','IgnoreCase',true) || contains(channels(i),'ECG 2','IgnoreCase',true)
        ecgs.signals.ecgII=data(:,i);
    end
    
    if contains(channels(i),'ECGIII','IgnoreCase',true) || contains(channels(i),'ECG III ','IgnoreCase',true) || contains(channels(i),'ECG3','IgnoreCase',true) || contains(channels(i),'ECG 3','IgnoreCase',true)
        ecgs.signals.ecgIII=data(:,i);
    end
    
    if contains(channels(i),'Short','IgnoreCase',true)
        ecgs.signals.short=data(:,i);
    end
    
    
    % Identifying 1D Cardiac Vibration channels.
    
    if contains(channels(i),'RASonR','IgnoreCase',true) || contains(channels(i),'RA SonR','IgnoreCase',true)
        cardiac_vibrations.signals.ra_ea = data(:,i);
    end
    
    if contains(channels(i),'RVSonR','IgnoreCase',true) || contains(channels(i),'RV SonR','IgnoreCase',true)
        cardiac_vibrations.signals.rv_ea = data(:,i);
    end
    
    if contains(channels(i),'ExternalSonR','IgnoreCase',true) || contains(channels(i),'External SonR','IgnoreCase',true) || contains(channels(i),'ExtSonR','IgnoreCase',true) || contains(channels(i),'Ext SonR','IgnoreCase',true)
        cardiac_vibrations.signals.scg_1D = 1/50*data(:,i); % The additional 1/50 arises from the fact that the external SonR features a 50x gain amplifier.
    end
    
    if contains(channels(i),'ParaSonR','IgnoreCase',true) || contains(channels(i),'Para SonR','IgnoreCase',true) || contains(channels(i),'ParasternalSonR','IgnoreCase',true) || contains(channels(i),'Parasternal SonR','IgnoreCase',true)
        cardiac_vibrations.signals.subq_scg_para_1D = data(:,i);
    end
    
    if contains(channels(i),'SternalSonR','IgnoreCase',true) || contains(channels(i),'Sternal SonR','IgnoreCase',true)
        cardiac_vibrations.signals.subq_scg_sternal_1D = data(:,i);
    end
    
    
    % Identifying 3D Cardiac Vibration channels.
    
    if contains(channels(i),'3DLeadX') || contains(channels(i),'3D Lead X') || contains(channels(i),'3DX') || contains(channels(i),'3D X')
        cardiac_vibrations.signals.lead_3D_x = data(:,i);
    end
    
    if contains(channels(i),'3DLeadY') || contains(channels(i),'3D Lead Y') || contains(channels(i),'3DY') || contains(channels(i),'3D Y')
        cardiac_vibrations.signals.lead_3D_y = data(:,i);
    end
    
    if contains(channels(i),'3DLeadZ') || contains(channels(i),'3D Lead Z') || contains(channels(i),'3DZ') || contains(channels(i),'3D Z')
        cardiac_vibrations.signals.lead_3D_z = data(:,i);
    end
    
    
    if contains(channels(i),'3DCanX') || contains(channels(i),'3D Can X')
        cardiac_vibrations.signals.can_3D_x = data(:,i);
    end
    
    if contains(channels(i),'3DCanY') || contains(channels(i),'3D Can Y')
        cardiac_vibrations.signals.can_3D_y = data(:,i);
    end
    
    if contains(channels(i),'3DCanZ') || contains(channels(i),'3D Can Z')
        cardiac_vibrations.signals.can_3D_z = data(:,i);
    end
    
    
    % Identifying the pressure channels.
    
    if contains(channels(i),'RVPressure') || contains(channels(i),'RV Pressure')
        pressure.signals.rv_press = data(:,i);
        pressure.dPdt.rv_dpdt = diff(pressure.signals.LV)/(1/fs);
    end
    
    if contains(channels(i),'LVPressure') || contains(channels(i),'LV Pressure')
        pressure.signals.lv_press = data(:,i);
        pressure.dPdt.lv_dpdt = diff(pressure.signals.LV)/(1/fs);
    end
    
end

clear i ans data channels

%%  ----------------------------------------- 1.0 Setting up Simulink Parameters  ----------------------------------------- %%

% Simulation parameters.
param_tot_samples = length(ecgs.signals.ecgI); % Total number of samples in the recording.
param_sim_time = param_tot_samples/fs; % Total simulation time of the recording (in seconds).
t = force_col(0:1/fs:(param_tot_samples-1)/fs); % Vector marking the time stamp of each sample.

% Signals (in column form - for input into Simulink).
signals.ecg.input = force_col(ecgs.signals.short);
signals.scg.input_x = force_col(cardiac_vibrations.signals.lead_3D_x);
signals.scg.input_y = force_col(cardiac_vibrations.signals.lead_3D_y);
signals.scg.input_z = force_col(cardiac_vibrations.signals.lead_3D_z);

clear ecgs cardiac_vibrations

%%  ----------------------------------------- 2.0 Simulink Simulation (ECG and SCG processing) ----------------------------------------- %%

open_system('WorkingModel'); sim('WorkingModel');

% Saving Simulink preprocessing outputs.signals.ecg.preprocessed = out_ecg_preprocessing.signals.values(:,1);
signals.scg.preprocessed_x = out_scg_xyz_preprocessing.signals.values(:,1);
signals.scg.preprocessed_y = out_scg_xyz_preprocessing.signals.values(:,2);
signals.scg.preprocessed_z = out_scg_xyz_preprocessing.signals.values(:,3);

