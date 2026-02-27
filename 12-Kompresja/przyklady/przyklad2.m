% Lab 12 - Przyklad 2: Kompresja obrazu blokami 8x8 (zasada JPEG)
[X, Y]   = meshgrid(1:64, 1:64);
img_orig = double(sin(X/5) .* cos(Y/5));

img_comp   = zeros(size(img_orig));
block_size = 8;
quality    = 0.1;

rows = size(img_orig, 1);
cols = size(img_orig, 2);

for r = 1 : block_size : rows
    for c = 1 : block_size : cols
        block = img_orig(r:r+block_size-1, c:c+block_size-1);
        D     = dct2(block);
        thresh = quality * max(abs(D(:)));
        D(abs(D) < thresh) = 0;
        img_comp(r:r+block_size-1, c:c+block_size-1) = idct2(D);
    end
end

mse_img  = mean(mean((img_orig - img_comp).^2));
psnr_val = 10*log10(max(img_orig(:))^2 / mse_img);

figure;
subplot(1,3,1);
imagesc(img_orig);  colormap gray; title('Oryginal'); axis off; colorbar;

subplot(1,3,2);
imagesc(img_comp);  colormap gray;
title(sprintf('Skompresowany\nJakosc=%.0f%%', quality*100));
axis off; colorbar;

subplot(1,3,3);
imagesc(abs(img_orig - img_comp)); colormap hot;
title(sprintf('Roznica\nPSNR=%.1f dB', psnr_val));
axis off; colorbar;
