clear; 
close all; 
clc;

%% 1. Define Simulation Parameters
fc = 3.5e9;                 
num_tx = 1;                 
num_rx = 1;                 
ue_speed_kmh = 3;           
num_snapshots = 20000;      

%% 2. Create Quadriga Scenario
s = qd_simulation_parameters;
s.center_frequency = fc;

l = qd_layout(s);

% Transmitter
l.tx_array = qd_arrayant('omni');
l.tx_position = [0;0;25];

% Receiver
l.rx_array = qd_arrayant('omni');
l.no_rx = num_rx;

% UE movement
ue_speed_mps = ue_speed_kmh * 1000 / 3600;

track = qd_track('linear');
track.no_snapshots = num_snapshots;
track.set_speed(ue_speed_mps);
track.initial_position = [100;0;1.5];

l.rx_track = track;

% Scenario
l.set_scenario('3GPP_38.901_UMi_NLOS');

fprintf('Scenario: 3GPP_38.901_UMi_NLOS\n');

%% 3. Generate Channel Coefficients
b = l.init_builder;
gen_parameters(b);

h = get_channels(b);

h_coeff = h.coeff;

% Combine clusters
h_flat = sum(h_coeff,3);

% Convert to SISO vector
h_siso = squeeze(h_flat);

fprintf('Channel vector size: [%s]\n',num2str(size(h_siso)));

%% 4. Save Dataset
dataset_filename = 'rayleigh_channel_dataset.mat';
save(dataset_filename,'h_siso');

fprintf('Dataset saved to %s\n',dataset_filename);