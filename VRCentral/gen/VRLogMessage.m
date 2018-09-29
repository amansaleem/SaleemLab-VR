function VRLogMessage(expInfo, message, bothLogs)
% Call this to log any message to the data log files in the central
% directory and the animal directory

if nargin<2
    message = [];
end
if nargin<3
    bothLogs = false;
end


expInfo.animalLog  = fopen(expInfo.animalLogName,'a');
expInfo.centralLog = fopen(expInfo.centralLogName, 'a');
if ~isempty(message)
    timeStamp = datestr(now,'dd-mmm-yyyy HH:MM:SS.FFF');
    fprintf(expInfo.animalLog,  '%s     %s \n',timeStamp, message);
    if bothLogs
        fprintf(expInfo.centralLog, '%s     %s \n',timeStamp, message);
    end
else
    fprintf(expInfo.animalLog,  '%s     %s \n',' ', ' ');
    if bothLogs
        fprintf(expInfo.centralLog, '%s     %s \n',' ', ' ');
    end
end
fclose(expInfo.animalLog);
fclose(expInfo.centralLog);

end