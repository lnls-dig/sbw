function x = builddrift(A, npts, bw)

[b,a] = butter(2, bw);

x = cumsum(filter(b, a, randn(npts, length(A))));
x = (x-repmat(mean(x), npts, 1)).*repmat(A./(max(x)-min(x)), npts, 1);