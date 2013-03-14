## -*- texinfo -*-
## @deftypefn {Function File} {} xorproblem()
## Test xor problem for various classification algorithms.
## Given 4 points:
## white points: (1, 0), (0, 1)
## black points: (0, 0), (1, 1)
## Check if a classification algorithm can split the space reasonably.
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function xorproblem()
    % prepare 4 points
    P(1).label = -1;
    P(1).pos = [0.078 0.082];
    P(2).label = -1;
    P(2).pos = [0.904 0.912];
    P(3).label = 1;
    P(3).pos = [0.048 0.952];
    P(4).label = 1;
    P(4).pos = [0.886 0.078]; 

    ah = gca();
    [ regionX regionY, regionPredict] = classify( ah, P, @svmtrain, @svmpredict, '-t 1 -c 100 -s 0 -g 0.5');
    
    % draw classification
    hold on
    plotPoints( ah, P);
    plotPredict( ah, regionX, regionY, regionPredict);
end


% Get matrix with classified region
% AH: A axis handle, where to draw.
% POINTS: A structure array that contains label and position.
% trainH: A function handle to train function.
% predictH: A function handle to predict function.
% OPTIONS: A string which is the option for train function.
% Return
% REGIONX, REGIONY, REGIONPREDICT: values that can be pssed to contourf(...)
function [REGIONX REGIONY REGIONPREDICT] = classify( AH, POINTS, trainH, predictH, trainOPT)
    assert( nargin == 5, 'There must be 5 arguments');

    labels = vertcat( POINTS.label);
    insts = vertcat( POINTS.pos);
    assert( size( insts, 2) == 2);

    model = trainH( labels, insts, trainOPT);

    % sample points from region
    pointX = insts(:, 1);
    pointY = insts(:, 2);
    minX = min( pointX);
    maxX = max( pointX);
    minY = min( pointY);
    maxY = max( pointY);

    sampleX = linspace( minX, maxX, 100);
    sampleY = linspace( minY, maxY, 100);

    [ sampleXX sampleYY] = meshgrid( sampleX, sampleY);
    assert( size( sampleXX) == size( sampleYY));
    samplePoint = [ sampleXX(:) sampleYY(:)];

    % predict sample points
    predictLabel = predictH( zeros( size( samplePoint, 1), 1), samplePoint, model);
    % predict matrix
    predictLabelMatrix = reshape( predictLabel, size( sampleXX));

    REGIONX = sampleX;
    REGIONY = sampleY;
    REGIONPREDICT = predictLabelMatrix;
end

% plot points according to their label and position
% AH: A axis handle, where the points will be drawed.
% POINTS: A structure array that contains label and position.
function plotPoints( AH, POINTS)
    oldHold = ishold( AH);
    hold( AH, 'on');

    for point = POINTS
        label = point.label;
        pointX = point.pos(1);
        pointY = point.pos(2);
        color = '';
        switch label
            case -1 color = 'r';
            case  1 color = 'b';
            otherwise assert( 0, sprintf("Unknown label: %f", label));
        end
        printf("X = %f, Y = %f\n", pointX, pointY);
        plot( AH, pointX, pointY, '.',
             'Marker', 's',
             'MarkerFaceColor', color,
             'MarkerEdgeColor', color,
             'MarkerSize', 10);
    end

    assert( ishold( AH));
    if !oldHold
        hold( AH, 'off');
    end
end

% plot region according to predict results
% AH: A axis handle, where the points will be drawed.
% REGIONX, REGIONY, REGIONPREDICT: x, y points, and prediction on the points
function plotPredict( AH, REGIONX, REGIONY, REGIONPREDICT)
    assert( nargin == 4, "There must be 4 arguments");
    assert( ndims( REGIONPREDICT) == 2);
    
    oldHold = ishold( AH);
    numLabels = length( unique( REGIONPREDICT));
    contourf( AH, REGIONX, REGIONY, REGIONPREDICT, numLabels - 1 );
    
    % set color map for the contour region
    maxLabel = max( max( REGIONPREDICT));
    minLabel = min( min( REGIONPREDICT));
    midLabel = ( maxLabel + minLabel) / 2;
    distLabel = maxLabel - minLabel;
    caxis( AH, [ midLabel - distLabel, midLabel + distLabel]);

    assert( ishold( AH));
    if !oldHold
        hold( AH, 'off');
    end
end
