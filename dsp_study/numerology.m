% Beam harmonic number
h = 864;

% ADC sampling index (revolution harmonics) under analysis
nadc = 376:2:388;

% RF frequency harmonic indexes under analysis
nrf = 2:20;

dist = zeros(length(nrf), length(nadc));
leg={};
for i=1:length(nadc)
    nif = calcalias(h, nadc(i));
    nrf_aliased = calcalias(h*nrf, nadc(i));
    dist(:,i) = abs(nrf_aliased - nif);
    
    leg_text = ['n_{IF}/n_{ADC} = ' num2str(nif) '/' num2str(nadc(i))];
    gcd_nif_nadc = gcd(nif, nadc(i));
    if gcd_nif_nadc ~= 1
        leg_text = [leg_text ' = ' num2str(nif/gcd_nif_nadc) '/' num2str(nadc(i)/gcd_nif_nadc)];
    end    
    leg{i} = leg_text;
end

figure;
plot(nrf, dist, 'o-');
legend(leg)
xlabel('RF harmonic index');
ylabel({'Distance to RF frequency', '[in units of revolution harmonics]'});