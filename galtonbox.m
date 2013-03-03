## -*- texinfo -*-
## @deftypefn  {Function File} {} galtonbox ( @var{LEVEL}, @var{BALLS}, @var{INTERVAL})
## Plot galton box.
## @var{LEVEL} means how many levels. ( Default: 1)
## @var{BALLS} means how many balls. ( Default: 1)
## @var{INTERVAL} means interval between each frame in seconds. If omitted or 0, no animation.

function galtonbox ( varargin)

    nargs = nargin;
    LEVEL = 1;
    BALLS = 1;
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
    fh = figure;
    % create a new axis obj
    axh = gca();
    hold on

    ballStartXPos = unitBallPositions( LEVEL, LEVEL);
    ballLastXPos = unitBallPositions( 1, LEVEL);
    assert( length( ballStartXPos) == 1);
    ballStartPos = [ ballStartXPos( 1) LEVEL];

    % plot levels
    pointInterval = 1;
    plotLevels( axh, LEVEL, pointInterval);
    % plot ball with ballPos
    darkGreen = [ 0 0.5 0];
    ballPos = ballStartPos;
    ballH = plot( axh, ballPos( 1), ballPos( 2), 'o', ...
                    'MarkerFaceColor', darkGreen, 'MarkerEdgeColor', darkGreen, 'MarkerSize', 10);
    set( ballH, 'XDataSource', 'ballPos(1)');
    set( ballH, 'YDataSource', 'ballPos(2)');

    % simulate fall of balls
    for eacBall = 1:BALLS
        ballPos = ballStartPos;
        pause( 0.4);
        refreshdata( fh, 'caller'); 
        drawnow;
        while ballPos( 2) > 0
            ballPos = unitNextPosition( ballPos);
            pause( 0.4);
            refreshdata( fh, 'caller'); 
            drawnow;
        end
    end
    
end


function tf = is_positive_scalar_integer( val)
    tf = isscalar( val) && isnumeric( val) && fix( val) == val && val > 0;
end


% return start point of a ball, and all possible X positions of the ball in unit position
% SP: start point of the ball, in unit position
% FXP: final possible x positions of the ball, in unit position
function plotLevels( AXH, LEVELS, POINT_INTERVAL)
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
    % set axis limit
    xPos = unitXPositions( 1, LEVELS) .* POINT_INTERVAL;
    axis( [ (xPos(1) - POINT_INTERVAL) (xPos( end) + POINT_INTERVAL) 0 ( (LEVELS + 1) * POINT_INTERVAL)]);
end


% return unit positions of points with given level and total level
function XPOS = unitXPositions( CUR_LEVEL, TOTAL_LEVEL)
    % unit x pos starts from 0
    unitLastXPos = TOTAL_LEVEL - CUR_LEVEL + 1;
    unitXPos = 0 : 1 : unitLastXPos;
    unitXPos -= unitLastXPos / 2;
    XPOS = unitXPos;
end

% return all possible unix X positions of a ball with given level and total level
function BPOS = unitBallPositions( CUR_LEVEL, TOTAL_LEVEL)
    unitXPos = unitXPositions( CUR_LEVEL, TOTAL_LEVEL);
    assert( length( unitXPos) >= 2, 'unitXPos must >= 2');
    % For adjacent x pos we calculate "( x0 + x1) / 2"
    adjXPos = [ unitXPos( 1 : (end - 1)) ; unitXPos( 2 : end)];
    BPOS = sum( adjXPos) / 2;
end

% update ball unit position, based on previous position.
function NPOS = unitNextPosition( CUR_POS)
    % get next position where the ball will go
    xPos = CUR_POS( 1);
    yPos = CUR_POS( 2);
    assert( yPos > 0, 'Y position must larger than 0');
    % update x position when yPos > 1
    if yPos > 1
        if rand() <= 0.5
            xPos -= 0.5;
        else
            xPos += 0.5;
        end
    end
    yPos -= 1;
    NPOS = [ xPos yPos];
end
