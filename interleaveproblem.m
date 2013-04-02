## -*- texinfo -*-
## @deftypefn {Function File} {} interleaveproblem()
## Test interleave problem for various classification algorithms.
## Check if a classification algorithm can split the space reasonably.
## This function requires LibSVM and LibLinear for details, please refer:
## http://www.csie.ntu.edu.tw/~cjlin/libsvm/
## http://www.csie.ntu.edu.tw/~cjlin/liblinear/
## @end deftypefn

function interleaveproblem()
    % prepare 4 points
    P(1).label = -1;
    P(1).pos = [0 0];
    P(2).label = 1;
    P(2).pos = [1 0];
    P(3).label = -1;
    P(3).pos = [2 0];
    P(4).label = 1;
    P(4).pos = [3 0]; 

    % Prepare library, trainoption array.
    T(1).lib = 'svm'; T(1).trainopt = '-s 0 -t 0';
    T(2).lib = 'svm'; T(2).trainopt = '-s 0 -t 1';
    T(3).lib = 'svm'; T(3).trainopt = '-s 0 -t 2';
    T(4).lib = 'svm'; T(4).trainopt = '-s 0 -t 3';
    T(5).lib = 'svm'; T(5).trainopt = '-s 1 -t 0';
    T(6).lib = 'svm'; T(6).trainopt = '-s 1 -t 1';
    T(7).lib = 'svm'; T(7).trainopt = '-s 1 -t 2';
    T(8).lib = 'svm'; T(8).trainopt = '-s 1 -t 3';
    T(9).lib = 'linear'; T(9).trainopt = '-s 0';
    T(10).lib = 'linear'; T(10).trainopt = '-s 1';
    T(11).lib = 'linear'; T(11).trainopt = '-s 2';
    T(12).lib = 'linear'; T(12).trainopt = '-s 3';
    T(13).lib = 'linear'; T(13).trainopt = '-s 4';
    T(14).lib = 'linear'; T(14).trainopt = '-s 5';
    T(15).lib = 'linear'; T(15).trainopt = '-s 6';
    T(16).lib = 'linear'; T(16).trainopt = '-s 7';

    ttIdx = 0;
    TT = [];
    for eachT = T
        ttIdx += 1;
        TT(ttIdx).lib = eachT.lib;
        TT(ttIdx).trainopt = eachT.trainopt;

        if strcmp( eachT.lib, 'svm')
            ttIdx += 1;
            TT(ttIdx).lib = eachT.lib;
            TT(ttIdx).trainopt = cstrcat( eachT.trainopt, ' -b 1');
            TT(ttIdx).predictopt = '-b 1';
        end
    end
        
    classifycomp( P, TT, 3, 2);
end

