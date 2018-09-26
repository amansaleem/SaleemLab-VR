InitializeMatlabOpenGL(1);
[ret, systemName] = system('hostname');
WhichScreen = 2;
ScreenInfo.whiteIndex = WhiteIndex(WhichScreen);
ScreenInfo.blackIndex = BlackIndex(WhichScreen);
ScreenInfo.grayIndex = round((ScreenInfo.whiteIndex+ScreenInfo.blackIndex)/2);

% Make sure that on floating point framebuffers we still get a well defined gray
if ScreenInfo.grayIndex == ScreenInfo.whiteIndex
ScreenInfo.grayIndex = ScreenInfo.whiteIndex / 2;
end
ScreenInfo.WhichScreen = WhichScreen;
ScreenInfo.FrameRate = FrameRate(WhichScreen);

PsychImaging('PrepareConfiguration');
transformFile = 'S:\Code\MeshMapping\MeshMapping_Neo.mat';
PsychImaging('AddTask', 'AllViews', 'GeometryCorrection', transformFile);
% PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');

[ScreenInfo.windowPtr, ScreenInfo.screenRect] = PsychImaging('OpenWindow', WhichScreen, ScreenInfo.grayIndex);
[slims] = get(0,'MonitorPositions');

sampling = 10; % no.of pixels

xm = slims(2,1):sampling:(slims(2,1)+slims(2,3));
ym = 1:sampling*2:slims(2,4);

xm1 = zeros(length(xm), length(ym));
ym1 = xm1; xo = xm1; yo = xo;

for ix = 1:length(xm)
    for iy = 1:length(ym)
        [xo(ix,iy), yo(ix,iy)] = RemapMouse(ScreenInfo.windowPtr, 'AllViews', xm(ix), ym(iy));
        xm1(ix,iy) = xm(ix);
        ym1(ix,iy) = ym(iy);
    end
end
%         [xo, yo] = RemapMouse(ScreenInfo.windowPtr, 'AllViews', xm, ym);
% xm1 = repmat(xm, length(ym),1);
% ym1 = repmat(ym', 1,length(xm));

xm1 = (xm1-slims(2,1))./slims(2,3);

ym1 = (ym1)./800;

xo = xo./1280;
yo = yo./800;
xo = xo*2 - 1;
yo = yo*2 - 1;

t = xo==0 | yo==0;
% MeshMap = [xo(~t(:)) yo(~t(:)) xm1(~t(:)) ym1(~t(:)) ones(sum(~t(:)),1)];
MeshMap = [xo(:) yo(:) xm1(:) ym1(:) ones(size(ym1(:)))];
csvwrite('MeshMapping_Neo3.csv', MeshMap);
clear AG* GL*
sca