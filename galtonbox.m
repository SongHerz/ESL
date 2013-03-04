## -*- texinfo -*-
## @deftypefn  {Function File} {} galtonbox ( @var{LEVEL}, @var{BALLS}, @var{INTERVAL})
## Plot galton box.
## @var{LEVEL} means how many levels. ( Default: 1)
## @var{BALLS} means how many balls. ( Default: 1)
## @var{INTERVAL} means interval between each frame in seconds. If omitted or 0, no animation.
## @end deftypefn

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
        if !( isscalar( INTERVAL) && isreal( INTERVAL) && INTERVAL >= 0)
            error("galtonbox: INTERVAL should be a non-negative real number");
        end
    end

    enableAnimate = ( INTERVAL != 0);


    ballStartXPos = unitBallPositions( LEVEL, LEVEL);
    ballLastXPos = unitBallPositions( 1, LEVEL);
    assert( length( ballStartXPos) == 1);
    ballStartPos = [ ballStartXPos( 1) LEVEL];

    % Data for bar graph
    % barX is ballLastXPos
    barY = zeros( 1, length( ballLastXPos));

    % create a new figure
    fh = figure;

    % create box plot
    boxH = subplot( 2, 1, 1);
    hold( boxH, 'on');

    % plot levels
    pointInterval = 1;
    xAxisLim = plotLevels( boxH, LEVEL, pointInterval);
    % plot ball with ballPos
    darkGreen = [ 0 0.5 0];
    ballPos = ballStartPos;
    ballH = plot( boxH, ballPos( 1), ballPos( 2), 'o', ...
                    'MarkerFaceColor', darkGreen, 'MarkerEdgeColor', darkGreen, 'MarkerSize', 10);
    set( ballH, 'XDataSource', 'ballPos(1)');
    set( ballH, 'YDataSource', 'ballPos(2)');

    % create bar plot
    barAxesH = subplot( 2, 1, 2);
    hold( barAxesH, 'on');
    xlim( barAxesH, xAxisLim);
    barH = bar( ballLastXPos, barY);
    set( barH, 'YDataSource', 'barY');


    % simulate fall of balls
    for eacBall = 1:BALLS
        ballFinalXPos = 0;

        if !enableAnimate
            ballFinalXPos = unitBallPath( LEVEL, ballStartPos);
        else
            [ ballFinalXPos ballPath] = unitBallPath( LEVEL, ballStartPos);
            for eachPos = 1 : size( ballPath, 2)
                ballPos = ballPath( :, eachPos)';
                pause( INTERVAL);
                refreshdata( fh, 'caller'); 
                drawnow;
            end
        end

        % update barY
        barYIdx = find( ballLastXPos == ballFinalXPos);
        if !isempty( barYIdx)
            assert( isscalar( barYIdx));
            barY( barYIdx) += 1;
        end

        % Update ball and bar
        if enableAnimate
            pause( INTERVAL);
            refreshdata( fh, 'caller'); 
            drawnow;
        end
    end

    % Finally, draw the ultimate graph
    refreshdata( fh, 'caller');
end


function tf = is_positive_scalar_integer( val)
    tf = isscalar( val) && isnumeric( val) && fix( val) == val && val > 0;
end

% return X limit of the graph
% SP: start point of the ball, in unit position
% FXP: final possible x positions of the ball, in unit position
function XLIM = plotLevels( AXH, LEVELS, POINT_INTERVAL)
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
    xPosMin = xPos(1) - POINT_INTERVAL;
    xPosMax = xPos( end) + POINT_INTERVAL;
    yPosMin = 0;
    yPosMax = (LEVELS + 1) * POINT_INTERVAL;
    axis( [ xPosMin xPosMax yPosMin yPosMax]);
    XLIM = [ xPosMin xPosMax];
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

% Calculate path of the ball, based on start position
% FXP = unitBallPath( START_POS);
% [FXP BPATH] = unitBallPath( START_POS);
%
% With only one return value, the final x position of the ball is stored in FXP.
% With two return values, BPATH contains all positions of the ball, including the start and final positions.
% Each position are stored in column.
function [FXP, BPATH] = unitBallPath( TOTAL_LEVEL, START_POS)
    assert( nargout <= 2);
    nOutputs = nargout;

    % get a series of random numbers
    % get random number in ( -0.5, 0.5)
    randMove = rand( 1, TOTAL_LEVEL - 1) - 0.5;
    % get [-0.5, +0.5] series.
    randMove = sign(( randMove >= 0) - 0.5) * 0.5;
    
    % calculate final x position
    xStart = START_POS( 1);
    FXP = xStart + sum( randMove);


    if nOutputs > 1
        % For start/final position random move should be zero
        randMove = [ 0 randMove 0];
        % Update x path
        xPath = zeros( 1, TOTAL_LEVEL + 1);
        assert( length( xPath) == length( randMove));

        xPath( 1) = xStart;
        for eachIdx = 2 : length( xPath)
            xPath( eachIdx) = xPath( eachIdx - 1) + randMove( eachIdx);
        end
        assert( xPath( end) == FXP);

        % Update y path
        yStart = START_POS( 2);
        yPath = yStart : -1 : 0;
        
        BPATH = [ xPath; yPath];
    end
end
