function [] = AddEchoFunction_v3(bitstream, filepath, delay0, delay1)
spf = 32768;
maxValue = 0;
for i = 1:2
    %%%%%%%%%%%%%%%%%%%%% Create MATLAB objects to read the audio file %%%%%%%%
    afr1 = dsp.AudioFileReader(filepath, 'SamplesPerFrame', spf);
    afr2 = dsp.AudioFileReader(filepath, 'SamplesPerFrame', spf);

    %%%%%%%%%%%%%%%%%% Create MATLAB objects to write new audio files %%%%%%%%%

    afw1 = dsp.AudioFileWriter('Echo1.wav', 'FileFormat', 'WAV');
  
    afw2 = dsp.AudioFileWriter('Echo2.wav', 'FileFormat', 'WAV');
   
    %%%%%%%%%%% Create MATLAB object to play the altered audio %%%%%%%%%%%%%%%%
    adw = audioDeviceWriter('SampleRate', afr2.SampleRate);

    %%%%%%%%%%%% every time an audio file reader is called, it %%%%%%%%%%%%%%%
    %%%%%%%%%%%% returns the next 1024 x 2 array of the file   %%%%%%%%%%%%%%
    %%%%%%%%%%%% If one copy is called first before we start   %%%%%%%%%%%%%%
    %%%%%%%%%%%% The loop, it is ahead by one step.             %%%%%%%%%%%%%%
    if i == 1
        delay = delay0;    %%%%%%%% Alter this value to change the added delay
    end
    if i == 2
        delay = delay1;
    end
    afterDelay = delay + 1;
    startSecond = spf + 1 - delay;
    endFirst = spf - delay;

    counter = 0;
    audio2 = afr2();
    audio4 = zeros(spf,2);  %initialize temp matrix for splicing

    firsthalf = audio2(afterDelay:end,1:2);%take the second half of the first chunk

    while ~isDone(afr1)
        
        audio4(1:endFirst,1:2) = firsthalf;  %use it as the first half of the splice

        audio1 = afr1();
        audio2 = afr2();                                    
                                                            %use the first half of the
        audio4(startSecond:end,1:2) = audio2(1:delay,1:2);  %second chunk as the second
                                                            %half of the splice.
                                                    
        firsthalf = audio2(afterDelay:end,1:2);%take the second half of the second 
                                                %chunk and save it for next time
        audio3 = (audio1 * 0.7) + (audio4 * .3);

        maxValue = max(max(audio3), maxValue);
        if(i == 1)
            afw1(audio3);            %save the audio chunk
        end
        if(i == 2)
            afw2(audio3);            %save the audio chunk
        end
        counter = counter + 1;  %then move to the next chunk
    end
    release(afr1); 
    release(afr2); 
    release(adw);
    release(afw1);
    release(afw2);
end

spf2 = 4096;
afr3 = dsp.AudioFileReader('Echo1.wav', 'SamplesPerFrame', spf2);
afr4 = dsp.AudioFileReader('Echo2.wav', 'SamplesPerFrame', spf2);
totalFrames = counter * 8;

afw2 = dsp.AudioFileWriter('EchoWatermarkedTest.wav', 'FileFormat', 'WAV');

mixCounter = 1;
lengthb = length(bitstream);
repeat = 0;

while mixCounter <= totalFrames
    audio1 = afr3();
    audio2 = afr4();
    
    if(bitstream(mixCounter - repeat*lengthb) == 0)
        afw2(audio1);
    end
    if(bitstream(mixCounter - repeat*lengthb) == 1)
        afw2(audio2);
    end
    
    mixCounter = mixCounter + 1;
    if(mixCounter > lengthb * (repeat + 1))
        repeat = repeat + 1;
    end
end