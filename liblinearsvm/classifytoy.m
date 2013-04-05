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

    [ trainFunc, predictFunc] = classifyname2funcs( LIBNAME);

    [ regionX, regionY, regionPredict] = classifyregion( POINTS, POINTS, trainFunc, TRAINOPT, predictFunc, PREDICTOPT);
    
    % draw classification
    oldHold = ishold( AH);
    if !oldHold
        cla( AH, 'reset');
        hold( AH, 'on');
    end

    plotpoints( AH, POINTS);
    plotregionpredict( AH, regionX, regionY, regionPredict);

    if !oldHold
        hold( AH, 'off');
    end
end
