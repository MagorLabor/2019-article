%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:  Wrapper function for alignAndPlotTimes. Distant fork of
%               S?ndor Bord?'s corresponding script. 
%               Reads the inputfile and and passes its data with preset
%               parameters to the alignAndPlotTimes subroutine.
% 
% Author:       Tibor Guba
%
% Disclaimer:   This code is freely usable for non-profit scientific purposes.
%               I do not warrant that the code is bug free. Use it at your own risk!
%
% Input:        name - String of the file to be analyzed. (Has to be in
%               the working folder.)
% 
%
% Hardcoded
% Input:        makepic - 1 if you want to create a figure, 0 if not.
% 
% 
% Output:       duration - average duration of the spikes to determine it
%               beeing FS or RS
%               hon - perievent histogram (onset)
%               hoff - perievent histogram (offset)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ duration , hon , hoff ] = spike_analysis_subroutine(name) 

hon = NaN;
hoff = NaN;

load(name)
makepic = 0;
set(0,'DefaultFigureWindowStyle','docked')




%% Hisztogramok
resolution = offset.resolution;
T_onset = onset.times;
T_offset = offset.times;
spiketime = spikes.times; 
spikesv = spikes.values;

% N_spike = length(spikesv);

AVGSPIKE = mean(spikesv,1);
STDSPIKE = std(spikesv,0,1);


[ duration , halfampl ] = SpikeWidth(AVGSPIKE);
time = 1000*resolution*[0:length(AVGSPIKE)-1];
vonal = halfampl*ones(length(time),1);

duration = length(AVGSPIKE) * duration * resolution*1000; %ms

figure
plot(time, AVGSPIKE)
hold on
plot(time, AVGSPIKE-STDSPIKE , ':k' )
plot(time, AVGSPIKE+STDSPIKE , ':k' )
plot(time,vonal)
hold off

ax = gca;
ylabel('Activation Potential (mV)');
xlabel('Time [ms]');
title(strcat('Average spike ( ' , name , ' )' ))
% saveas(gcf,strcat('avgspike_',name ,'.png'))

N_ictal = length(T_onset);

Fire_ictal = zeros(N_ictal,1);
Fire_interictal = zeros(N_ictal-1,1);
I_rate = zeros(N_ictal,1);
II_rate = zeros(N_ictal-1,1);

for i = 1: N_ictal
    on = T_onset(i);
    off = T_offset(i);
    ictaltime = off - on;
    index=spiketime>on & spiketime<off; 
    
    Fire_ictal(i) = sum(index(:) == 1);
    I_rate(i) = Fire_ictal(i) / ictaltime;
end


for i = 1: N_ictal-1
    on = T_onset(i+1);
    off = T_offset(i);
    
    interictaltime = on-off;
    
    index=spiketime<on & spiketime>off; 
    
    Fire_interictal(i) = sum(index(:) == 1);
    II_rate(i) = Fire_interictal(i) / interictaltime;

end

% Az SWD az EEG-hez tartozik Spike and wave Discharge. Gyakorlatilag
% egyenl? mag?val a rohammal.


halfinterval = 2.5;

%% C?l egy hisztogram a spikeok sz?m?r?l az onset ?s az offset 2,5 ms sugar?
%% k?rnyezet?ben. ?tlag mind a 11 esem?nyre.

for i = 1:N_ictal
        on = T_onset(i);
        off = T_offset(i);
%         center = find(spiketime == on);
    
    
        index=spiketime<on+halfinterval & spiketime>on-halfinterval; 
        k = find(index);
        histogr_preprocess(i).on = k;  
        
        
        index=spiketime<off+halfinterval & spiketime>off-halfinterval; 
        k = find(index);
        histogr_preprocess(i).off = k;
end
% 
% for i = 1 : N_ictal
% 
%         histogr_preprocess(i).ontime = spiketime(histogr_preprocess(i).on(1):histogr_preprocess(i).on(end));
%         histogr_preprocess(i).offtime = spiketime(histogr_preprocess(i).off(1):histogr_preprocess(i).off(end));
% 
%         histogr_preprocess(i).ontime = histogr_preprocess(i).ontime - T_onset(i);
%         histogr_preprocess(i).offtime = histogr_preprocess(i).offtime - T_offset(i);
% end
% 
% bighiston =  histogr_preprocess(1).ontime;
% bighistoff =  histogr_preprocess(1).offtime;
% 
% for i = 2: N_ictal
%     
%     bighiston =  [bighiston ; histogr_preprocess(i).ontime];
%     bighistoff = [bighistoff ; histogr_preprocess(i).offtime];
%     
% end
% 
% 
% bin = 25;
% 
% [hoff.v , hoff.e] = histcounts(bighistoff , bin);
% [hon.v , hon.e] = histcounts(bighiston , bin);
% 
% % normaliz?l?s
% for i = 1 : length(hoff)
%     
% hoff(i).v = hoff(i).v / sum([hoff(i).v]);
% hon(i).v = hon(i).v / sum([hon(i).v]);
% 
% end
% 
% 
% x = movmean(hon.e',2);
% x = x(2:end);
% y = hon.v' ; % kell a binnel sk?l?z?s


if makepic == 1
figure
plot(x,y)
hold on;
ax = gca;
line([0 0], ax.YLim,'Color',[1 0 0])
ylabel('Number of Spikes / Sum of Spikes');
xlabel('Time relative to onset [s]');
title(strcat('ON ( ' , name , ' )' ))
hold off;

% cd('D:\MEGA\Melo\png')
% 
% saveas(gcf,strcat('on_',name ,'.eps') , 'epsc' )

x = movmean(hoff.e',2);
x = x(2:end);
y = hoff.v' ; % kell a binnel sk?l?z?s

figure

plot(x,y);
hold on
ax = gca;
line([0 0], ax.YLim,'Color',[1 0 0])
ax.XLim(1) = - halfinterval;
title(strcat('OFF ( ' , name , ' )' ))
ylabel('Number of Spikes / Sum of Spikes');
xlabel('Time relative to offset [s]');
hold off

% saveas(gcf,strcat('off_',name ,'.eps') , 'epsc' )

end


end
