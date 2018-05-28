function savingFolder = getSavingFolder()
    subjectFolder = getSubjectFolder();
    listSession = {};
    sessions = dir(subjectFolder);
    for sessionIndex = 3:length(sessions)
        if sessions(sessionIndex).isdir
            listSession{end+1} = sessions(sessionIndex).name;
        end
    end
    if isempty(listSession)
        sessionID = inputdlg('Enter session ID', 'Session ID');
        mkdir([subjectFolder sessionID{1}]);
    else
        answer = questdlg('', ...
            'Select session', ...
            'Select previous session', ...
            'Create new session', 'Create new session');
        switch answer
            case 'Select previous session'
                index = listdlg('ListString',listSession);
                sessionID = listSession(index);
            case 'Create new session'
                sessionID = inputdlg('Enter session ID', 'session ID');
                mkdir([subjectFolder sessionID{1}]);
        end
    end
    savingFolder = [subjectFolder sessionID{1} '/'];
end

function subjectFolder = getSubjectFolder()
%     dataDirectory = 'E:\WORKSPACE\EPFL\vibrotactile_cnbi\SPA_characterization_experiment\experiment\characterization_data\';
    dataDirectory='/home/cnbiadmin/SPA_characterization_experiment/experiment/characterization_data/';
    experimentDirecotry = [dataDirectory 'psychometricSPA/'];
    subjects = dir(experimentDirecotry);
    listSubjects = {};
    if length(subjects) <= 2
        mkdir(experimentDirecotry)
        subjectID = inputdlg('Enter subject ID', 'Subject ID');
        mkdir([experimentDirecotry subjectID{1}]);
    else
        for subjectIndex = 3:length(subjects)
            if subjects(subjectIndex).isdir
                listSubjects{end+1} = subjects(subjectIndex).name;
            end
        end
        answer = questdlg('', 'Select subject', ...
            'Select previous subject', ...
            'Create new subject', 'Create new subject');
        switch answer
            case 'Select previous subject'
                index = listdlg('ListString',listSubjects);
                subjectID = listSubjects(index);
            case 'Create new subject'
                subjectID = inputdlg('Enter subject ID', 'Subject ID');
                mkdir([experimentDirecotry subjectID{1}]);
        end
    end
    subjectFolder = [experimentDirecotry subjectID{1} '/'];
end
