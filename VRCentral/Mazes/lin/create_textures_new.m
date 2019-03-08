% From Aman 
% Modified by Mai Feb 2019

texsize = 512;
wn_contrast = 0.5;
sf = 6; % no.of bars visible

% Gray
textures(1).matrix = 0.5*ones(64,64);

% Unfiltered Whitenoise
textures(2).matrix = rand(16, 512);

% Horizontal grating
textures(6).matrix = 0.5+0.5*repmat(sin(0:((2*sf*pi)/texsize):(2*sf)*pi-(((2*sf)*pi)/texsize)),texsize,1);

% Vertical grating
textures(7).matrix = 0.5+0.5*repmat(sin(0:(((2*sf)*pi)/texsize):(2*sf)*pi-(((2*sf)*pi)/texsize))',1,texsize);

% Plaid
textures(8).matrix = (textures(6).matrix+textures(7).matrix)/2;

% c = [0:0.1:1.0];

% % Horixontal grating at 0, 10 to 100% contrast
% for n = 6:16
%     textures(n).matrix = 0.5+c(n-5)*0.5*repmat(sin(0:(((2*sf)*pi)/texsize):(2*sf)*pi-(((2*sf)*pi)/texsize)),texsize,1);
% end

% % Anti-phase Vertical, horizontal gratings
% textures(17).matrix = 1-textures(4).matrix;
% textures(20).matrix = 1-textures(3).matrix;
% textures(21).matrix = 1-textures(17).matrix;


%% Filtered White noise
% Making a 2D Gaussian filter to convolve
filtSize = 40;
sigma = 15;
sigma1 = 10; %3

x = 1:filtSize;


for texID = 2:5
    
    %     if texID==4; sigma = 30; end;
%     if texID==3; sigma = 5; end;

    y = exp(-((x-round(filtSize/2)).^2)/(2*sigma^2));
    y1 = exp(-((x-round(filtSize/2)).^2)/(2*sigma1^2));
    y = y./sum(y);
    y1 = y1./sum(y1);
    
    
    filt2 = y'*y1;
    % imagesc(filt2); colormap(gray)
    
    Im = rand(texsize/8+filtSize*2,texsize*2+filtSize*2);
    
    % Convolving and normalizing the image to 100% contrast
    Imf = conv2(filt2,Im);
    Imf = Imf(filtSize+floor(filtSize/2):end-ceil(filtSize/2)-filtSize,filtSize+floor(filtSize/2):end-ceil(filtSize/2)-filtSize);
    Imf = Imf - min(min(Imf));
    Im_full = Imf./max(max(Imf));
    Im_new = ((Im_full-0.5)*wn_contrast) + 0.5;
    textures(texID).matrix = Im_new;
end

% pause(1);
% close;

% clear Im ImF filt2 texID x y

%% plot textures

% cd C:\Users\m.morimoto\Documents\GitHub\SaleemLab-VR\VRCentral\data
% load('textures_hf_Mik4.mat')

figure; 

subplot(4,1,1)
tex=textures(2).matrix;    
imagesc(tex, [0 1]);
title({['background ', num2str(size(tex,1)),'x', num2str(size(tex,2))],...
    ['contrast=', num2str(wn_contrast), ' filtsize=', num2str(filtSize),' sigma=', num2str(sigma), ' sigma1=', num2str(sigma1)]})
colormap gray; axis equal; box off; axis off

subplot(4,1,2); 
tex=textures(6).matrix;    
imagesc(tex, [0 1]);
title({['grating1 ', num2str(size(tex,1)),'x', num2str(size(tex,2))], ['sf=', num2str(sf)]})
colormap gray; axis equal; box off; axis off

subplot(4,1,3); 
tex=textures(7).matrix;    
imagesc(tex, [0 1]);
title({['grating2 ', num2str(size(tex,1)),'x', num2str(size(tex,2))], ['sf=', num2str(sf)]})
colormap gray; axis equal; box off; axis off

subplot(4,1,4); 
tex=textures(8).matrix;    
imagesc(tex, [0 1]);
title({['plaid ', num2str(size(tex,1)),'x', num2str(size(tex,2))], ['sf=', num2str(sf)]})
colormap gray; axis equal; box off; axis off

%% save

savefolder='C:\Users\m.morimoto\Documents\GitHub\SaleemLab-VR\VRCentral\data';
savefile='textures_MM4.mat';

save([savefolder,filesep,savefile], 'textures')




















