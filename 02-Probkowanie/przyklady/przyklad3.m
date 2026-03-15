% Lab 2 - Przyklad 3: Aliasowanie w sygnale wieloskladowym
f1 = 4;
f2 = 11;
T  = 1;

fs_ref = 1000;
t_ref  = 0 : 1/fs_ref : T-1/fs_ref;
x_ref  = sin(2*pi*f1*t_ref) + 0.7*sin(2*pi*f2*t_ref);

fs_list = [40, 24, 14];

figure;
subplot(4,1,1);
plot(t_ref, x_ref, 'k');
title('Sygnal referencyjny'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

for i = 1:length(fs_list)
    fs = fs_list(i);
    t  = 0 : 1/fs : T-1/fs;
    x  = sin(2*pi*f1*t) + 0.7*sin(2*pi*f2*t);

    subplot(4,1,i+1);
    stem(t, x, 'filled');
    title(sprintf('Probkowanie sygnalu zlozonego, fs = %d Hz', fs));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
end
