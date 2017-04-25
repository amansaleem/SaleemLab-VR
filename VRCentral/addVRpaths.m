function addVRPaths(savePaths)
%addVRPaths Adds the required paths for using VRCentral
%
%   Part of the VRCentral toolbox
% 2017-04 AS

if nargin < 1
  savePaths = true;
end

VRCentralPath = fileparts(mfilename('fullpath'));
cbToolsPath = fullfile(VRCentralPath, 'cb-tools');

%%%% Add the behaviour / code folders here %%%%
addpath(...
...%   cortexLabAddonsPath,... % add the behaviour folders here
  VRCentralPath,... % add Rigbox itself
  cbToolsPath,... % add cb-tools root dir
  fullfile(cbToolsPath, 'burgbox'),...
  fullfile(VRCentralPath, 'gen'),...
  fullfile(VRCentralPath, 'data') ); % Burgbox

if savePaths
  assert(savepath == 0, 'Failed to save changes to MATLAB path');
end

%% This section is to save the paths for the Java, websockets stuff
cbtoolsjavapath = fullfile(cbToolsPath, 'java');
javaclasspathfile = fullfile(prefdir, 'javaclasspath.txt');
fid = fopen(javaclasspathfile, 'a+');
fseek(fid, 0, 'bof');
closeFile = onCleanup( @() fclose(fid) );
javaclasspaths = first(textscan(fid,'%s', 'CommentStyle', '#',...
  'Delimiter','')); % this will crash on 2014b
cbtoolsInJavaPath = any(strcmpi(javaclasspaths, cbtoolsjavapath));

if savePaths
%   assert(savepath == 0, 'Failed to save changes to MATLAB path');
  if ~cbtoolsInJavaPath
    fseek(fid, 0, 'eof');
    n = fprintf(fid, '\n#path to CB-tools java classes\n%s', cbtoolsjavapath);
    assert(n > 0, 'Could not write to ''%s''', javaclasspathfile);
    warning('Rigbox:setup:restartNeeded',...
    'Updated Java classpath, please restart MATLAB');
  end
elseif ~cbtoolsInJavaPath
  warning('Rigbox:setup:javaNotSetup',...
    'Cannot use java classes without saving new classpath');
end
end