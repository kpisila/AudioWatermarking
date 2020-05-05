audio = zeros(131072,2);
t = zeros(131072,1);
for i = 1:131072
    audio(i,1) = sin(pi*i/37);
    audio(i,2) = sin(pi*i/37);
    t(i)=i;
end
afw = dsp.AudioFileWriter('PerfectInput.wav', 'FileFormat', 'WAV');
afw(audio);
%plot(t,audio);
