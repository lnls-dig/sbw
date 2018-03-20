% Numerology
h = 864;
nadc = 382;
nif = 100;
nsw = nadc*5;

% Simulation duration [switching cycles]
nswperiods = 500;

% BPM geometric factors [m]
Kx = 12e-3/sqrt(2);
Ky = Kx;

beampos_drift = [200e-9 200e-9];    % Beam position peak-to-peak variation [m]

% Beam position offset [m]
%beampos_offset = [0.5e-3 -0.25e-3]; % Centered beam
beampos_offset = [0 0];             % Off-centered beam [m]

chdrift_level = 1e-3;               % Channel gain drift peak-to-peak [ratio]

% Signal amplitude variation [ratio]
bcd_factor = 0;
%bcd_factor = 0.3;                   % Long-range BCD
%bcd_factor = 0.02;                  % Short-range BCD

% Signal amplitude [V]
% V = 0.02236;                        % -20 dBm @ 50 ohm (0 dBm on RFFE output)
V = 0.03159;                        % -17 dBm @ 50 ohm (+3 dBm on RFFE output)
% V = 0.04462;                        % -14 dBm @ 50 ohm (+6 dBm on RFFE output)

% RFFE non-linearity polynomial
rffe_poly = [-1.152 0 1 0]*10;      % TAMP-72LN amplifier (only last stage taken into account for simplicity) - P1dB @ output = 20 dBm 
% rffe_poly = [0 0 1 0]*10;           % Ideally linear amplifier