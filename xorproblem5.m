## -*- texinfo -*-
## @deftypefn {Function File} {} xorproblem4()
## Test xor problem for various classification algorithms.
## Given 9 points:
## white points: (1, 0), (0, 1)
## black points: (0, 0), (1, 1)
## Check if a classification algorithm can split the space reasonably.
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function xorproblem4()
    % prepare 4 points
    p(1).label = -1;
    p(1).pos = [0 0];
    p(2).label = 0;
    p(2).pos = [1 0];
    p(3).label = 1;
    p(3).pos = [2 0];
    p(4).label = -1;
    p(4).pos = [2 1];
    p(5).label = 1;
    p(5).pos = [1 1];
    p(6).label = 0;
    p(6).pos = [0 1];
    p(7).label = 1;
    p(7).pos = [0 2];
    p(8).label = -1;
    p(8).pos = [1 2];
    p(9).label = 0;
    p(9).pos = [2 2];

    % Prepare library, trainoption array.
    opt.lib = 'svm'; opt.trainopt = '-s 0 -t 2 -c 40 -q'; opt.predictopt = '-q';

    POS(1).tpoints = p;
    POS(1).ppoints = p;
    POS(1).option = opt;

    POS(2).tpoints = [p, p];
    POS(2).ppoints = p;
    POS(2).option = opt;

    POS(3).tpoints = [p, p, p, p];
    POS(3).ppoints = p;
    POS(3).option = opt;

    POS(4).tpoints = [p, p, p, p, p, p, p, p];
    POS(4).ppoints = p;
    POS(4).option = opt;

    classifyprobcomp( POS);
end

