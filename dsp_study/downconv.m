function [ampl, iq] = downconv(x, f, fir_coeff)

t = (0:size(x,1)-1)';
nco = exp(-1j*(2*pi*f*t + pi/4));

iq = x.*repmat(nco, 1, size(x,2));
iq = filter(fir_coeff, 1, iq);

ampl = abs(iq);