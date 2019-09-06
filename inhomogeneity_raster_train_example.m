%__________________________________________________________________________
% Description:  inhomogeneity_raster_train_example.m is a script designed
%               for creating examplary raster trains of inhomogeneily
%               firing neurons in our 2019 exoeriments. These cells are
%               able to both increase and decrease their firing rate after
%               a seizure.
%               
%__________________________________________________________________________ 
% Author:       Tibor Guba
%__________________________________________________________________________
% Disclaimer:   This code is freely usable for non-profit scientific 
%               purposes.
%               I do not warrant that the code is bug free. 
%               Use it at your own risk!
%__________________________________________________________________________

clear all
close all
set( 0 , 'DefaultFigureWindowStyle' , 'docked' )

folder = 'D:\MEGA\Melo\matfiles\asd';
cd( folder )

goodfile1 = '18n27002_1522_b.mat'; % regular spiker
goodfile2 = '18n27003_1576.mat'; % fast spiker

data1 = load( goodfile1 );
data2 = load( goodfile2 );

changer1 = [0.118684624032363,0.798583944666279,3.45688627435652,1.67948739379261,1.01578448231652,0.885453112412131,0.859174098381371,0.398077555545194,2.35204738515066,0.985973270269919,1.43181739787840,2.80862783595118,1.65484340525713,1.84119759633953,2.05717895110120]';
changer2 = [0,1.01458909176328,1.12456246292452,0.963248036501218,0.534417394990863,0.875602017093670,0.901058884642046,1.01736466310927,1.85720201639377,1.05766554790388,1.43331699024381]';

contrasty1 = [ 1 3 ]; % events that drastically differ in change of rate
contrasty2 = [ 5 9 ];

%__________________________________________________________________________

t = data1.spikes.times;
% on = data1.onset.times;
off = data1.offset.times;

center = off( contrasty1(1) );
[ ~ , closestIndex] = min( abs( t - center ) );
x = t( closestIndex - 50 : closestIndex + 49 );

% y = ones( length(x) , 1 );
figure

subplot( 2 , 1 , 1 );   
rasterplot(x , 1 , max(x) + 1 )
hold on
plot( center * [ 1 1 ] , [ -1 2 ] )
ylabel( 'Decreased rate' )

%__________________________________________________________________________

center = off( contrasty1(2) );
[ ~ , closestIndex] = min( abs( t - center ) );
x = t( closestIndex - 50 : closestIndex + 49 );

subplot( 2 , 1 , 2 );   
rasterplot(x , 1 , max(x) + 1 )
hold on
plot( center * [ 1 1 ] , [ -1 2 ] )

ylabel( 'Increased rate' )
xlabel( 'Time [s]' )

%__________________________________________________________________________

t = data2.spikes.times;
% on = data2.onset.times;
off = data2.offset.times;

center = off( contrasty2(1) );
[ ~ , closestIndex] = min( abs( t - center ) );
x = t( closestIndex - 50 : closestIndex + 49 );

% y = ones( length(x) , 1 );
figure

subplot( 2 , 1 , 1 );   
rasterplot(x , 1 , max(x) + 1 )
hold on
plot( center * [ 1 1 ] , [ -1 2 ] )
ylabel( 'Decreased rate' )

%__________________________________________________________________________

center = off( contrasty2(2) );
[ ~ , closestIndex] = min( abs( t - center ) );
x = t( closestIndex - 50 : closestIndex + 49 );

subplot( 2 , 1 , 2 );   
rasterplot(x , 1 , max(x) + 1 )
hold on
plot( center * [ 1 1 ] , [ -1 2 ] )

ylabel( 'Increased rate' )
xlabel( 'Time [s]' )
hold off



