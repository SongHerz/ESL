## -*- texinfo -*-
## @deftypefn {Function File} {} intersect()
## Test intersection of half spaces.
## The convex set is defined as:
## St = {x|-1 <= ( cost, ..., cosmt)'x <= 1}
## S = intersect( St, |t| <= pi/3)
## This function plots graphic for m = 2
## For details, see Example 2.8 from section 2.3.1
## @end deftypefn

function intersecths()
    x1 = [ -2 2];
    x2 = [];

    t = linspace( -pi/3, pi/3, 40);
    for eachT = t
        [ neg_x2, pos_x2] = getx2( eachT, x1);
        x2 = vertcat( x2, neg_x2, pos_x2);
    end
    plot( x1, x2);
    axis([ -2, 2, -2, 2], 'square');
end


% for -1 <= (cost * x1 + cos2t * x2) <= 1
% for given t and x1, calculate x2 for boundaries -1 and 1.
% NEGBOUND is calculated on boundary -1
% POSBOUND is calculated on boundary  1
% The dimension of NEGBOUND and POSBOUND are the same as x1.
function [ NEGBOUND, POSBOUND] = getx2( t, x1)
   NEGBOUND = ( -1 .* ones( size( x1)) - cos( t) .* x1) ./ cos( 2 .* t);
   POSBOUND = ( +1 .* ones( size( x1)) - cos( t) .* x1) ./ cos( 2 .* t);
end

