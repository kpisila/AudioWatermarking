%function []= readwatermark(opBit)
   opBit = [1 0 1 0 1 0 1]; 
   BitLength = numel(opBit);
   numChars = floor(BitLength / 7);
   numUsableBits = floor(numChars * 7); %%%%%%%%%%%%%%%%%%%%%%%%%%% Work in Progress Here
   truncated = opBitTemp(1:numUsableBits);
   opBitTemp = num2str(truncated);% converts the string back to a char
    
   %i = cell2mat(opBit);% creates a matrix from a cell
   
   %decoded = char(bin2dec(reshape(truncated,7,[]).')).';% reshapes the array into correct form and converts into characters
   
 
disp('Your original word is:');
%disp(decoded) % displays word for checking process