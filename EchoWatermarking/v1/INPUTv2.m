[bitstream , filepath, delay0, delay1] = addwatermark_v2();
AddEchoFunction(bitstream, filepath, delay0, delay1);
bitstreamOut = readWMAudio_v2('EchoWatermarkedTest.wav', delay0, delay1);
err = immse(bitstream ,bitstreamOut)
    
%C:\Program Files\MATLAB\AudioFiles\KillerQueen.mp3
%C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\v2\AudioTracks\Anvil-Lorn\TrimmedLORN-ANVIL.mp3  
