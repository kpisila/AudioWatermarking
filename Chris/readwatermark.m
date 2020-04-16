function []= readwatermark(opBit)
 opBit= convertStringsToChars(K);% converts the string back to a char
    
   i = cell2mat(opBit);% creates a matrix from a cell
   decoded = char(bin2dec(reshape(i,7,[]).')).';% reshapes the array into correct form and converts into characters
   
 
disp('Your original word is:') 
disp(decoded) % displays word for checking process