

c = [1,10]; % setting our legnth standard
phrase = [ 'Please enter a 10 character word:' newline];
prompt = phrase;
code = input(prompt,'s'); % getting user input and storeing it

b = size(code); % getting the size of user input


 if (b == c)  % checking to make sure its only 10 characters
    
     
     x = dec2bin(code); % taking user input and turning into binary
     
     %this turns the code into a 10 by 7 matrix so I resized it into y
 
     y= reshape(x',1,numel(x)); % resize
     
     a = size(y); %checking the size of which turns out is 1 by 70 not 1 by 80
  disp('Thank you, your word is stored'); 

   pause(2)
    

   decoded = char(bin2dec(reshape(y,7,[]).')).';% reshapes the array into correct form and converts into characters
   
 
disp('Your original word is:') 
disp(decoded) % displays word for checking process

 else
     disp('Error, Must be 10 characters!');% if user input is not exactly 10, error pops up
     
    
 end
