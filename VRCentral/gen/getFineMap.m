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
transformFile = 'C:\Home\Code\SaleemLab-VR\VRCentral\gen\MeshMapping_VR.mat';
PsychImaging('AddTask', 'AllViews', 'GeometryCorrection', transformFile);
PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');

[ScreenInfo.windowPtr, ScreenInfo.screenRect] = PsychImaging('OpenWindow', WhichScreen, ScreenInfo.grayIndex);
get(0,'MonitorPositions');

sampling = 1; % no.of pixels

xm = 1081:sampling:(1081+1280);
ym = 1:sampling:800;
[xo, yo] = RemapMouse(ScreenInfo.windowPtr, 'AllViews', xm, ym);

xm1 = repmat(xm, 800,1);
ym1 = repmat(ym', 1,1281);

xm1 = (xm1-1081)./1280;
xm1 = xm1*2 - 1;

ym1 = (ym1)./800;
ym1 = ym1*2 - 1;

xo = xo./1280;
yo = yo./800;

t = xo==0 | yo==0;
MeshMap = [xm1(~t(:)) ym1(~t(:)) xo(~t(:)) yo(~t(:)) ones(sum(~t(:)),1)];
csvwrite('MeshMapping_Neo3.csv', MeshMap);