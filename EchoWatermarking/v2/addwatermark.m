function bitstream=addwatermark()


c = [1,50]; % setting a limit on input length
phrase = [ 'Please enter any word:' newline];
prompt = phrase;
code = input(prompt,'s'); % getting user input and storeing it

b = size(code); % getting the size of user input


 if (b<=c )  % checking to make sure its only 10 characters
    
     z= double(code); % getting ASCII value
   
     x = dec2bin(z); % taking ASCII value and turning into binary
     
     %this turns the code into a 10 by 7 matrix so I resized it into y
 
     y= reshape(x',[1,numel(x)]); % resize
     
     a = size(y); %checking the size of which turns out is 1 by 70 not 1 by 80
     
      Y = mat2cell(y,1,ones(numel(y),1)); % taking the reshaped and creating a cell
      
       K = convertCharsToStrings(Y); % takes cell on converts to a string
       
        P = str2double(K); %turns string into double.
        bitstream = P;
       
        
        
        
  disp('Thank you, your word is stored'); 

 end
end

