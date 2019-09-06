function Z = SlidingWindowAClite( S , savepic )



for  i = 1 : length(S)
    for j =  1 : length( S(i).AC )

%         Z( j , i ) = trapz( abs( fft( S( i ).AC( j ).ac.^2  ) ) );
%         Z( j , i ) = sum ( - S( i ).AC( j ).prob .* log2( S( i ).AC( j ).prob ) );
%         Z( j , i ) = bandpower( S( i ).AC( j ).ac.^2  ) ;
        Z( j , i ) =  sum( S( i ).AC( j ).prominence ); %./ S( i ).AC( j ).width ) ;

    end
end



    
set(0,'DefaultFigureWindowStyle','docked')
Y = [ -1: 0.02 : 1 ]';
X = [ -10.00 : 1/50 : 3.999]';
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
        title(  savepic  )
        cd( 'D:\MEGA\Melo\png\' )
        saveas( gcf , strcat( 'maplitesimple_' , savepic , '.eps' ) , 'epsc' );
    end
    
end