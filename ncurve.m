## -*- texinfo -*-
## @deftypefn {Function File} {@var{Y} =} ncurve ( @var{X}, @var{M}, @var{V})
## Generate @var{Y} values for normal distribution with mean @var{M}, variance @var{V},
## and @var{X} values.
## The dimension of @var{Y} is the same as @var{X}
## @end deftypefn

function Y = ncurve( X, M, V)

    nargs = nargin;
    if nargs != 3
        error("ncurve: require 3 arguments");
    end
    
    if !( isreal( M) && isscalar( M))
        error("ncurve: mean should be a real number");
    end

    if !( isreal( V) && isscalar( V) && V > 0)
        error("ncurve: variance should be a positive real number");
    end

    standard = sqrt( V);
    Y = exp( -( X .- M).^2 ./V ./2) ./ standard ./ sqrt( 2*pi);
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
%!     fh = @(x) ncurve( x, M, V);
%!     p = quad( fh, -standard, standard);
%!     assert( p - 0.68 <= 0.05);
%!     p = quad( fh, -2*standard, 2*standard);
%!     assert( p - 0.95 <= 0.05);
%!     p = quad( fh, -3*standard, 3*standard);
%!     assert( p - 0.997 <= 0.005);
%! end
