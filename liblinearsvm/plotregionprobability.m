## -*- texinfo -*-
## @deftypefn {Function File} {} plotregionprobability ( @var{AH}, @var{REGIONX}, @var{REGIONY}, @var{REGION_PROB})
## Plot prediction probability of a region according to prediction results.
##
## @var{AH} is a axis handle, where to plot.
##
## @var{REGIONX}, @var{REGIONY}, and @var{REGION_PROB} are x, y points, and probabilities of the region. They are return values of classifyregion( ...) function.

function plotregionprobability( AH, REGIONX, REGIONY, REGION_PROB)
    assert( nargin == 4, 'There must be 4 arguments.');
    assert( ndims( REGION_PROB) == 2);

    oldHold = ishold( AH);
    hold( AH, 'on');

    imagesc( AH, REGIONX, REGIONY, REGION_PROB, [0 1]);


    assert( ishold( AH));
    if !oldHold
        hold( AH, 'off');
    end 
end
