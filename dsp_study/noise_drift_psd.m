npts = 1e6;
npts2 = 1e4;
fs = 2e6;

t = (0:npts-1)'/fs;

drift = cumsum(1e-5.*randn(npts,1));
noise = 1e-2*randn(npts,1);

drift_noise = drift + noise;
drift_noise2 = drift_noise(1:npts2);

nfft = 2e5;
nfft2 = 2e3;

% Compute power spectrum density
% WARNING: Octave and Matlab pwelch have different interfaces
% noverlap argument: ratio in Octave, number of points in Matlab
[Ydrift,f] = pwelch(drift, rectwin(nfft), nfft/2, nfft, fs);
[Ynoise,f] = pwelch(noise, rectwin(nfft), nfft/2, nfft, fs);
[Ydrift_noise,f] = pwelch(drift_noise, rectwin(nfft), nfft/2, nfft, fs);
[Ydrift_noise2,f2] = pwelch(drift_noise2, rectwin(nfft2), nfft2/2, nfft2, fs);

% Plot
figure;
plot(t, [drift noise drift_noise])
legend('only drift', 'only white noise', 'drift + white noise')
xlabel('Time [s]');
ylabel('Amplitude [V]');
title('Time-domain');
grid on;

figure;
loglog(f, [Ydrift Ynoise Ydrift_noise])
legend('only drift', 'only white noise', 'drift + white noise')
xlabel('Frequency [Hz]');
ylabel('PSD [V^2/Hz]');
title('Power Spectral Density');
grid on;

figure;
loglog(f, Ydrift_noise)
hold all
loglog(f2, Ydrift_noise2)
legend('drift + white noise', 'drift + white noise (less points)')
xlabel('Frequency [Hz]');
ylabel('PSD [V^2/Hz]');
title('Power Spectral Density');
grid on;