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
    classifytoy( ah, P, 'svm', '-t 1 -c 100 -s 0 -g 0.5');
end

