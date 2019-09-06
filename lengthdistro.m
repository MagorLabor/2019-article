%__________________________________________________________________________
% Description:  Wrapper function for alignAndPlotTimes. Distant fork of
%               S?ndor Bord?'s corresponding script. 
%               Reads the inputfile and and passes its data with preset
%               parameters to the alignAndPlotTimes subroutine.
% __________________________________________________________________________
% Author:       Tibor Guba
%__________________________________________________________________________
% Disclaimer:   This code is freely usable for non-profit scientific
%               purposes.
%               I do not warrant that the code is bug free. 
%               Use it at your own risk!
%__________________________________________________________________________
% Input:        name - String of the file to be analyzed. (Has to be in
%               the working folder.)
%__________________________________________________________________________ 
%
% Hardcoded
% Input:        makepic - 1 if you want to create a figure, 0 if not.
%__________________________________________________________________________ 
% 
% Output:       iiilength - a struc array containing the ictal and
%               interictal times. Also the average seizure duration.
%__________________________________________________________________________

function iiilength = lengthdistro( name )


%________________________________uncomment to debug________________________
% clear all
% close all
% name = '19215001 imm kesz.mat';
%__________________________________________________________________________


load(name)
Ton = onset.times;
Toff = offset.times;




if length(Ton) < length(Toff)
    Toff = Toff(2:end);
end

N_ictal = length(Ton);

% Fire_ictal = zeros(N_ictal,1);
% Fire_interictal = zeros(N_ictal-1,1);
% I_rate = zeros(N_ictal,1);
% II_rate = zeros(N_ictal-1,1);

for i = 1: N_ictal
    
    on = Ton(i);
    off = Toff(i);
    ictaltime(i) = off - on;

end


for i = 1: N_ictal-1
    
    on = Ton(i+1);
    off = Toff(i);
    
    interictaltime(i) = on-off;
    
end

iiilength.i = ictaltime( ictaltime < 100 );
iiilength.ii = interictaltime( interictaltime < 100 );
iiilength.avgseizure = mean(ictaltime);

% a = round( max( ictaltime ) , -1  );
% b = round( max( interictaltime ) , -1  );
% edge =  0 : 5 : 100;
% % edgeii = 0 : 5 : b;
% 
% % if makepic == 1
% 
%     figure
%     hi = histogram( [ iiilength.i ]  ,  edge , 'DisplayName' , 'Ikt?lis' );
%     title( strcat(  name ) )
%     xlabel ( 'Id? [s]' )
%     ylabel ( 'Darabsz?m' )
%     hold on
%     hii = histogram( [ iiilength.ii ]   ,  edge , 'DisplayName' , 'Interikt?lis' );
%     hold off
%     legend( 'show' , 'Location','northeast' )
%     
%     saveas( gcf , strcat( 'IIdistro_' , name , '.eps' ) , 'epsc' )
%     
%     hi.Normalization = 'probability';
%     hii.Normalization = 'probability';
%     
%     saveas( gcf , strcat( 'IIdistro_probability' , name , '.eps' ) , 'epsc' ) 
%     
%     hi.Normalization = 'pdf';
%     hii.Normalization = 'pdf';
%     
%     saveas( gcf , strcat( 'IIdistro_pdf' , name , '.eps' ) , 'epsc' )
%     
%     
%     
% % end

end