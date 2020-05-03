
prompt = [ 'Which Bit would you like to see?' newline];
code = input(prompt); % getting user input and storeing it

bitNumber = code;

segments = 4;
segmentLength = segments*1024;

afr = dsp.AudioFileReader('EchoWatermarkedTest.wav', 'SamplesPerFrame', segmentLength);


audio2 = zeros(segmentLength, 2);
counter = 0;
if bitNumber > 1
    for i = 1:(bitNumber - 1)
       audio = afr();
    end
end
audio2 = afr();
release(afr); 

oneChannel = audio2(1:segmentLength,1:1);
AutoCepstrum = real((ifft(log(fft(oneChannel)).^2)).^2);
%c = cceps(oneChannel);
t = 1:1:segmentLength;
%plot(t,oneChannel);
%hold on

plot(t,AutoCepstrum);

%hold off