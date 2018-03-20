% Restart random number generator to ensure simulation repeatability
randn('seed', 293);

% Generate BPM signals
gensignals;

% Switching off - channels drift independently
ampl_if_chdrift = ampl_if.*chdrift;

% Digital Downconversion (from IF to DC)
cic_decim = ones(1,nsw)/nsw;
cic_latency = nsw/2-1;
ncoeffs = length(cic_decim);
ampl = downconv(ampl_if_chdrift, nif/nadc, cic_decim);

% Align ideal and processed beam position data to account for processing latency
xy_ideal_decim = xy_ideal(ncoeffs+1:nsw:end-cic_latency,:);
ampl_decim = ampl(ncoeffs+1+cic_latency:nsw:end,:);

% Calculate position
xy_proc_decim = calcpos(ampl_decim, Kx, Ky);

% Plot
figure;
plot(detrend(xy_proc_decim-xy_ideal_decim, 0)*1e9);
xlabel('FOFB samples');
ylabel('Position [nm]');
title('Switch OFF - linear channel');
grid on;
legend('X','Y');