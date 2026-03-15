% Lab 6 - Przyklad 3: Reczna realizacja splotu liniowego
            x = [1, 2, 1, 0];
            h = [1, -1, 2];

            y_builtin = conv(x, h);
            y_manual  = zeros(1, length(x) + length(h) - 1);

            for n = 1:length(y_manual)
                for k = 1:length(x)
                    m = n - k + 1;
                    if m >= 1 && m <= length(h)
                        y_manual(n) = y_manual(n) + x(k) * h(m);
                    end
                end
            end

            figure;
            subplot(2,1,1);
            stem(y_builtin, 'filled');
            title('Splot z funkcji conv'); xlabel('n'); ylabel('Amp'); grid on;

            subplot(2,1,2);
            stem(y_manual, 'filled');
            title('Splot liczony recznie'); xlabel('n'); ylabel('Amp'); grid on;

            fprintf('Maksymalna roznica miedzy wynikami: %.6f
', max(abs(y_builtin - y_manual)));
