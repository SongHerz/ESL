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

function twocatproblem2()
    % prepare 2 points for training
    pt(1).label = -1;
    pt(1).pos = [0 0];
    pt(2).label = 1;
    pt(2).pos = [1 1];
    pt(3).label = 0;
    pt(3).pos = [0 1];
    pt(4).label = 0;
    pt(4).pos = [1 0];

    % points for prediction
    pp(1).label = -1;
    pp(1).pos = [0 0];
    pp(2).label = -1;
    pp(2).pos = [1 1];
    pp(3).label = 1;
    pp(3).pos = [0 1];
    pp(4).label = 1;
    pp(4).pos = [1 0]; 

    % Prepare library, trainoption array.
    opt.lib = 'svm'; opt.trainopt = '-s 1 -t 2 -c 10 -q'; opt.predictopt = '-q';

    POS(1).tpoints = pt;
    POS(1).ppoints = pp;
    POS(1).option = opt;

    POS(2).tpoints = [pt, pt];
    POS(2).ppoints = pp;
    POS(2).option = opt;

    POS(3).tpoints = [pt, pt, pt, pt];
    POS(3).ppoints = pp;
    POS(3).option = opt;

    POS(4).tpoints = [pt, pt, pt, pt, pt, pt, pt, pt];
    POS(4).ppoints = pp;
    POS(4).option = opt;

    classifyprobcomp( POS);
end

