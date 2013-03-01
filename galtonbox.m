## -*- texinfo -*-
## @deftypefn  {Function File} {} galtonbox ( @var{LEVEL}, @var{BALLS}, @var{INTERVAL})
## Plot galton box.
## @var{LEVEL} means how many levels.
## @var{BALLS} means how many balls.
## @var{INTERVAL} means interval between each frame in seconds. If omitted or 0, no animation.

function galtonbox ( varargin)

    nargs = nargin;
    LEVEL = 0;
    BALLS = 0;
    INTERVAL = 0;

    % check LEVEL arg
    if nargs > 0
        LEVEL = varargin{1};
        if !is_positive_scalar_integer( LEVEL)
            error("galtonbox: LEVEL should be a positive integer");
        end
    end

    % check BALLS arg
    if nargs > 1
        BALLS = varargin{2};
        if !is_positive_scalar_integer( BALLS)
            error("galtonbox: BALLS should be a positive integer");
        end
    end

    % check INTERVAL arg
    if nargs > 2
        INTERVAL = varargin{3};
        if !is_positive_scalar_integer( INTERVAL)
            error("galtonbox: INTERVAL should be a positive integer");
        end
    end

    % create a new figure
    figure;
    % create a new axis obj
    axh = gca();
    hold on

    pointInterval = 1;
    plotLevels( axh, LEVEL, pointInterval);
    
end


function tf = is_positive_scalar_integer( val)
    tf = isscalar( val) && isnumeric( val) && fix( val) == val && val > 0;
end


% return start point of a ball
function ret = plotLevels( AXH, LEVELS, POINT_INTERVAL)
    y0 = POINT_INTERVAL :  2*POINT_INTERVAL : LEVELS * POINT_INTERVAL;
    y1 = 2*POINT_INTERVAL : 2*POINT_INTERVAL : LEVELS * POINT_INTERVAL;


    x0 = -POINT_INTERVAL * max( length( y0), length( y1)) : POINT_INTERVAL : POINT_INTERVAL * length( y0);
    x1 = -POINT_INTERVAL * max( length( y0), length( y1)) : POINT_INTERVAL : POINT_INTERVAL * length( y1);

    halfPointInterval = POINT_INTERVAL / 2;
    if mod( LEVELS, 2) != 0
        x0 -= halfPointInterval;
    else
        x1 -= halfPointInterval;
    end

    xm0 = repmat( x0, length( y0), 1);
    xm1 = repmat( x1, length( y1), 1);

    plot( AXH, xm0, y0, 'ob', 'MarkerFaceColor', 'b');
    plot( AXH, xm1, y1, 'or', 'MarkerFaceColor', 'r');

    ret = [ 0 LEVELS*POINT_INTERVAL]; 
end
        
