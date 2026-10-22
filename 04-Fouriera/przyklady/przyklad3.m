% Lab 4 - Przyklad 3: Aproksymacja sygnalu trojkatnego
fs = 2000;
T  = 1;
f0 = 2;
t  = 0 : 1/fs : T-1/fs;

x_ref = sawtooth(2*pi*f0*t, 0.5);
N_values = [1, 3, 9];

figure;
for idx = 1:length(N_values)
    N = N_values(idx);
    x = zeros(size(t));

    for k = 1:2:(2*N-1)
        coeff = (8/pi^2) * ((-1)^((k-1)/2)) / (k^2);
        x = x + coeff * sin(2*pi*k*f0*t);
    end

    subplot(length(N_values),1,idx);
    plot(t, x_ref, 'k', 'LineWidth', 1); hold on;
    plot(t, x, 'r--', 'LineWidth', 1);
    title(sprintf('Aproksymacja trojkata, N = %d harmonicznych nieparzystych', N));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
    legend('Oryginal', 'Aproksymacja');
end
