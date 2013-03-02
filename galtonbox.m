## -*- texinfo -*-
## @deftypefn  {Function File} {} galtonbox ( @var{LEVEL}, @var{BALLS}, @var{INTERVAL})
## Plot galton box.
## @var{LEVEL} means how many levels. ( Default: 1)
## @var{BALLS} means how many balls.
## @var{INTERVAL} means interval between each frame in seconds. If omitted or 0, no animation.

function galtonbox ( varargin)

    nargs = nargin;
    LEVEL = 1;
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
    [ ballStartPos, ballLastPos] = plotLevels( axh, LEVEL, pointInterval);
    disp("ballStartPos"), disp( ballStartPos);
    disp("ballLastPos"), disp( ballLastPos);
    
end


function tf = is_positive_scalar_integer( val)
    tf = isscalar( val) && isnumeric( val) && fix( val) == val && val > 0;
end


% return start point of a ball, and all possible X positions of the ball
% SP: start point of the ball
% FXP: final possible x positions of the ball
function [ SP, FXP] = plotLevels( AXH, LEVELS, POINT_INTERVAL)
    for level = LEVELS : -1 : 1;
        unitXPos = unitXPositions( level, LEVELS); 
        xPos = unitXPos .* POINT_INTERVAL;
        yPos = level .* POINT_INTERVAL;

        pointColor = 'b';
        if mod( level, 2) == 0
            pointColor = 'r';
        end

        plot( AXH, xPos, yPos, 'o', 'MarkerEdgeColor', pointColor, 'MarkerFaceColor', pointColor);
    end

    % assign start point
    if nargout > 0
        startPointUnitXPos = unitXPositions( LEVELS, LEVELS);
        startBallXPos = ( startPointUnitXPos( 1) + startPointUnitXPos( end)) / 2 * POINT_INTERVAL;
        SP = [  startBallXPos LEVELS*POINT_INTERVAL];
    end
    % assign final possible X positions
    if nargout > 1
        lastPointUnitXPos = unitXPositions( 1, LEVELS);
        % For adjacent x pos we calculate "( x0 + x1) / 2"
        adjXPos = [ lastPointUnitXPos( 1 : (end - 1)) ; lastPointUnitXPos( 2 : end)];
        FXP = sum( adjXPos) / 2 .* POINT_INTERVAL;
    end

    % caller should not provide more than 2 arguments
    if nargout > 2
        error( "galtonbox: At most 2 outputs are permitted");
    end
end


% return unit positions of points with given level and total level
function XPOS = unitXPositions( CUR_LEVEL, TOTAL_LEVEL)
    % unit x pos starts from 0
    unitLastXPos = TOTAL_LEVEL - CUR_LEVEL + 1;
    unitXPos = 0 : 1 : unitLastXPos;
    unitXPos -= unitLastXPos / 2;
    XPOS = unitXPos;
end
