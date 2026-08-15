function I = angular_propagation1D(U,lambda,z,dx)
[N,~] = size(U);
k = 2*pi/lambda;
fx = (-N/2:N/2-1)/(N*dx);
I = ifft2(fft2(U) .* exp(1i*k*z*sqrt(1 - (lambda^2*(fftshift(fx)).^2))));
end