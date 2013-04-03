## -*- texinfo -*-
## @deftypefn {Function File} {} xorproblem2()
## Test xor problem for various classification algorithms.
## Given 4 points:
## white points: (1, 0), (0, 1)
## black points: (0, 0), (1, 1)
## Check if a classification algorithm can split the space reasonably.
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function xorproblem2()
    % prepare 4 points
    p(1).label = -1;
    p(1).pos = [0 0];
    p(2).label = -1;
    p(2).pos = [1 1];
    p(3).label = 1;
    p(3).pos = [0 1];
    p(4).label = 1;
    p(4).pos = [1 0]; 

    % Prepare library, trainoption array.
    opt.lib = 'svm'; opt.trainopt = '-s 1 -t 2'; opt.predictopt = '';

    POS(1).points = p;
    POS(1).option = opt;
    POS(2).points = [p, p];
    POS(2).option = opt;
    POS(3).points = [p, p, p, p];
    POS(3).option = opt;
    POS(4).points = [p, p, p, p, p, p, p, p];
    POS(4).option = opt;

    classifyprobcomp( POS);
end

