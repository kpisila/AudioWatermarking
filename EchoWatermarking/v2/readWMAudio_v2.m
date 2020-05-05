function [bitstream, error] = readWMAudio_v2(filepath, Delay0, Delay1)
% filepath = 'EchoWatermarkedTest.wav';
% Delay0 = 97;
% Delay1 = 231;
 
% t = zeros(1,20);
% indexFor = 1;
% errorPercent = zeros(1,20);
% 
% for StdDevThreshold = 1:1:20
% t(floor(indexFor)) = StdDevThreshold;

errorCode = [1 0 0 0 0 1 1];
StdDevThreshold = 25;
positionInChar = 1;
error = 0;
errorFound = 0;
bitstream = zeros( 1, 2);
bitstreamIndex = 3;
%StdDevThreshold = 6.5;
%fileSect will replace audioFile.wav
afr = dsp.AudioFileReader(filepath, 'SamplesPerFrame', 4096);

%adw = audioDeviceWriter('SampleRate', afr.SampleRate);


while bitstreamIndex < 2000 %~isDone(afr)
    audio = afr();
    oneChannel = audio(1:4096,1:1);
    AutoCepstrum = real((ifft(log(fft(oneChannel)).^2)).^2);
    c = AutoCepstrum;
    Delay_overallStdDev = std(c(5:end));
    RD0a = Delay0 - 50;
    RD0b = Delay0 - 5;
    RD0c = Delay0 + 5;
    RD0d = Delay0 + 50;
    RD1a = Delay1 - 50;
    RD1b = Delay1 - 5;
    RD1c = Delay1 + 5;
    RD1d = Delay1 + 50;
    
    peeksC = find(diff(sign(diff(c)))<0)+1;

    i = 1; 
    iDelay0 = zeros( 1, 2);
    iDelay1 = zeros( 1, 2); 
    u = 1;
    p = 1; 
    while i <= length(peeksC)
        if peeksC(i) > 200 && peeksC(i) < 300 
            iDelay0(u) = c(peeksC(i));
            u = u + 1;
        end 
        if peeksC(i) > 475 && peeksC(i) < 530 
            iDelay1(p) = c(peeksC(i));
            p = p + 1; 
        end 
        i = i +1; 
    end

    avgDelay0 = mean(mean([c(RD0a:RD0b), c(RD0c:RD0d)]));
    Delay0StdDev = mean(std([c(RD0a:RD0b), c(RD0c:RD0d)]));
    avgDelay1 = mean(mean([c(RD1a:RD1b), c(RD1c:RD1d)]));
    Delay1StdDev = mean(std([c(RD1a:RD1b), c(RD1c:RD1d)]));

    %statistically different point to compare to 
    Delay0Threshold = avgDelay0 + (StdDevThreshold * Delay0StdDev) * Delay_overallStdDev;
    Delay1Threshold = avgDelay1 + (StdDevThreshold * Delay1StdDev) * Delay_overallStdDev;


    [Delay0Max,maxLIndexDelay0] = max(c(RD0b:RD0c));
    %plot(t(maxLIndexDelay0+rangeDelay0(1)-1),maxLvalDelay0,'ko','linew',2,'markersize',5,'markerfacecolor','g')

    [Delay1Max,maxLIndexDelay1] = max(c(RD1b:RD1c));
    %plot(t(maxLIndexDelay1+rangeDelay1(1)-1),maxLvalDelay1,'ko','linew',2,'markersize',5,'markerfacecolor','g')


    both = 0; 
    if Delay0Threshold < Delay0Max
        bitstream = [bitstream, 0]; 
        both = both + 1; 
    end
    if Delay1Threshold < Delay1Max
        bitstream = [bitstream, 1]; 
        both = both + 1;
    end 
    if both == 0
        bitstream = [bitstream, 0];
        error = error + 1;
        errorFound = 1;
    end 
    if both == 2
        bitstream = [bitstream, 0];
        error = error + 1;
        errorFound = 1;
    end 
    %disp('Error');
    %disp(error);

    %currentBit = floor(bitstreamIndex - error);
    %disp(bitstream(currentBit));
    positionInChar = positionInChar + 1;
    if positionInChar > 7
        if errorFound ~= 0
            errorFound = 0;
            charEnd = bitstreamIndex;
            charStart = bitstreamIndex - 6;
            bitstream(charStart:charEnd) = errorCode;
        end
        positionInChar = 1;
    end 
    bitstreamIndex = bitstreamIndex + 1;
end
release(afr);
bitstream = bitstream(3:end);
%disp(bitstream);
% disp(StdDevThreshold);
% errorPercent(floor(indexFor)) = error / bitstreamIndex * 100;
% disp(error / bitstreamIndex * 100);
% indexFor = indexFor + 1;
% end
% plot(t,errorPercent);
end
