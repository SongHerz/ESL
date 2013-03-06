## -*- texinfo -*-
## @deftypefn {Function File} {@var{P} =} npdf ( @var{X}, @var{MU}, @var{SIGMA})
## Calculate probability density, with given column mean vector @var{MU}, and covariance matrix @var{SIGMA}.
## @var{X} is a matrix, each column of whom is a vector.
## @var{P} is a row vector, whose length is the same as columns of @var{X}.
## @end deftypefn

function P = npdf( X, MU, SIGMA)

    nargs = nargin;
    if nargs != 3
        error( "npdf: require 3 arguments");
    end

    % Check MU should be a column vector
    [ rowMU colMU] = size( MU);
    if colMU != 1
        error( "npdf: MU should be a column vector");
    end
    % Get dimension of variables from rowMU
    dim = rowMU;

    % Check SIGMA, it should be a square matrix,
    % and its rows or columns should be the same as rows of MU
    [ rowSIGMA colSIGMA] = size( SIGMA);
    if rowSIGMA != colSIGMA
        error( "npdf: SIGMA should be a square matrix");
    end
    if rowSIGMA != dim
        error( "npdf: Dimension of SIGMA does not match that of MU");
    end
    % Check X, its row count should match MU and SIGMA.
    [ rowX colX] = size( X);
    if rowX != dim
        error( "npdf: Dimension of X does not match those of MU and SIGMA");
    end

    % calculate SIGMA^(-1)
    invSIGMA = inv( SIGMA);
    k = 1/( (2*pi)^(dim/2) * sqrt( det( SIGMA)));

    % preallocate spaces for P
    P = zeros( 1, colX);
    
    % calculate each P for each X column vector
    for colIdx = 1 : colX
        colVec = X( :, colIdx);
        P( colIdx) = k * exp( -1/2 * ( colVec - MU)' * invSIGMA * ( colVec - MU));
    end
end

%!test
%! s(1).M = 0;
%! s(1).V = 0.2;
%! 
%! s(2).M = 0;
%! s(2).V = 1.0;
%! 
%! s(3).M = 0;
%! s(3).V = 5.0;
%! 
%! s(4).M = -2;
%! s(4).V = 0.5;
%! 
%! for eachS = s
%!     M = eachS.M;
%!     V = eachS.V;
%!     standard = sqrt( V);
%!     fh = @(x) npdf( x, M, V);
%!     p = quad( fh, -standard, standard);
%!     assert( p - 0.68 <= 0.05);
%!     p = quad( fh, -2*standard, 2*standard);
%!     assert( p - 0.95 <= 0.05);
%!     p = quad( fh, -3*standard, 3*standard);
%!     assert( p - 0.997 <= 0.005);
%! end
