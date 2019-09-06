%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:  A function that maps out the spike firing rates to ictal
%               and interictal sets.
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
% Output:       result - a struc array containing the rate changes during
%               on and offset, as well as their average and standard
%               deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = firing_change( name )

load( name )

makepic = 1;


resolution = offset.resolution; 
Ton = onset.times;
Toff = offset.times;
spiketime = spikes.times; 
spikesv = spikes.values;

if length(Ton) < length(Toff)
    Toff = Toff(2:end);
end


% N_spike = length(spikesv);



N_ictal = length(Ton);

Fire_ictal = zeros(N_ictal,1);
Fire_interictal = zeros(N_ictal-1,1);
I_rate = zeros(N_ictal,1);
II_rate = zeros(N_ictal-1,1);

for i = 1: N_ictal
    on = Ton(i);
    off = Toff(i);
    ictaltime = off - on;
    index=spiketime > on & spiketime < off; 
    
    Fire_ictal(i) = sum(index(:) == 1);
    I_rate(i) = Fire_ictal(i) / ictaltime;
end


for i = 1: N_ictal-1
    on = Ton(i+1);
    off = Toff(i);
    
    interictaltime = on - off;
    
    index= spiketime < on & spiketime > off; 
    
    Fire_interictal(i) = sum(index(:) == 1);
    II_rate(i) = Fire_interictal(i) / interictaltime;

    rate_change(i) = II_rate(i) / I_rate(i); 
    
end

k = find( ~I_rate );
% [ k , ~ ] = ind2sub(size(rate_change), k);

rate_change(k) = []; 



% result.Ir = I_rate;
% result.IIr = II_rate;


result.avg = mean( rate_change) ;
result.std = std( rate_change );
result.ratios = rate_change;

x = [ 0 , 1 ];



if makepic == 1
        figure    
            for i = 1 : length(rate_change)


                hold on

                semilogy( x , [ 1 rate_change(i) ] , 'Color' , [ 0.8 0.8 0.8 ] )


            end

            semilogy( x , [ 1 mean(rate_change) ] , 'r' )
            hold off

%             cd('D:\MEGA\Melo\png')
% 
%             saveas( gcf , strcat('errbar_ratio_', name, '.png') )
%             saveas( gcf , strcat('errbar_ratio_', name, '.eps') , 'epsc' )
end

end