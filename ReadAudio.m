afr = dsp.AudioFileReader('04-Walk This Way.mp3');
adw = audioDeviceWriter('SampleRate', afr.SampleRate);

while ~isDone(afr)
    audio = afr();
    adw(audio);
end
release(afr); 
release(adw);