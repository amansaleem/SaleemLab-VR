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
transformFile = 'C:\Home\Code\SaleemLab-VR\VRCentral\gen\MeshMapping_VR.mat'
PsychImaging('AddTask', 'AllViews', 'GeometryCorrection', transformFile);
PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');

[ScreenInfo.windowPtr, ScreenInfo.screenRect] = PsychImaging('OpenWindow', WhichScreen, ScreenInfo.grayIndex);
get(0,'MonitorPositions')

xm = 1081:(1081+1280);
ym = 1:800;
[xo, yo] = RemapMouse(ScreenInfo.windowPtr, 'AllViews', xm, ym);