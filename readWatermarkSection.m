  
afr = dsp.AudioFileReader('audioFile.wav');
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


figure(1), clf, hold on
plot(t,c)


range256 = [245 265];
range512 = [500 520]; 
% i = range512(1);
% while i< range512(2)
peeksC = find(diff(sign(diff(c)))<0)+1;

%plots all peek values 
%plot(t(peeksC),c(peeksC),'ro','linew',2,'markersize',10,'markerfacecolor','y')

%taking the index from the local maxima around the 256 and 512 points
i = 1; 
i256 = zeros( 1, 2);
i512 = zeros( 1, 2); 
u = 1;
p = 1; 
while i<= length(peeksC)
    if peeksC(i) > 200 && peeksC(i) < 300 
        i256(u) = c(peeksC(i));
        u = u + 1;
    end 
    if peeksC(i) > 475 && peeksC(i) < 530 
        i512(p) = c(peeksC(i));
        p = p + 1; 
    end 
    i = i +1; 
end

avg256 = mean(i256);
stdev256 = std(i256);
avg512 = mean(i512);
stdev512 = std(i512);

%statistically different point to compare to 
comp256 = avg256 + 3 * stdev256;
comp512 = avg512 + 3 * stdev512;


[maxLval256,maxLidx256] = max(c(range256(1):range256(2)));
plot(t(maxLidx256+range256(1)-1),maxLval256,'ko','linew',2,'markersize',5,'markerfacecolor','g')

[maxLval512,maxLidx512] = max(c(range512(1):range512(2)));
plot(t(maxLidx512+range512(1)-1),maxLval512,'ko','linew',2,'markersize',5,'markerfacecolor','g')

error = 0;
opBit = 0;
both = 0; 
if comp256 < maxLval256
    opBit = 0; 
    both = both + 1; 
end
if comp512 < maxLval512
    opBit = 1; 
    both = both + 1;
end 
if both == 0 || both == 2
    error = error + 1;
end 



