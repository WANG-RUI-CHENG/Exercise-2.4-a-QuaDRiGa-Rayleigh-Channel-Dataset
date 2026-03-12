clear;
close all;
clc;

%% 1. Define Simulation Parameters
fc = 3.5e9;
num_snapshots = 20000;

%% 2. Create QuaDRiGa Scenario
s = qd_simulation_parameters;
s.center_frequency = fc;

l = qd_layout(s);

% Tx
l.tx_array = qd_arrayant('omni');
l.tx_position = [0; 0; 25];

% Rx
l.rx_array = qd_arrayant('omni');
l.no_rx = 1;

% Create a linear track with explicit length
track_length = 10;   % meters
track = qd_track('linear', track_length);
track.initial_position = [100; 0; 1.5];
track.interpolate_positions(num_snapshots);

l.rx_track = track;

% Scenario
l.set_scenario('3GPP_38.901_UMi_NLOS');

fprintf('Scenario: 3GPP_38.901_UMi_NLOS\n');

%% 3. Generate Channel Coefficients
b = l.init_builder;
gen_parameters(b);
h = get_channels(b);

h_coeff = h.coeff;
h_flat = sum(h_coeff, 3);
h_siso = squeeze(h_flat);

fprintf('Channel vector size: [%s]\n', num2str(size(h_siso)));

%% 4. Save Dataset
save('rayleigh_channel_dataset.mat', 'h_siso');
fprintf('Dataset saved to rayleigh_channel_dataset.mat\n');

%% 5. Plot for checking
figure;
plot(abs(h_siso));
title('Magnitude of Generated Rayleigh Channel');
xlabel('Snapshot Index');
ylabel('|h|');
grid on;

figure;
histogram(abs(h_siso), 50);
title('Histogram of |h|');
xlabel('|h|');
ylabel('Count');
grid on;

fprintf('mean(real(h)) = %e\n', mean(real(h_siso)));
fprintf('mean(imag(h)) = %e\n', mean(imag(h_siso)));
fprintf('std(real(h))  = %e\n', std(real(h_siso)));
fprintf('std(imag(h))  = %e\n', std(imag(h_siso)));

figure;
plot(real(h_siso(1:5000)), imag(h_siso(1:5000)), '.');
xlabel('Re\{h\}');
ylabel('Im\{h\}');
title('Scatter Plot of Channel Coefficients');
grid on;
axis equal;

h_norm = h_siso / rms(h_siso);

figure;
histogram(abs(h_norm),50);
xlabel('|h_{norm}|');
ylabel('Count');
title('Histogram of Normalized Channel Magnitude');
grid on;
