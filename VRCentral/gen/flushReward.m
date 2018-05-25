function flushReward(t, isLive, nrep)
% Function to flush the reward valve
% flushReward(t, isLive, nrep)
% t      - time of reward valve opening
% isLive - use space bar to open value repeatedly, 'Esc' to close
% nrep   - number of times to open the value, with a 1 s pause

if nargin<2
    isLive = false;
end

if nargin<3
    nrep = 1;
end

[foo,hostname] = system('hostname');
hostname = upper(hostname(1:end-1));

fprintf('Host name is %s\n', hostname);

switch upper(hostname)
    %%%
    case 'SALEEM06'
        obj = serial('com3'); % trinity
    case 'SALEEM09'
        obj = serial('com4'); % tank
    case 'SALEEM10'
        obj = serial('com6'); % switch
    case 'SALEEM03'
        obj = serial('com5'); % morpheus
    case 'SALEEM05'
        obj = serial('com5'); % tomaso's desk PC
    case 'SALEEM08'
        obj = serial('com6'); % N PC
end
set(obj,'BaudRate',250000);

if isLive
    while isLive
        rigInfo.comms = [];
        keyType = checkKeyboard(rigInfo);
        if keyType == 1
            isLive = false;
        end
        if keyType == 2
            run_rest;
        end
    end
else
    run_rest;
end

    function run_rest
        for irep = 1:nrep
            fopen(obj);
            OpeningTime = t; % in ms
            flushinput(obj)
            fprintf(obj, '%s\r', num2str(OpeningTime));
            fclose(obj)
            pause(1)
        end
    end
end