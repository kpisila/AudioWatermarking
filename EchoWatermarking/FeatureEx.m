
%% simulate data 

% total number of time points
N = 10000;



% create event (derivative of Gaussian) Event will be similar to the echo
k = 100; % duration of event in time points
event = diff(exp( -linspace(-2,2,k+1).^2 ));
event = event./max(event); % normalize to max=1

% event onset times
Nevents = 5;
onsettimes = randperm(N/10-k); % randomly placed points into signal noise
onsettimes = onsettimes(1:Nevents)*10;

% put event into data
data = zeros(1,N); %Creating events int signal 
for ei=1:Nevents
    data(onsettimes(ei):onsettimes(ei)+k-1) = event;
end

% add noise
data = data + 0.001*randn(size(data));



% plot data
figure(1), clf
subplot(211), hold on
plot(data)
plot(onsettimes,data(onsettimes),'ro')

%% convolve with event (as template)

% convolution
convres = conv(data,event,'same');


% plot the convolution result and ground-truth event onsets
subplot(212), hold on
plot(convres)
plot(onsettimes,convres(onsettimes),'o')

%% find a threshold

% histogram of all data values
%figure(2), clf
%hist(convres,N/20)

% pick a threshold based on histogram and visual inspection
thresh = -20;

% plot the threshold
figure(1)
subplot(212)
plot(get(gca,'xlim'),[1 1]*thresh,'k--')


% find local minima
thresh_ts = convres;
thresh_ts(thresh_ts>thresh) = 0;

% let's see what it looks like...
%%figure(2), clf
%plot(thresh_ts,'s-')

% find local minima
localmin = find(diff(sign(diff( thresh_ts )))>0)+1;


% plot local minima on top of the plot
figure(1)
% original data
subplot(211), plot(localmin,data(localmin),'ks','markerfacecolor','m')

% convolution result
subplot(212), plot(localmin,convres(localmin),'ks','markerfacecolor','m')



%% done.
