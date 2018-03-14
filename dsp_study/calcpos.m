function [xy, q, sum] = calcpos(ampl, Kx, Ky)

to = ampl(:,1);
ti = ampl(:,2);
bi = ampl(:,3);
bo = ampl(:,4);

sum = to+ti+bi+bo;
xy = [Kx*(to+bo-bi-ti)./sum Ky*(to+ti-bi-bo)./sum];
q = (to+bi-ti-bo)./sum;