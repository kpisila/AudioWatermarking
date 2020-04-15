function Echo = addDelay(delay, mixRatio, currentAudio, previousAudio)

    afterDelay = delay + 1;
    startSecond = 1025 - delay;
    endFirst = 1024 - delay;

    tempAudio = zeros(1024,2);  %initialize matrix for splicing
    tempAudio(1:endFirst,1:2) = previousAudio(afterDelay:end,1:2);%take the second half of the previous chunk

    tempAudio(startSecond:end,1:2) = currentAudio(1:delay,1:2);    %second chunk as the second
                                                %half of the splice.
    Echo = (currentAudio * (1 - mixRatio)) + (tempAudio * mixRatio);
end
