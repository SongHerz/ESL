## -*- texinfo -*-
## @deftypefn {Function File} {} classifytoy( POINTS, LIBNAME, TRAINOPT, PREDICTOPT)
## @deftypefnx {Function File} {} classifytoy( AH, ...)
## Classify 2D points with LibSVM/LibLinear.
##
## @var{POINTS} is a structure array, each of whom contains a label and [x y] position.
##
## @example
## E.g.
## s(1).label = label_value_1, s(1).pos = [ x_value_1 y_value_1];
## s(2).label = label_value_2, s(2).pos = [ x_value_2 y_value_2];
## @end example
##
## @var{LIBNAME} specifies which library to use, 'linear' or 'svm'
##
## @var{TRAINOPT} is the option for training, which is the same as 'train' from LibLinear
## and 'svm-train' from LibSVM.
##
## @var{PREDICTOPT} is the option for prediction, which is the same as 'predict' from LibLinear
## and 'svm-predict' from LibSVM.
##
## If an axes handle is passed as the first argument, then operate on
## this axes rather than the current axes.
##
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function classifytoy( varargin)
    ninputs = nargin;
    assert( ninputs == 4 || ninputs == 5, 'There must be 4 or 5 arguments');

    AH = [];
    POINTS = [];
    LIBNAME = [];
    TRAINOPT = [];
    PREDICTOPT = [];

    switch ninputs
        case 4
            AH = gca();
            [ POINTS, LIBNAME, TRAINOPT, PREDICTOPT] = varargin{:};
        case 5
            [ AH, POINTS, LIBNAME, TRAINOPT, PREDICTOPT] = varargin{:};
        otherwise
            assert( 0, 'Never be here');
    end

    internal_classifytoy( AH, POINTS, LIBNAME, TRAINOPT, PREDICTOPT);
end


% internal function for classifytoy
function internal_classifytoy( AH, POINTS, LIBNAME, TRAINOPT, PREDICTOPT)
    assert( nargin == 5, 'There must be 5 arguments');

    trainFunc = [];
    predictFunc = [];

    switch LIBNAME
        case 'linear'
            [ trainFunc, predictFunc] = deal( @train, @predict);
        case 'svm'
            [ trainFunc, predictFunc] = deal( @svmtrain, @svmpredict);
        otherwise
            assert( 0, 'Unknown library');
    end
    

    [ regionX, regionY, regionPredict] = classifyregion( AH, POINTS, trainFunc, TRAINOPT, predictFunc, PREDICTOPT);
    
    % draw classification
    oldHold = ishold( AH);
    if !oldHold
        cla( AH, 'reset');
        hold( AH, 'on');
    end

    plotPoints( AH, POINTS);
    plotPredict( AH, regionX, regionY, regionPredict);

    if !oldHold
        hold( AH, 'off');
    end
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
