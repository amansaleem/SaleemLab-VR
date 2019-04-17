function copyToNewServer(animal_name)
% copyToNewServer(animal_name)
% Run this for all the animals that we want to transfer the VR behaviour
% data over to the new Server.

oldDir = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';
newDir = 'X:\ibn-vision\DATA\SUBJECTS';
if ~exist(oldDir);
    oldDir = 'X:\Archive - saleemlab\Data\Behav';
    newDir = 'X:\DATA\SUBJECTS';
end

oldFullDir = fullfile(oldDir, animal_name);

newAnimalDir = fullfile(newDir, animal_name);
if ~exist(newAnimalDir); mkdir(newAnimalDir); end

newFullDir = fullfile(newAnimalDir, 'VRBehaviour');
if ~exist(newFullDir); mkdir(newFullDir); end

[SUCCESS,MESSAGE,MESSAGEID] = copyfile(oldFullDir, newFullDir)