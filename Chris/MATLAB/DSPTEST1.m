[a,fs] = audioread('DOG.mp3');
[b,fs1] = audioread('DUCK.mp3');
b2 = imresize(b,[1191792,2]);
c = b2+a;

plot (c)
player1=audioplayer(c,fs);
play (player1)

pause(3)

stop (player1)

%watermarked = lowpass(player1,450,fs);
%sound(watermarked,fs)

x=fft(c);

plot(x)