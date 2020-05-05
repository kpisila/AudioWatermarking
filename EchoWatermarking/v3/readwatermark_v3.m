function [] = readwatermark_v3(opBit)
    %opBit = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]; 
    %%%%%% First clip the bitstream to whole 7-bit chars
    BitLength = numel(opBit);
    numChars = floor(BitLength / 7);
    numUsableBits = floor(numChars * 7);
    truncated = opBit(1:numUsableBits);

    %%%%%% Then convert the stream of bits into a character array
    reshaped = (reshape(truncated,7,[]).'); %place each group of 7 bits in 1 row
    opBitTemp = num2str(reshaped);% convert the rows of 1s and 0s to strings
    i = num2cell(opBitTemp, 2);% covert the array to a cell array(required by bin2dec)
    decoded = char(bin2dec(i).');% converts into characters
   
 
    disp('Your original word is:') 
    disp(decoded) % displays word for checking process
end