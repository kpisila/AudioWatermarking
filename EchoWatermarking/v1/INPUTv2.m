[bitstream , filepath, delay0, delay1] = addwatermark_v2();
AddEchoFunction(bitstream, filepath, delay0, delay1);
bitstreamOut = readWMAudio_v2('EchoWatermarkedTest.wav', delay0, delay1);
for i = 1:20
    bitstream = [bitstream, bitstream];
end
bitstreamIn = bitstream(1:numel(bitstreamOut));
err = immse(bitstream ,bitstream)

%C:\Program Files\MATLAB\AudioFiles\KillerQueen.mp3
%C:\Users\Kai\Documents\GitHub\AudioWatermarking\LSB\input.wav
