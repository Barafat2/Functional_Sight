
%% Load data
load('edf1_part.mat');

%% eye movement filtering
x = edf1_part.posX(250:end); % x value
y = edf1_part.posY(250:end);

% find all the nan values
x(x > 750 |x <450) = NaN;
y(y > 600 |y <200) = NaN;
[r, ~] = find(isnan(y) | isnan(x)); 

% find the starts and stops of each blink and length 
blink_index = find((diff(r) ~= 1)==1);
nan_onset = blink_index(1:end)+1; nan_onset = [1; nan_onset(1:end-1)];
nan_offset= blink_index(1:end)-1;
blink_length = r(nan_offset) - r(nan_onset)+1;

% Interpolation
for i = 1:length(blink_length)
    if rem(blink_length(i),2)==0 % if the length is even
        l=blink_length(i)/2;
        onset = r(nan_onset(i))-2;
        offset= r(nan_offset(i))+2;
        x(onset:(onset+l))   = x(onset-1);
        x(onset+l+1:offset) = x(offset+1);
        y(onset:(onset+l))   = y(onset-1);
        y(onset+l+1:offset) = y(offset+1);
        
    else
        l=(blink_length(i)-1)/2;
        onset  = r(nan_onset(i))-2;
        offset = r(nan_offset(i))+2;
        x(onset:onset+l+1)   = x(onset-1);
        x(onset+l+2:offset) = x(offset+1);
        y(onset:onset+l+1)   = y(onset-1);
        y(onset+l+2:offset) = y(offset+1);

    end
end 


%% Pupil size filtering 

pupil = edf1_part.pupilSize(250:end);
pupil(pupil < 1000) = NaN;

inn = ~isnan(pupil);
i1 = (1:numel(pupil)).';
pp = interp1(i1(inn),pupil(inn),'linear','pp');
out = fnval(pp,linspace(i1(1),i1(end),1000));


%% figure
f = figure('Name','Removing Blinks Eye movement'); f.Position=[10 10 1000 500];
subplot(3,4,1)
plot(edf1_part.posX); xlabel('time (ms)'); ylabel('x location'); title('Horizontal location - raw'); ylim([400 800]);

subplot(3,4,2)
plot(x); xlabel('time (ms)'); ylabel('x location'); title('Horizontal location - filtered'); ylim([400 800]);

subplot(3,4,5)
plot(edf1_part.posY); xlabel('time (ms)'); ylabel('y location'); title('Vertical location - raw'); ylim([0 1000]);

subplot(3,4,6)
plot(y); xlabel('time (ms)'); ylabel('y location'); title('Vertical location - filtered'); ylim([0 1000]);

subplot(3,4,9); 
plot(edf1_part.pupilSize); xlabel('time (ms)'); ylabel('pupil size'); title('Pupil dilation - raw'); ylim([500 3000]);

subplot(3,4,10); 
plot(out); xlabel('time (ms)'); ylabel('pupil size'); title('Pupil dilation - filteres'); ylim([500 3000]);

subplot(3,4,[3 4 7 8 11 12])
plot(x,y); xlabel('x (mm)'); ylabel('y (mm)'); title('Eye Movement Trace');


%% find individual eye movements
ischange(x) 

%% find size of eye movements

