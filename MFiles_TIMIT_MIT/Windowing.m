function [mFrames, vTimeFrame] = Windowing(vSignal, SamplingRate, FrameLength, FrameShift)
%WINDOWING requires an Audiosignal, a SampleRate, a FrameLength and a
%FrameShift.

%--------------------------------------
%
%Creating the Windows for our STFT-analysing of the selected result.
%
% @autor Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% @version 1.0 (Mai 2015)
% 
% Copyright © 2015 Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% Using the MIT License
%
%--------------------------------------

    D=FrameLength*SamplingRate;
    E=FrameShift*SamplingRate;

    for p=1:(round((length(vSignal)-D)/E))
        
        vTimeFrame(p)=round(FrameLength/2) +p*FrameShift;
        
        for i=1:D
        
        mFrames(p,i)=vSignal(i+((p-1)*E));
        
        end
    end
end

