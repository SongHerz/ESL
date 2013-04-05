## -*- texinfo -*-
## @deftypefn {Function File} {} interleaveproblem2()
## Test interleave problem for various classification algorithms.
## Check if a classification algorithm can split the space reasonably.
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function interleaveproblem2()
    % prepare 4 points
    p(1).label = -1;
    p(1).pos = [0 0];
    p(2).label = 1;
    p(2).pos = [1 0];
    p(3).label = -1;
    p(3).pos = [2 0];
    p(4).label = 1;
    p(4).pos = [3 0]; 

    % Prepare library, trainoption array.
    opt.lib = 'svm'; opt.trainopt = '-s 1 -t 2 -q'; opt.predictopt = '-q';

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

