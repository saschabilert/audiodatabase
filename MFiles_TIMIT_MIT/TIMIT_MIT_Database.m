classdef TIMIT_MIT_Database < handle
%TIMIT_MIT_DATABASE is the main class of our Project. Instances of this
%class contain the following properties:
%
%   - Database (formatted Dataset to enable the databaseSearch)
%   - Directory (Directory which the user can edit to find the Database
%   .txt files and the .wav files)
%   - GUI (contains a databaseGUI object)
%   - Results (hold the results of the last searchrun)
%
% @autor Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% @version 1.0 (Mai 2015)
% 
% Copyright © 2015 Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% Using the MIT License
    
    properties (SetAccess = private)
        
        Database
        Directory
        GUI   
        Results
        
    end
    
    properties (Constant)
        
        DefaultDirectory = '../TIMIT MIT/';
        
    end

    methods
        
        %Constructor maybe invoked with a directory to the TIMIT MIT folder
        %and creates a new DatabaseGUI object (opens the GUI).
        function obj = TIMIT_MIT_Database(directory)
            if nargin == 0
                obj.Directory = obj.DefaultDirectory;
            elseif nargin == 1
                obj.Directory = directory;
            end
                obj.loadDatabase
                obj.GUI = DatabaseGUI(obj);
        end
        
        %loads the Database with the input directory and sets the GUI to 
        %the applicable status.
        function loadDatabase(obj,directory)
            if nargin == 2
                obj.Directory = directory;
            end
            try
                obj.Database = obj.readTextFiles;
                obj.GUI.Handles.hDirInfo.String = 'Database successfully loaded';
                obj.GUI.Handles.hSearch.Enable = 'on';
                obj.GUI.Handles.hResults.String = '';
            catch
                obj.Database = {};
                obj.GUI.Handles.hDirInfo.String = 'Files not found';
                obj.GUI.Handles.hSearch.Enable = 'off';
                obj.GUI.Handles.hResults.Value = 1;
                obj.GUI.Handles.hResults.String = 'no results';
                obj.GUI.Handles.hResults.Enable = 'inactive';
                obj.GUI.Handles.hPlay.Enable = 'off';
                obj.GUI.Handles.hStop.Enable = 'off';
                obj.GUI.Handles.hSTFT.Enable = 'off';
                obj.GUI.Handles.hConsole.Enable = 'off';
            end
        end
        
        %This Function searches for the given searchparameters. It
        %is possible to search for a combination of parameters.
        function searchDatabase(obj, Gender, Person, SentenceID, Words, Phonems)

            obj.Results = {};
            obj.searchForMatch(Gender, Person, SentenceID, Words, Phonems)
            obj.GUI.Handles.hResults.Value = 1;
            obj.GUI.Handles.hResults.String = obj.Results;

            if isempty(obj.Results)
                obj.GUI.Handles.hResults.Value = 1;
                obj.GUI.Handles.hResults.String = 'no results';
                obj.GUI.Handles.hResults.Enable = 'inactive';
                obj.GUI.Handles.hPlay.Enable = 'off';
                obj.GUI.Handles.hStop.Enable = 'off';
                obj.GUI.Handles.hSTFT.Enable = 'off';
                obj.GUI.Handles.hConsole.Enable = 'off';
            else
                obj.GUI.Handles.hResults.Enable = 'on';
                obj.GUI.Handles.hConsole.Enable = 'on';
            end
        end
    end
    
    methods (Access = private)
        
        %This Function reads the allfilelist.txt, allphonelist.txt and
        %allsenlist.txt files and formats them to a usable cell array.
        function database = readTextFiles(obj)
        
            %opens the allfilelist.txt and save the Data in a variable.
            fileListID = fopen([obj.Directory, 'allfilelist.txt']);
            fileList = fscanf(fileListID, '%c');
            fclose(fileListID);
            
            %opens the allphonelist.txt and save the Data in a variable.
            phoneListID = fopen([obj.Directory, 'allphonelist.txt']);
            phoneList = fscanf(phoneListID, '%c');
            fclose(phoneListID);
            
            %opens the allsenlist.txt and save the Data in a variable.
            senListID = fopen([obj.Directory, 'allsenlist.txt']);
            senList = fscanf(senListID, '%c');
            fclose(senListID);

            %defines the expressions for the regexp function
            splitFiles = '[a-z\-\d\/]+';
            splitGenderPersonSenIDSentence = {'(?<=\-)[mf]';'[a-z]{3}\d(?=\/)';'(?<=\/)[a-z]{2}\d+';'(?<=\t)[a-z''\ ]+'};
            splitPhonems = '(?<=#\ )[a-z\-\ ]+(?=\ h#)';
            
            %uses the regexp function to split the .txt Data in Strings
            FileList = strcat(obj.DefaultDirectory,regexp(fileList,splitFiles,'match')','.wav');
            GenderPersonSenIDSentenceList = regexp(senList,splitGenderPersonSenIDSentence,'match');
            PhonemsList = regexp(phoneList,splitPhonems,'match');
            database = [FileList,GenderPersonSenIDSentenceList{1}.',GenderPersonSenIDSentenceList{2}.',GenderPersonSenIDSentenceList{3}.',GenderPersonSenIDSentenceList{4}.',PhonemsList'];
        end
        
        %compares the given searchparameters (gender, person, senID, words,
        %phonems) with the formatted database and saves the results in the
        %object property.Results
        function searchForMatch(obj,gender,person,senID,words,phonems)
            
            splitWords = strtrim(regexpi(words,',','split'));
            splitPhonems = strtrim(regexpi(phonems,',','split'));

            genderMatches = {};
            personMatches = {};
            senIDMatches = {};
            wordsMatches = {};
            phonemsMatches = {};

            if ischar(gender)
                for i=1:size(obj.Database,1)
                    if strcmp(obj.Database{i,2},gender)
                        genderMatches = [genderMatches; obj.Database(i,:)];
                    end
                end
            else
                genderMatches = obj.Database;
            end
            
            if ~isempty(person)
                for i=1:size(genderMatches,1)
                    if strcmp(genderMatches{i,3},person)
                        personMatches = [personMatches; genderMatches(i,:)];
                    end
                end
            else
                personMatches = genderMatches;
            end
            
            if ~isempty(senID)
                for i=1:size(personMatches,1)
                    if strcmp(personMatches{i,4},senID)
                        senIDMatches = [senIDMatches; personMatches(i,:)];
                    end
                end
            else
                senIDMatches = personMatches;
            end
            
            if ~isempty(words)
                wordfound = [];
                for i=1:size(senIDMatches,1)
                    for j=1:length(splitWords)
                        if regexp(senIDMatches{i,5},strcat('(?<![a-z])',splitWords{j},'(?![a-z])'))
                            wordfound = [wordfound, 1];
                        else
                            wordfound = [wordfound, 0];
                        end
                    end
                    if all(wordfound)
                        wordsMatches = [wordsMatches; senIDMatches(i,:)];
                    end
                    wordfound = [];
                end
            else
                wordsMatches = senIDMatches;
            end

            if ~isempty(phonems)
                phonemfound = [];
                for k=1:size(wordsMatches,1)
                    for l=1:length(splitPhonems)
                        if regexp(wordsMatches{k,6},strcat('(?<![a-z])',splitPhonems{l},'(?![a-z])'))
                            phonemfound = [phonemfound, 1];
                        else
                            phonemfound = [phonemfound, 0];
                        end
                    end
                    if all(phonemfound)
                        phonemsMatches = [phonemsMatches; wordsMatches(k,:)];
                    end
                    phonemfound = [];
                end
            else
                phonemsMatches = wordsMatches;
            end

            if ~isempty(phonemsMatches)
                obj.Results = phonemsMatches(:,1);
            end
        end
    end
end

