function [filepath, delay0, delay1] = getUserFilepath()    
    
    phrase1 = ['Please enter the file path where the watermarked audio is located' newline];
    filepath = input(phrase1,'s');
    
    phrase2 = ['Please enter the echo delay corresponding to a 0' newline];
    delay0 = input(phrase2);
    
    phrase3 = ['Please enter the echo delay corresponding to a 1' newline];
    delay1 = input(phrase3);
    
end