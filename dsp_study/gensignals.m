% Load parameters
params;

% Time vector
npts = nswperiods*nsw;
t_samples = (0:npts-1)';

% Signal amplitude variation (common to all channels - simulates beam current variation)
A = V*(1+bcd_factor*0.5*sin(2*pi*1/npts*t_samples));

% BPM modulation signals
xy_offset = repmat(beampos_offset, npts, 1);
xy_ideal = builddrift(beampos_drift, npts, 2*1/10/382) + xy_offset;

% Ideal amplitude signals
pctx = 1 + xy_ideal(:,1)/Kx;
pcty = 1 + xy_ideal(:,2)/Ky;

to = A.*pctx.*pcty;
ti = A.*pcty./pctx;
bi = A./(pctx.*pcty);
bo = A.*pctx./pcty;

ampl = [to ti bi bo];

% BPM carrier signals
ampl_if = ampl.*repmat(sin(2*pi*nif/nadc*t_samples), 1, 4);

% Channels drift
chdrift = (1+builddrift(repmat(chdrift_level, 1, 4), npts, 0.001));