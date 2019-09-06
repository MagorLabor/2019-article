%__________________________________________________________________________
% Description:  Master script for batch analysis of SWD and SPIKETRAINS.
%               Implements various subroutines depending on your choosing.
%               (Uncomment / comment the subroutines in the first for loop
%               according to your needs.)
%               Draws plots according to the values of the bools in the
%               beginning of the code (variale names that end with
%               "_abra"). 
% 
% Author:       Tibor Guba
%
% Disclaimer:   This code is freely usable for non-profit 
%               scientific purposes.
%               I do not warrant that the code is bug free. 
%               Use it at your own risk!
%
% Input:        folder - String of the folder to be analyzed
% 
%__________________________________________________________________________


% clear all
% close all

folder = 'D:\MEGA\Melo\matfiles\asd\'; %needs '\' at the end

histogram_abra = 0; 
perievent_abra = 0;  
errbar_abra = 1; 
eventkorrpic_abra = 0;
iiihossz_abra = 0 ;

set(0,'DefaultFigureWindowStyle','docked')

cd(folder)

files = dir(strcat('*.mat'));
FL = struct2cell(files);
FL = FL(1,:)';

N = length(FL);




%         for i = 1 : N
%             
%             disp( strcat( num2str(i), ' / ' , num2str(N) , ' : ' , FL{i} ) )
%             S(i).r = SlidingWindowAC( FL{i} , 1 , 1 , FL{i} );
%             cd(folder)
%                 Z(i).z = SlidingWindowAClite( S(i).r ,  FL{i} );
%             
%         end


% for i = 1 : N
%     
%     disp( strcat( num2str(i), ' / ' , num2str(N) , ' : ' , FL{i} ) )
%       
% %     data = load(FL{i}); % add (i) to retain the previously loaded data
% 
%     
%     
%     cd(folder)
%     res(i).asd = OScoreWrapper( FL{i} , 1 );
%     
%         
% end





%{
O = []; 
C = []; 
ACWP = [];

for j = 1 : N
            
        O = [ O ; [ res(j).asd.OscScore ] ];
        C = [ C ; [ res(j).asd.CnfScore ] ];
        ACWP = [ ACWP ; [ res(j).asd.AutoCorrelogramWithoutPeak ] ];
end

Oa = mean( O , 1 );
Ca = mean( C , 1 );
Os = std( O , 1 );
Cs = std( C , 1 );
Aa = mean( ACWP , 1 );
As = std( ACWP , 1 );



        X = [ -10.000 : 0.001 : 3.999 ]' ;
        
        Y = [];
        U = [ -10 : 1 : 3 ]';
        
  
        fig = figure;
        set(fig,'defaultAxesColorOrder',[ [0 0 0] ; [0 0 0] ])        
        subplot( 2 , 1 , 1 );
        plot( X , Aa )
        xlim( [ -10 , 3 ] )
        ax = gca;
        ax.XTick = [ -10 : 1 : 3 ]';  
%         ax.YLim(1) = 1;
        grid 
        title( strcat ( 'Autocorrellogram with 1s blocks without the central peaks ( average)' ) )
        ylabel( 'Count' )
        
        subplot( 2 , 1 , 2 );  
        plot( U , Oa )
        hold on
        yyaxis right        
        bar( U , Ca , 'FaceAlpha' , 0.2 , 'EdgeAlpha' , 0)
        hold off        
        xlim( [ -10 , 3 ] )
        ax = gca;
        ax.XTick = [ -10 : 1 : 3 ]';   
        grid 
        xlabel( 'Time relative to seizure onset [s]' )
        yyaxis left
        ylabel('Oscillation Score')
        yyaxis right        
        ylabel('Confidence')
        cd( 'D:\MEGA\Melo\png' )
        saveas( gcf , 'oscillation_score_AVERAGE.eps'  , 'epsc' );
        
%}




% [ X , ~ , U , ~ , ~ ] = eventcorr( FL{ 1 } );  



for i = 1 : N
% cd(folder)
% 
%     disp( strcat( num2str(i), ' / ' , num2str(N) , ' : ' , FL{i} ) )
%     [ ~ , Y , ~ , V , ~ ] = eventcorr( FL{ i } );    
% 
%     BIGCORRAVG( : , i ) = Y;
%     BIGINDEXAVG( : , i ) = V;
    



    change(i) = firing_change( FL{i} );  
% 
%     iiilength(i) = lengthdistro(FL{i})  ;
%     
    [ duration( i , 1 ) , ~ , ~ ] = spike_analysis_subroutine( FL{i} );%, hon(i), hoff(i)
    if duration( i , 1 ) > 0.2
        category{ i , 1 } = 'RS';
    else
        category{ i , 1 } = 'FS';
    end
%     
%     asd(i).perievent = SWD_trigger_analysis( FL{i} );


end


% if perievent_abra == 1
%% Perievent hisztogram

% edges = [ -120 : 10 : 100];
% x = movmean (edges, 2);
% x = x(2:end);
% 
% PERI = [];
% for i = 1 : length(asd)
%     PERI = [ PERI ; asd(i).perievent ] ;
% end
% 
% AVGPERI = mean( PERI , 1 );
% 
% 
% 
% for i = 1 : N
%    figure
%    plot ( x ,  asd(i).perievent , 'Color' , [0.8 0.8 0.8])
%    title(FL{i})
% %    hold on
% end


% plot( x , AVGPERI , 'r')
% hold off

% title ('PeriSWD Histogram') % perievent
% xlabel('Time relative to SWD event [ms]')
% ylabel('Spike Count / Total Number of Spikes')




% end





%% FIGURES




if eventkorrpic_abra == 1
    Y = nanmean( BIGCORRAVG , 2 );
    V = nanmean( BIGINDEXAVG , 2 );
%     cd( 'D:\MEGA\Melo\png\eventkorr\' )
    figure

    subplot( 2 , 1 , 1 );   
    plot( X , Y )
    xlim( [ -10 , 4 ] )
    ax = gca;
    ax.XTick = [ -10 : 1 : 4 ]';   
    grid 
    title( strcat ( 'Event correllogram with 1s blocks ( average of all cells)' ) )
    
    subplot( 2 , 1 , 2 );   
    bar( U + 0.5 , V )
    xlim( [ -10 , 4 ] )
    ax = gca;
    ax.XTick = [ -10 : 1 : 4 ]';   
    grid 
%     title( 'Second Sidelobe / Average of Block ' )
    title( 'Average peak-to-peak amplitude' )
    xlabel( 'Time Relative to Seizure Onset [s]' )
    
    cd( 'D:\MEGA\Melo\png\eventkorr2\' )
    saveas(gcf , 'BIGAVGeventkorr.eps'  , 'epsc' );
    
end






if iiihossz_abra == 1
    
        Ihist = [];
        IIhist = [];
    for i = 1 : N

        Ihist = [Ihist ; iiilength(i).i' ]   ; 
        IIhist = [IIhist ; iiilength(i).ii' ];

    end

    cd ( 'D:\MEGA\Melo\png' )
    figure
    histogram( Ihist )
    
    title( 'Ictal Times Distribution' )
    xlabel( 'Time [s]' )
    ylabel( 'Count' )
    
    saveas( gcf , 'all_idistro.eps', 'epsc' )    
    
    figure
    histogram( IIhist )
    

    
    title( 'Interictal Times Distribution' )
    xlabel( 'Time [s]' )
    ylabel( 'Count' )
      
    saveas( gcf , 'all_iidistro.eps', 'epsc' )  
end




    
if errbar_abra == 1
    y = [change.avg];
    figure
%     errorbar( [change.avg] , [change.std] , 'x')
%     xlabel('Cell index')
%     ylabel('Interictal rate / Ictal rate')

x = [ 0 , 1 ];
for i = 1 : length(y)
    hold on
semilogy( x , [ 1 y(i) ] , 'Color' , [ 0.8 0.8 0.8 ] )
end
semilogy( x , [1 mean(y) ] , 'r' )
hold off
cd('D:\MEGA\Melo\png')

saveas( gcf , strcat('errbar_ratio.png') )
saveas( gcf , strcat('francois3.eps') )


figure

for i = 1 : length(change)
    hold on
    x = ones( length( [ change(i).ratios ] ) , 1 );
    y = [change(i).ratios];
    if category{i} == 'FS'
        plot(i*x , y , 'ko' )
    else
        plot(i*x , y , 'rx' )
    end


end

plot( [ 0 : length(change) ] , ones( length( change ) + 1 , 1 ) )

xlabel('Cell index')
ylabel('Interictal rate / Ictal rate')
% ax = gca;
% ax.yTick = [ 0 : length(change) ];


% saveas( gcf , strcat('francois4.png') )
saveas( gcf , strcat('francois4.eps') , 'epsc' )
end





if histogram_abra == 1;

x = movmean(hon(1).e',2);
x = x(2:end);
TEMPON = [];
TEMPOFF = [];
for i = 1:length(hon)
    TEMPON = [TEMPON ; hon(i).v ]   ; 
    TEMPOFF = [TEMPOFF ; hoff(i).v ];
    
    
end

AVGON = mean(TEMPON,1);
AVGOFF = mean(TEMPOFF,1);

% STDON = std(TEMPON,0,1);
% STDOFF = std(TEMPOFF,0,1);

figure
hold on;
x = movmean( hon(1).e , 2 );
for i = 1 : N
    
    plot( x( 2 : end ) , hon(i).v , 'Color' , [ 0.8 0.8 0.8 ] )

end

plot( x( 2 : end ) , AVGON , 'b' , 'LineWidth' , .75 )

ax = gca;
ylabel('Number of Spikes / Sum of Spikes');
xlabel('Time relative to onset [s]');
title(strcat('Average Onset' ))
% plot(x,AVGON-STDON , ':k' )
% plot(x,AVGON+STDON , ':k' )
line([0 0], ax.YLim , 'Color' , [1 0 0] )
hold off;

cd('D:\MEGA\Melo\png')

saveas( gcf , strcat('AVGon.png') )
saveas( gcf , strcat('AVGon.eps') )


figure
hold on;
for i = 1 : N
    
    plot( x(2:end) , hoff(i).v , 'Color' , [ 0.8 0.8 0.8 ])

end

plot(x(2:end) , AVGOFF , 'b' , 'LineWidth' , .75 )

ax = gca;
ylabel('Number of Spikes / Sum of Spikes');
xlabel('Time relative to offset [s]');
title(strcat('Average Offset' ))
% plot(x,AVGOFF-STDON , ':k' )
% plot(x,AVGOFF+STDON , ':k' )
line([0 0], ax.YLim , 'Color' , [1 0 0] )
hold off;

cd('D:\MEGA\Melo\png')

saveas( gcf , strcat('AVGOFF.png') )
saveas( gcf , strcat('AVGOFF.eps') , 'epsc' )


end

