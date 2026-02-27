% Lab 10 - Przyklad 2: Filtracja 2D obrazu
pkg load image;

[X, Y] = meshgrid(1:100, 1:100);
img = double(((X-50).^2 + (Y-50).^2) < 900);

% Szum Gaussa + filtr Gaussowski
img_gauss = img + 0.2 * randn(size(img));
h_gauss   = fspecial('gaussian', [5 5], 1);
img_fg    = imfilter(img_gauss, h_gauss);

% Szum impulsowy + filtr medianowy
img_salt = img;
idx_s = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_s) = 1;
idx_p = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_p) = 0;
img_fm = medfilt2(img_salt, [3 3]);

figure;
subplot(2,3,1); imagesc(img);      title('Oryginal');         colormap gray; axis off;
subplot(2,3,2); imagesc(img_gauss); title('Szum Gaussa');     colormap gray; axis off;
subplot(2,3,3); imagesc(img_fg);   title('Filtr Gaussa');     colormap gray; axis off;
subplot(2,3,4); imagesc(img);      title('Oryginal');         colormap gray; axis off;
subplot(2,3,5); imagesc(img_salt); title('Szum impulsowy');   colormap gray; axis off;
subplot(2,3,6); imagesc(img_fm);   title('Filtr medianowy 2D'); colormap gray; axis off;
