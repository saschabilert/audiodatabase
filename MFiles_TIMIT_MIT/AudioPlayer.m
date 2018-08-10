classdef AudioPlayer
%AUDIOPLAYER creates a temporary AudioPlayer Object of a selected .wav file
%and solves the data in the following properties:
%
%   - Player
%   - Filename
%   - Fs (SamplingFrequency)
%   - NBits
%   - Data
%
% @autor Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% @version 1.0 (Mai 2015)
% 
% Copyright © 2015 Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% Using the MIT License

    properties (SetAccess = private)
        
        Player
        Filename
        Fs
        NBits
        Data
        
    end
    
    methods
        
        %creates the Audioplayer Object and solves the sevaral data in
        %different objects.
        function obj = AudioPlayer(filename)
             info = audioinfo(filename);
             obj.Fs = info.SampleRate;
             obj.Filename = filename;
             obj.NBits = info.BitsPerSample;
             obj.Data = audioread(obj.Filename);
             obj.Player = audioplayer(obj.Data,obj.Fs,obj.NBits);
        end
    end
end