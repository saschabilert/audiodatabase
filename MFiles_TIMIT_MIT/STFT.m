function [ mSTFT, vFreq] = STFT( mFrames, dFs, vAnalysisWindow )
%STFT requires the mFrames of the Windowing function, the
%SamplingFrequency of a selected .wav file and the analysed Windows.
%
%--------------------------------------
%
%Using the FFT function of matlab to create a STFT image.
%
% @autor Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% @version 1.0 (Mai 2015)
% 
% Copyright © 2015 Eike Claaßen, Jan-Michel Grüttgen, Sascha Bilert
% Using the MIT License
%
%--------------------------------------
NFFT = length(vAnalysisWindow); 

    for i=1:size(mFrames,1);
        mSTFT(:,i)=fft(mFrames(i,:),NFFT);
    
        vFreq= dFs/2*linspace(0,1,NFFT/2+1);
    end
    
mSTFT=(mSTFT(1:NFFT/2+1,:));

