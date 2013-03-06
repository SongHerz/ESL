## -*- texinfo -*-
## @deftypefn {Function File} {@var{P} =} npdf2( @var{X}, @var{Y}, @var{MU}, @var{SIGMA})
## Calculate probability density for 2 variables, with given column mean vector @var{MU}, and covariance matrix @var{SIGMA}.
## @var{X} and @var{Y} are matrices with the same size.
## @var{MU} is a column mean vector with means of @var{X} and @var{Y}.
## @var{SIGMA} is covariance matrix, with 2 rows and 2 columns.
## @end deftypefn

function P = npdf2( X, Y, MU, SIGMA)
    
    nargs = nargin;
    if nargs != 4
        error( "npdf2: require 4 arguments");
    end

    % Check X and Y should have the same size
    if size( X) != size( Y)
        error( "npdf2: size of X and Y should be the same");
    end

    % Check MU should be a column vector with 2 elements
    if size( MU) != [ 2 1]
        error( "npdf2: MU should be a column vector with 2 elements");
    end

    % Check SIGMA size
    if size( SIGMA) != [ 2 2]
        error( "npdf2: SIGMA should be a 2x2 matrix");
    end

    % Calculate P
    P = zeros( size( X));

    for rowIdx = 1 : size( X, 1)
        rowX = X( rowIdx, :);
        rowY = Y( rowIdx, :);
        XY = vertcat( rowX, rowY);
        P( rowIdx, :) = npdf( XY, MU, SIGMA);
    end
end


%!demo
%! MU = [0 0]';
%! SIGMA = [1 0; 0 1];
%! X = linspace( MU(1) - 2, MU(1) + 2, 40);
%! Y = linspace( MU(2) - 2, MU(2) + 2, 40);
%! [XX YY] = meshgrid( X, Y);
%! P = npdf2( XX, YY, MU, SIGMA);
%! figure;
%! surfc( XX, YY, P);
%! xlabel( 'X'), ylabel( 'Y'), zlabel( 'P');
%! title( { sprintf('mean(X) = %f', MU(1)), ...
%!        sprintf('mean(Y) = %f', MU(2)), ...
%!        sprintf('SIGMA = %s', mat2str( SIGMA)) });


%!demo
%! MU = [1 2]';
%! SIGMA = [1 0; 0 1];
%! X = linspace( MU(1) - 2, MU(1) + 2, 40);
%! Y = linspace( MU(2) - 2, MU(2) + 2, 40);
%! [XX YY] = meshgrid( X, Y);
%! P = npdf2( XX, YY, MU, SIGMA);
%! figure;
%! surfc( XX, YY, P);
%! xlabel( 'X'), ylabel( 'Y'), zlabel( 'P');
%! title( { sprintf('mean(X) = %f', MU(1)), ...
%!        sprintf('mean(Y) = %f', MU(2)), ...
%!        sprintf('SIGMA = %s', mat2str( SIGMA)) });

%!demo
%! MU = [0 0]';
%! SIGMA = [1 0.9; 0.9 1];
%! X = linspace( MU(1) - 2, MU(1) + 2, 40);
%! Y = linspace( MU(2) - 2, MU(2) + 2, 40);
%! [XX YY] = meshgrid( X, Y);
%! P = npdf2( XX, YY, MU, SIGMA);
%! figure;
%! surfc( XX, YY, P);
%! xlabel( 'X'), ylabel( 'Y'), zlabel( 'P');
%! title( { sprintf('mean(X) = %f', MU(1)), ...
%!        sprintf('mean(Y) = %f', MU(2)), ...
%!        sprintf('SIGMA = %s', mat2str( SIGMA)) });

%!demo
%! MU = [0 0]';
%! SIGMA = [1 -0.9; -0.9 1];
%! X = linspace( MU(1) - 2, MU(1) + 2, 40);
%! Y = linspace( MU(2) - 2, MU(2) + 2, 40);
%! [XX YY] = meshgrid( X, Y);
%! P = npdf2( XX, YY, MU, SIGMA);
%! figure;
%! surfc( XX, YY, P);
%! xlabel( 'X'), ylabel( 'Y'), zlabel( 'P');
%! title( { sprintf('mean(X) = %f', MU(1)), ...
%!        sprintf('mean(Y) = %f', MU(2)), ...
%!        sprintf('SIGMA = %s', mat2str( SIGMA)) });
