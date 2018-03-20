% Restart random number generator to ensure simulation repeatability
randn('seed', 293);

% Generate BPM signals
gensignals;

% Switching on
sw_direct = repmat([zeros(nsw/2, 1); ones(nsw/2, 1)], nswperiods, 4);
sw_crossed = 1-sw_direct;

% Drift on swapped channels
% Swap channels
ampl_if_drift_sw = swap(ampl_if, sw_direct, sw_crossed).*chdrift;
% Apply non-linearity
ampl_if_drift_sw_nl = polyval(rffe_poly, ampl_if_drift_sw);
% Deswap channels
ampl_if_drift_sw_desw = swap(ampl_if_drift_sw, sw_direct, sw_crossed);
ampl_if_drift_sw_desw_nl = swap(ampl_if_drift_sw_nl, sw_direct, sw_crossed);

% Digital Downconversion (from IF to DC)
cic_decim = ones(1,nsw)/nsw;
cic_latency = nsw/2-1;
ncoeffs = length(cic_decim);
ampl = downconv(ampl_if_drift_sw_desw, nif/nadc, cic_decim);
ampl_nl = downconv(ampl_if_drift_sw_desw_nl, nif/nadc, cic_decim);

% Align ideal and processed beam position data to account for processing latency
xy_ideal_decim = xy_ideal(ncoeffs+1:nsw:end-cic_latency,:);
ampl_decim = ampl(ncoeffs+1+cic_latency:nsw:end,:);
ampl_nl_decim = ampl_nl(ncoeffs+1+cic_latency:nsw:end,:);

% Calculate position
xy_proc_decim = calcpos(ampl_decim, Kx, Ky);
xy_proc_nl_decim = calcpos(ampl_nl_decim, Kx, Ky);

% Plot
figure;
plot(detrend([xy_proc_decim-xy_ideal_decim xy_proc_nl_decim-xy_ideal_decim], 0)*1e9);
xlabel('FOFB samples');
ylabel('Position [nm]');
title('Switch ON - non-linear channel');
grid on;
legend('X','Y','X (non-linear)','Y (non-linear)');