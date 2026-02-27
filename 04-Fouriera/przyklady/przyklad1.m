% Lab 4 - Przyklad 1: Szereg Fouriera - aproksymacja sygnalu prostokatnego
T0 = 1;                  % okres [s]
omega0 = 2*pi / T0;
t = 0 : 0.001 : 2*T0;

N_list = [1, 3, 7, 21];
colors = {'b', 'r', 'g', 'm'};

figure;
for idx = 1:length(N_list)
    N = N_list(idx);
    x_approx = zeros(size(t));
    for k = 1 : N
        n = 2*k - 1;
        x_approx = x_approx + (4/pi) * sin(n*omega0*t) / n;
    end
    subplot(2,2,idx);
    plot(t, x_approx, colors{idx});
    title(sprintf('N = %d harmonicznych', N));
    xlabel('t [s]'); ylabel('Amplituda'); grid on; ylim([-1.5 1.5]);
end
sgtitle('Aproksymacja sygnalu prostokatnego szeregiem Fouriera');
