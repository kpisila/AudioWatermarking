function [bitstream] = readWMAudio_v3(filepath, Delay0, Delay1)

    check = zeros(4096, 2);
    bitstream = zeros( 1, 2);
    bitstreamIndex = 3;
    afr = dsp.AudioFileReader(filepath, 'SamplesPerFrame', 4096);

    while ~isDone(afr) %bitstreamIndex < 2000 %
        audio = afr();
        if (audio == check)
            if  bitstreamIndex > 10
                break;
            end
        end
        oneChannel = audio(1:4096,1:1);
        AutoCepstrum = real((ifft(log(fft(oneChannel)).^2)).^2);
        c = AutoCepstrum;

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

        if Delay0value >= Delay1value
                bitstream = [bitstream, 0];
        end
        if Delay1value > Delay0value
                bitstream = [bitstream, 1];
        end
    end
    release(afr);
    bitstream = bitstream(3:end);
end
