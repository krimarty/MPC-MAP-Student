function pdf = norm_pdf(x, mu, sigma)
%NORM_PDF Assemble the probability density function (pdf) of the normal distribution

k = 1/(sigma*sqrt(2*pi));

pdf = zeros(size(x));

for i = 1:length(x)
    pdf(i) = k * exp(-((x(i)-mu)^2 / (2*sigma^2)));
end

end

