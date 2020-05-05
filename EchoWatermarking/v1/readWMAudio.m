function [opBit, error] = readWMAudio(filepath, delay0, delay1)
% filepath = 'C:\Users\Kai\Documents\GitHub\EchoWatermarkedTest.wav';
% delay0 = 256;
% delay1 = 512;

error = 0;
opBit = zeros( 1, 2);
opBitidx = 1;
%fileSect will replace audioFile.wav
afr = dsp.AudioFileReader(filepath, 'SamplesPerFrame', 4096);

%adw = audioDeviceWriter('SampleRate', afr.SampleRate);


while ~isDone(afr)
    audio = afr();
 

 
%release(adw);
oneChannel = audio(1:4096,1:1);
AutoCepstrum = real((ifft(log(fft(oneChannel)).^2)).^2);
c = AutoCepstrum; %cceps(oneChannel);
%t = 1:1:4096;


%figure(1), clf, hold on
%plot(t,c)

RD0a = delay0 - 10;
RD0b = delay0 + 10;
RD1a = delay1 - 10;
RD1b = delay1 + 10;
rangedelay0 = [RD0a RD0b];
rangedelay1 = [RD1a RD1b]; 

% i = rangedelay1(1);
% while i< rangedelay1(2)
peeksC = find(diff(sign(diff(c)))<0)+1;

%plots all peek values 
%plot(t(peeksC),c(peeksC),'ro','linew',2,'markersize',10,'markerfacecolor','y')

%taking the index from the local maxima around the delay0 and delay1 points
i = 1; 
idelay0 = zeros( 1, 2);
idelay1 = zeros( 1, 2); 
u = 1;
p = 1; 
while i <= length(peeksC)
    if peeksC(i) > 200 && peeksC(i) < 300 
        idelay0(u) = c(peeksC(i));
        u = u + 1;
    end 
    if peeksC(i) > 475 && peeksC(i) < 530 
        idelay1(p) = c(peeksC(i));
        p = p + 1; 
    end 
    i = i +1; 
end

avgdelay0 = mean(idelay0);
stdevdelay0 = std(idelay0);
avgdelay1 = mean(idelay1);
stdevdelay1 = std(idelay1);

%statistically different point to compare to 
compdelay0 = avgdelay0 + 3 * stdevdelay0;
compdelay1 = avgdelay1 + 3 * stdevdelay1;


[maxLvaldelay0,maxLidxdelay0] = max(c(rangedelay0(1):rangedelay0(2)));
%plot(t(maxLidxdelay0+rangedelay0(1)-1),maxLvaldelay0,'ko','linew',2,'markersize',5,'markerfacecolor','g')

[maxLvaldelay1,maxLidxdelay1] = max(c(rangedelay1(1):rangedelay1(2)));
%plot(t(maxLidxdelay1+rangedelay1(1)-1),maxLvaldelay1,'ko','linew',2,'markersize',5,'markerfacecolor','g')


both = 0; 
if compdelay0 < maxLvaldelay0
    opBit = [opBit, 0]; 
    both = both + 1; 
end
if compdelay1 < maxLvaldelay1
    opBit = [opBit, 1]; 
    both = both + 1;
end 
if both == 0 || both == 2
    error = error + 1;
end 
%disp('Error');
%disp(error);
opBitidx = opBitidx + 1;
currentBit = floor(opBitidx - error);
%disp(opBit(currentBit));
end
release(afr);
%disp('Error');
%disp(error);
end

