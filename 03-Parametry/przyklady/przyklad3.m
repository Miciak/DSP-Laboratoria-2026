% Lab 3 - Przyklad 3: Parametry sygnalow o roznych ksztaltach
fs = 1000;
T  = 1;
f  = 5;
A  = 2;
t  = 0 : 1/fs : T-1/fs;

x_sin = A * sin(2*pi*f*t);
x_sq  = A * square(2*pi*f*t);
x_tri = A * sawtooth(2*pi*f*t, 0.5);

signals = {x_sin, x_sq, x_tri};
names   = {'Sinus', 'Prostokat', 'Trojkat'};

figure;
for i = 1:3
    x = signals{i};
    rms_val   = sqrt(mean(x.^2));
    crest_val = max(abs(x)) / rms_val;

    subplot(3,1,i);
    plot(t, x);
    title(sprintf('%s: RMS = %.3f, CF = %.3f', names{i}, rms_val, crest_val));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
end
