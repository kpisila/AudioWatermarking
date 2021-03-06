function [bitstream, error] = readWMAudio_v2(filepath, Delay0, Delay1)
% filepath = 'EchoWatermarkedTest.wav';
% Delay0 = 256;
% Delay1 = 512;
%%%%%%%%%%%%%%%%% Loop Logic %%%%%%%%%%%%%%%%%%%                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = zeros(1,20);
% indexFor = 1;
% errorPercent = zeros(1,20);
% 
% for StdDevThreshold = 0.1:0.1:2
% t(floor(indexFor)) = StdDevThreshold;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StdDevThreshold = 25; %% Comment out when using loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

errorCode = [0 1 0 0 0 1 1];
check = zeros(4096, 2);
positionInChar = 1;
error = 0;
incorrect = 0;
errorFound = 0;
bitstream = zeros( 1, 2);
bitstreamIndex = 3;
afr = dsp.AudioFileReader(filepath, 'SamplesPerFrame', 4096);

while bitstreamIndex < 2000 %~isDone(afr)
    audio = afr();
    if (audio == check)
        if  bitstreamIndex > 10
            break;
        end
    end
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
    
    avgDelay0 = mean(mean([c(RD0a:RD0b), c(RD0c:RD0d)]));
    Delay0StdDev = mean(std([c(RD0a:RD0b), c(RD0c:RD0d)]));
    avgDelay1 = mean(mean([c(RD1a:RD1b), c(RD1c:RD1d)]));
    Delay1StdDev = mean(std([c(RD1a:RD1b), c(RD1c:RD1d)]));

    Delay0value = (max(c(RD0b:RD0c)) - avgDelay0) / Delay0StdDev;
    Delay1value = (max(c(RD1b:RD1c)) - avgDelay1) / Delay1StdDev;
    
    %statistically different point to compare to 
    Delay0Threshold = avgDelay0 + (StdDevThreshold * Delay0StdDev) * Delay_overallStdDev;
    Delay1Threshold = avgDelay1 + (StdDevThreshold * Delay1StdDev) * Delay_overallStdDev;


    [Delay0Max,maxLIndexDelay0] = max(c(RD0b:RD0c));
    [Delay1Max,maxLIndexDelay1] = max(c(RD1b:RD1c));
    
    if bitstreamIndex == 708
        disp(audio);
        %disp(c);
        disp(Delay0value);
        disp(Delay1value);
    end
    both = 0; 
    %if Delay0Threshold < Delay0Max
    if Delay0value > Delay1value
%         if rem(bitstreamIndex, 2)
%             bitstream = [bitstream, 0];
%             incorrect = incorrect + 1;
%             errorFound = 1;
%             both = 3;
%         end
%         if ~rem(bitstreamIndex, 2)
            bitstream = [bitstream, 0]; 
            both = both + 1; 
%         end
    end
    %if Delay1Threshold < Delay1Max
    if Delay1value > Delay0value
%         if ~rem(bitstreamIndex, 2)
%             bitstream = [bitstream, 0]; 
%             incorrect = incorrect + 1;
%             both = 3;
%             errorFound = 1;
%         end
%         if rem(bitstreamIndex, 2)
            bitstream = [bitstream, 1]; 
            both = both + 1;
%        end
    end 
    if both == 0
        bitstream = [bitstream, 0];
        error = error + 1;
        errorFound = 1;
    end 
    if both == 2
        bitstream = [bitstream, 2];
        error = error + 1;
        errorFound = 1;
    end 
    %disp('Error');
    %disp(error);

    %currentBit = floor(bitstreamIndex - error);
    %disp(bitstream(currentBit));
    positionInChar = positionInChar + 1;
%     if positionInChar > 7
%         if errorFound ~= 0
%             errorFound = 0;
%             charEnd = bitstreamIndex;
%             charStart = bitstreamIndex - 6;
%             bitstream(charStart:charEnd) = errorCode;
%         end
%         positionInChar = 1;
%     end 
    bitstreamIndex = bitstreamIndex + 1;
end
release(afr);
bitstream = bitstream(3:end);
% disp(bitstream);
% disp('incorrect');
% disp(incorrect);
% disp('error');
% disp(error);
% error = error + incorrect;
% percentCorrect = 100 - error / bitstreamIndex * 100;
%%%%%%%%%%%%%%%%% Loop Logic %%%%%%%%%%%%%%%%%%%                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(StdDevThreshold);
% errorPercent(floor(indexFor)) = error / bitstreamIndex * 100;
% disp(error / bitstreamIndex * 100);
% indexFor = indexFor + 1;
% end
% plot(t,errorPercent);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
