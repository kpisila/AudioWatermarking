clc 
clear all
load handel.mat

%[y,Fs]= audioread('s.wav');
%sound(y,Fs);
data_class_to_use = 'int32';   %or as appropriate
%SampleRate = 44444;      %set as appropriate

s = 'Secret message' ;
binary = reshape(dec2bin(s, 8).'-'0',1,[]);
%str = char(bin2dec(reshape(char(binary+'0'), 8,[]).'));


[wavdata,SampleRate] = audioread('w.wav');
wavbinary = dec2bin( typecast( single(wavdata(:)), 'uint8'), 8 ) - '0';
orig_size = size(wavdata);



txtbit = length(binary); % length of txt to be inserted 

  
for i=1:txtbit
    temp =  binary([i 1 ]);
    wavbinary([(i*8) 2])= temp;
    %fprintf('%d \n',wavbinary([1 1]));
end

wavdata = reshape( typecast( uint8(bin2dec( char(wavbinary + '0') )), data_class_to_use ), orig_size );
audiowrite('FileNameGoesHere.wav', wavdata, SampleRate);



    
    
    

[wavdata,SampleRate] = audioread('FIleNameGoesHere.wav');
wavbinary = dec2bin( typecast( single(wavdata(:)), 'uint8'), 8 ) - '0';
orig_size = size(wavdata);

y=wavdata;
y = y(:,1);
    dt = 1/SampleRate;
    t = 0:dt:(length(y)*dt)-dt;
    plot(t,y); xlabel('Seconds'); ylabel('Amplitude');
    figure
    plot(psd(spectrum.periodogram,y,'Fs',SampleRate,'NFFT',length(y)));

for i=1:txtbit
    temp =  wavbinary([(i*8) 2]);
    binary([i 1])= temp;
    %fprintf('%d \n',wavbinary([1 1]));
end






    
str = char(bin2dec(reshape(char(binary+'0'), 8,[]).'));  



%fprintf('%d\n',size(binary));

fprintf('%s \n',str);

