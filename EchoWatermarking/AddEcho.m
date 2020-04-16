
spf = 32768;
for i = 1:2
    %%%%%%%%%%%%%%%%%%%%% Create MATLAB objects to read the audio file %%%%%%%%
    afr1 = dsp.AudioFileReader('C:\Program Files\MATLAB\AudioFiles\TheCarSong.mp3', 'SamplesPerFrame', spf);
    afr2 = dsp.AudioFileReader('C:\Program Files\MATLAB\AudioFiles\TheCarSong.mp3', 'SamplesPerFrame', spf);

    %%%%%%%%%%%%%%%%%% Create MATLAB objects to write new audio files %%%%%%%%%

    afw1 = dsp.AudioFileWriter('C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\OutputAudio\Echo1.wma', 'FileFormat', 'WMA');
  
    afw2 = dsp.AudioFileWriter('C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\OutputAudio\Echo2.wma', 'FileFormat', 'WMA');
   
    %%%%%%%%%%% Create MATLAB object to play the altered audio %%%%%%%%%%%%%%%%
    adw = audioDeviceWriter('SampleRate', afr2.SampleRate);

    %%%%%%%%%%%% every time an audio file reader is called, it %%%%%%%%%%%%%%%
    %%%%%%%%%%%% returns the next 1024 x 2 array of the file   %%%%%%%%%%%%%%
    %%%%%%%%%%%% If one copy is called first before we start   %%%%%%%%%%%%%%
    %%%%%%%%%%%% The loop, it is ahead by one step.             %%%%%%%%%%%%%%

    delay = 256*i;    %%%%%%%% Alter this value to change the added delay

    afterDelay = delay + 1;
    startSecond = spf + 1 - delay;
    endFirst = spf - delay;

    counter = 0;
    audio2 = afr2();
    audio4 = zeros(spf,2);  %initialize temp matrix for splicing

    firsthalf = audio2(afterDelay:end,1:2);%take the second half of the first chunk

    while ~isDone(afr1)%counter < 500
        audio4(1:endFirst,1:2) = firsthalf;  %use it as the first half of the splice

        audio1 = afr1();
        audio2 = afr2();

                                                    %use the first half of the
        audio4(startSecond:end,1:2) = audio2(1:delay,1:2);    %second chunk as the second
                                                    %half of the splice.

        firsthalf = audio2(afterDelay:end,1:2);%take the second half of the second 
                                        %chunk and save it for next time

        audio3 = (audio1 * 1) + (audio4 * .3);
    %     if counter == 1       This is an alternate way of creating echo,
    %        afr2.reset();      reset starts the second copy at the beginning
    %     end                   It is limited to multiples of the chunk size

        %adw(audio3);            %play the audio chunk
        
        if(i == 1)
            afw1(audio3);            %save the audio chunk
        end
        if(i == 2)
            afw2(audio3);            %save the audio chunk
        end
        counter = counter + 1;  %then move to the next chunk
    end
    %afr1.reset();
    %counter = 0;
    %while counter < 500
     %   audio1 = afr1();
      %  adw(audio1);
       % counter = counter +1;
    %end
    release(afr1); 
    release(afr2); 
    release(adw);
    release(afw1);
    release(afw2);
end
spf2 = 4096;
afr3 = dsp.AudioFileReader('C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\OutputAudio\Echo1.wma', 'SamplesPerFrame', spf2);
afr4 = dsp.AudioFileReader('C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\OutputAudio\Echo2.wma', 'SamplesPerFrame', spf2);
totalFrames = counter * 8

bitstream = zeros(totalFrames,1);
for j = 1:totalFrames
    if(mod(j,2))
        bitstream(j) = 1;
    end
end
afw2 = dsp.AudioFileWriter('C:\Users\Kai\Documents\GitHub\AudioWatermarking\EchoWatermarking\OutputAudio\EchoWatermarkedTest.wma', 'FileFormat', 'WMA');

mixCounter = 1;
length = numel(bitstream);
repeat = 0;

while mixCounter <= totalFrames
    audio1 = afr3();
    audio2 = afr4();
    
    if(bitstream(mixCounter - repeat*length) == 0)
        afw2(audio1);
    end
    if(bitstream(mixCounter - repeat*length) == 1)
        afw2(audio2);
    end
    
    mixCounter = mixCounter + 1;
    if(mixCounter > length * (repeat + 1))
        repeat = repeat + 1;
    end
end