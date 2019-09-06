%__________________________________________________________________________
% Description:  This function's purpose is to draw imageplots with the x
%               axis beeing the time relative to seizure onset, y axis
%               beeing the bins of the seconds in the x axis resolved into
%               milliseconds. The color coded z is autocorrelograms
%               corresponding value. 
% .........................................................................
%               Excerpt from Hughes et al. (2004):
%               Normalized discrete cross-correlograms of two spike trains
%               were constructed by computing the intervals between the 
%               times of all spikes in one train and all spikes in the 
%               other. Intervals were then binned at 5 or 10 ms. 
%               The resulting histogram was then normalized by dividing all 
%               entries by the peak value. Each time slice of a discrete
%               sliding window cross-correlogram represents a normalized
%               discrete cross-correlogram corresponding to a given window 
%               centered around that time. Consecutively shifting this 
%               window by a uniform time interval generates a matrix of
%               values which were color coded to produce the final image.
%__________________________________________________________________________
% Author:       Tibor Guba
%__________________________________________________________________________
% Disclaimer:   This code is freely usable for non-profit scientific 
%               purposes.
%               I do not warrant that the code is bug free. 
%               Use it at your own risk!
%__________________________________________________________________________
% Input:        spk - vector of spike timestamps
%               savepic - if set to a string, the created figure will be 
%               saved with the filename 'savepic'.
%__________________________________________________________________________
%
% Output:       N/A
%__________________________________________________________________________



% function SlidingWindowAC( spk , rangex , rangey , savepic )
function [ S , Z ] = SlidingWindowAC( filename , rangex , rangey , savepic )

%%%%%%%%%%%%%%%%%%uncomment to debug
% cd('D:\MEGA\Melo\matfiles\CSILLA')
% clear all
% filename = '18n29002_1856.mat';
% rangex = 1;
% rangey = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load(filename)
Ton = onset.times;
Toff = offset.times;
spk = spikes.times;


Ni = length( Ton );

if Toff( 1 ) < Ton( 1 )
    Toff = Toff( 2 : end );
end

for i = 1 : Ni - 1

    interictaltime( i , 1 ) =  Ton( i + 1 ) - Toff( i );
    
end

Tx = [ -10.00 : rangex/50 : 3.999]';
Ty = [ -11 : rangey/50 : 4.999 ]';


longonset = Ton( interictaltime > 10 );
bin = 500;

Ha = zeros( 100 , length(Tx) );
Hb = zeros( 100 , length(Ty) );


for j = 1 : length( longonset )
    
    for i = 1 : length(Tx)
        lower = longonset(j) + Tx(i) - rangex;
        upper = longonset(j) + Tx(i) + rangex ;
        vector = spk(  find(  spk > lower & spk < upper ) ) - ( longonset(j) + Tx(i) );
        temp = histc(  vector ,  [ -rangex : rangex/50 : rangex  ] ) ;
        Ha( : , i ) = smooth ( temp( 2 : end ) , 10 );
    end %oszlop
    
    for i = 1 : length(Ty)
        lower = longonset(j) + Ty(i) - rangey;
        upper = longonset(j) + Ty(i) + rangey ;
        vector = spk(  find(  spk > lower & spk < upper ) ) - ( longonset(j) + Ty(i) );
        temp = histc(  vector ,  [ -rangey : rangex/50 : rangey  ] ) ;
        Hb( : , i ) = smooth ( temp( 2 : end ) , 10 );
    end %oszlop  
    
  
end



TEMP = struct('ac', repmat( { zeros( 199 , 1 ) }, 100, 1));
S = struct('AC' , repmat( { TEMP }, 700, 1));
Z = zeros( length( S(1).AC ) , length( S ) );


for  i = 1 : length(Tx)
    for j = -50 : 1 : 49
%         disp( [ i j ])
        % a v?zszintes tengely l?nyeg?ben egybev?g Ha oszlopaival
%         S( i ).AC( j + 51 ).ac = xcorr( Ha( : , i ) , Hb( : , 50 + i + j ) );
%         S( i ).AC( j + 51 ).acf = abs( fft( S( i ).AC( j + 51 ).ac ) ); 
%         S( i ).AC( j + 51 ).prob = S( i ).AC( j + 51 ).acf / sum( S( i ).AC( j + 51 ).acf );


        [ S( i ).AC( j + 51 ).ac , S( i ).AC( j + 51 ).f ] = mscohere( Ha( : , i ) , Hb( : , 50 + i + j  ) , [] , [] , [] , 1000 );
        try
        [ S( i ).AC( j + 51 ).pks , S( i ).AC( j + 51 ).locs , S( i ).AC( j + 51 ).width , S( i ).AC( j + 51 ).prominence] = findpeaks( S( i ).AC( j + 51 ).ac );
        S( i ).AC( j + 51 ).MatchingFreqs =  S( i ).AC( j + 51 ).f( S( i ).AC( j + 51 ).locs );
        catch
        end

    end
end

% for i = 1:100
%     figure
% plot( S(621).AC(i).ac )
% end



for  i = 1 : length(S)
    for j =  1 : length( S(i).AC )

%         Z( j , i ) = trapz( abs( fft( S( i ).AC( j ).ac.^2  ) ) );
%         Z( j , i ) = sum ( - S( i ).AC( j ).prob .* log2( S( i ).AC( j ).prob ) );
%         Z( j , i ) = bandpower( S( i ).AC( j ).ac.^2  ) ;
        Z( j , i ) =  sum( S( i ).AC( j ).width .* S( i ).AC( j ).prominence ) ;
%         Z( j , i ) =  sum( S( i ).AC( j ).prominence ./ S( i ).AC( j ).width  ) ;
    end
end



    
set(0,'DefaultFigureWindowStyle','docked')
Y = [ -1: 0.02 : 1 ]';
X = Tx;
Z = Z ./ max( max( Z ) );



    
    if ischar(savepic)
        figure
        imagesc( X , Y , Z )
        colormap jet
        h = colorbar;
        set(h,'Ylim',[0 1])
        ylabel(h, 'Coherence')
        xlabel( 'Time relative to seizure onset [s]' )
        ylabel( 'Shift of cross-correlation window [s]' )
        grid on
        ax = gca;
        ax.GridColor = [0.9 0.9 0.9] ;
        title(  filename  )
        cd( 'D:\MEGA\Melo\png\' )
        saveas( gcf , strcat( 'map_' , savepic , '.eps' ) , 'epsc' );
    end
    
end