## -*- texinfo -*-
## @deftypefn {Function File} {} classifytoy( POINTS, LIBNAME, TRAINOPT)
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
## If an axes handle is passed as the first argument, then operate on
## this axes rather than the current axes.
##
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function classifytoy( varargin)
end


% internal function for classifytoy
function internal_classifytoy( AH, POINTS, LIBNAME, TRAINOPT)
    assert( nargin == 4, 'There must be 4 arguments');
end
