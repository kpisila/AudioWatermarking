afr = dsp.AudioFileReader('results.wma');

%adw = audioDeviceWriter('SampleRate', afr.SampleRate);

audio = afr();

counter = 0;

while counter < 4 %~isDone(afr)

    audio = [audio; afr()];

    counter = counter + 1;

  %  adw(audio);

end

release(afr); 

%release(adw);

oneChannel = audio(1:4096,1:1);

c = cceps(oneChannel);

t = 1:1:4096;

plot(t,c)