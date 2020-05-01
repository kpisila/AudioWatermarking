afr = dsp.AudioFileReader('C:\Users\Kai\Documents\GitHub\EchoWatermarkedTest.wav');
adw = audioDeviceWriter('SampleRate', afr.SampleRate);

bitNumber = 5;

segments = 4;
segmentLength = segments*1024;
audio2 = zeros(segmentLength, 2);
counter = 0;
if bitNumber > 1
    for i = 1:(bitNumber - 1)*segments
       audio = afr(); 
    end
end
while counter < segments %~isDone(afr)
    temp1 = 1024*counter + 1;
    temp2 = 1024*(counter + 1);
    audio = afr();
    adw(audio);
    audio2(temp1:temp2,1:2) = audio;
    counter = counter + 1
end
release(afr); 
release(adw);
oneChannel = audio2(1:segmentLength,2:2);
c = cceps(oneChannel);
t = 1:1:segmentLength;
plot(t,oneChannel)
plot(t,c)