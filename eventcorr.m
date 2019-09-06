%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:  Function to calculate the autocorrelograms of the neural
%               spiketrain with a time window of -10 seconds before and 3
%               seconds after the seizure onset.
% 
% 
% Author:       Francois David , Tibor Guba
%
% Disclaimer:   This code is freely usable for non-profit scientific purposes.
%               I do not warrant that the code is bug free. Use it at your own risk!
%
% Input:        name - String of the filename to be analyzed. (Has to be in
%               the working folder.)
% 
% Hardcoded
% Input:        makepic - 1 if you want to create a figure, 0 if not.
% 
%
% Output:       X - timevector of the autocorrelogram X = [ -10 : 3 ]'
%               Y - average of all the correlograms
%               U - U = [ -10 : 3 ]'
%               V - autocorrelation coefficient
%               xc - all the former data and more in a structured array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [ X , Y , U , V , xc ] = eventcorr(name)

% close all
% clear
% name = '18n28005_1870b.mat';

load( name )

set(0,'DefaultFigureWindowStyle','docked')
makepic = 1;



Ton = onset.times;
Toff = offset.times;
spiketime = spikes.times; 
% spikesv = spikes.values;

Ni = length( Ton );

if Toff( 1 ) < Ton( 1 )
    Toff = Toff( 2 : end );
end

for i = 1 : Ni - 1

    interictaltime( i , 1 ) =  Ton( i + 1 ) - Toff( i );
    
end

longonset = Ton( interictaltime > 10 );
bin = 100;
resolution = 0.5 / bin ;


for j = 1 : length( longonset )
    
    for i = -10 : 3
        
        xc( j ).trigger( i + 11 ).shift = xcorr( ...
                histc( ...
                spiketime( ...
                find( ...
                spiketime > longonset(j) + i ...
                & spiketime < longonset(j) + i + 1 )...
                )...
                - ( longonset(j) + i ) , ...
                [ 0 : resolution : 1  ] ) ...
                , bin  );
               
        xc( j ).trigger( i + 11 ).t = [ i : resolution : i + 1 - resolution ]'; 
        xc( j ).trigger( i + 11 ).shift = smooth ( xc( j ).trigger( i + 11 ).shift( 2 : end ) , 10 );
    end
end





for j = 1 : length( longonset )
    
    for i = -10 : 3
        


        z = xc( j ).trigger( i + 11 ).shift(floor( 0.05 * end ) : floor( 0.95 * end ) ); % sz?lein aliasolhat;
        
        [ M , MI ] = findpeaks( z  , 'MinPeakProminence' , 0.1 * max( z ) );
        [ MAX , mi ] = max( M );
        
        try
        xc( j ).trigger( i + 11 ).sidelobe =  M( mi - 2 );        
        catch
        continue
        end
        

        xc( j ).trigger( i + 11 ).avg =  mean( xc( j ).trigger( i + 11 ).shift );
%         xc( j ).trigger( i + 11 ).rythmCT = xc( j ).trigger( i + 11 ).sidelobe - ...
%                                             xc( j ).trigger( i + 11 ).avg;
        xc( j ).trigger( i + 11 ).rythmCT = MAX - xc( j ).trigger( i + 11 ).sidelobe;
    end
end


    
for j = 1 : length( xc )

             for i = length( xc(j).trigger ) : -1 : 1
               
                if isempty(xc(j).trigger(i).sidelobe);
                xc(j).trigger(i).shift = NaN( length( xc(j).trigger(i).shift ) , 1 );
                xc(j).trigger(i).rythmCT = NaN;
                end
             end
end
    
for j = 1 : length( longonset )
    
Y = [] ; V = [];

             for i = 1 : length( xc(j).trigger )
%                 disp([ j i ] )
                Y = [ Y ; xc( j ).trigger( i ).shift ]; 
%                 V = [ V ; xc( j ).trigger( i ).rythmCT ];
                V = [ V ; xc( j ).trigger( i ).rythmCT ];
                
             end



tempy( : , j ) = Y ;
tempv( : , j ) = V ;



end

Y = nanmean( tempy , 2 );
V = nanmean( tempv , 2 );

X = [] ;
U = [ -10 : 3 ]' ;

for i = -10 : 3
                X = [ X ; xc( 1 ).trigger( i + 11 ).t ];   
end


if makepic == 1 
    picfolder = 'D:\MEGA\Melo\png\eventkorr2\';
    cd( picfolder )
    figure

    subplot( 2 , 1 , 1 );   
    plot( X , Y )
    xlim( [ -10 , 4 ] )
    ax = gca;
    ax.XTick = [ -10 : 1 : 4 ]';   
    grid 
    title( strcat ( 'Event correllogram with 1s blocks (' , name , ')' ) )
    
    subplot( 2 , 1 , 2 );   
    bar( U + 0.5 , V )
    xlim( [ -10 , 4 ] )
    ax = gca;
    ax.XTick = [ -10 : 1 : 4 ]';   
    grid 
%     title( 'Second Sidelobe / Average of Block' )
    title( 'Peak-to-peak amplitude' )
    xlabel( 'Time Relative to Seizure Onset [s]' )
    
    saveas(gcf , strcat( 'eventkorr_' , name , '.eps' )  , 'epsc' );
    
end
end