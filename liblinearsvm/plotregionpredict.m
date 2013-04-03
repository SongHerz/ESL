## -*- texinfo -*-
## @deftypefn {Function File} {} plotregionpredict( @var{AH}, @var{REGIONX}, @var{RETIONY}, @var{REGIONPREDICT})
## Plot prediction of a region according to predict results. ( Support multiple labels)
##
## @var{AH} is a axis handle, where to plot.
##
## @var{REGIONX}, @var{REGIONY}, and @var{REGIONPREDICT} are x, y points, and prediction on the points. They are return values of classifyregion( ...) function.
function plotregionpredict( AH, REGIONX, REGIONY, REGIONPREDICT)
    assert( nargin == 4, "There must be 4 arguments");
    assert( ndims( REGIONPREDICT) == 2);
    
    oldHold = ishold( AH);
    hold( AH, 'on');
    numLabels = length( unique( REGIONPREDICT));

    numLines = numLabels - 1;
    assert( numLines >= 0);
    if numLines == 0
        numLines = 1;
    end
    contourf( AH, REGIONX, REGIONY, REGIONPREDICT, numLines );
    
    % set color map for the contour region
    maxLabel = max( max( REGIONPREDICT));
    minLabel = min( min( REGIONPREDICT));

    % When there is only one label, force minLabel to be the negation 
    % of the maxLabel, and the color of contourf() looks better.
    if minLabel == maxLabel
        % Make sure maxLabel is positive
        maxLabel = abs( maxLabel);
        minLabel = -maxLabel;
    end
    midLabel = ( maxLabel + minLabel) / 2;
    distLabel = maxLabel - minLabel;
    caxis( AH, [ midLabel - distLabel, midLabel + distLabel]);

    assert( ishold( AH));
    if !oldHold
        hold( AH, 'off');
    end
end
