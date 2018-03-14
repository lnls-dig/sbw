% Restart random number generator to ensure simulation repeatability
randn('seed', 293);

% Generate BPM signals
gensignals;

% Switching off
ampl_cw_drift = ampl_cw.*chdrift;
ampl_cw_drift_nl = polyval(rffe_poly, ampl_cw_drift);

% Switching on
sw_direct = repmat([zeros(nsw/2, 1); ones(nsw/2, 1)], nswperiods, 4);
sw_crossed = 1-sw_direct;

% Swap
ampl_cw_drift_sw    = swap(ampl_cw, sw_direct, sw_crossed).*chdrift;
ampl_cw_drift_sw_nl = polyval(rffe_poly, ampl_cw_drift_sw);

% Deswap
ampl_cw_drift_sw_desw    = swap(ampl_cw_drift_sw,    sw_direct, sw_crossed);
ampl_cw_drift_sw_desw_nl = swap(ampl_cw_drift_sw_nl, sw_direct, sw_crossed);

% Downconversion
cic_decim = conv(ones(1, nsw),ones(1, nsw))/nsw/nsw;
cic_latency = nsw-1;
ncoeffs = length(cic_decim);

ampl_swoff = downconv(ampl_cw_drift,         nif/nadc, cic_decim);
ampl_swon  = downconv(ampl_cw_drift_sw_desw, nif/nadc, cic_decim);

ampl_swoff_nl = downconv(ampl_cw_drift_nl,         nif/nadc, cic_decim);
ampl_swon_nl  = downconv(ampl_cw_drift_sw_desw_nl, nif/nadc, cic_decim);

% Align ideal and processed beam position data to account for processing latency
xy            = xy(ncoeffs+1:end-cic_latency,:);
ampl_swoff    = ampl_swoff   (ncoeffs+1+cic_latency:end,:);
ampl_swon     = ampl_swon    (ncoeffs+1+cic_latency:end,:);
ampl_swoff_nl = ampl_swoff_nl(ncoeffs+1+cic_latency:end,:);
ampl_swon_nl  = ampl_swon_nl (ncoeffs+1+cic_latency:end,:);

% Calculate position
xy_swoff    = calcpos(ampl_swoff,    Kx, Ky);
xy_swon     = calcpos(ampl_swon,     Kx, Ky);
xy_swoff_nl = calcpos(ampl_swoff_nl, Kx, Ky);
xy_swon_nl  = calcpos(ampl_swon_nl,  Kx, Ky);

% Plot
figure;
plot(detrend([xy_swoff-xy xy_swon-xy]*1e9, 0))

figure;
plot(detrend([xy_swoff_nl-xy_swoff xy_swon_nl-xy_swon]*1e9, 0))