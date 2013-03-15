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

    % set col:row = 3:2
    % 3x * 2x = number of subplots
    numRow = floor( 2 * sqrt( length( T) / 6));
    numCol = ceil( length( T) / numRow);


    fh = figure();
    setFigureSize( fh, numCol * 200, numRow * 200);
    numIdx = 0;
    for eachT = T
        numIdx += 1;
        ah = subplot( numRow, numCol, numIdx);
        % classifytoy( ah, P, 'svm', '-t 1 -c 100 -s 0 -g 0.5');
        classifytoy( ah, P, eachT.lib, eachT.trainopt);
        title( ah, cstrcat( eachT.lib, ' ', eachT.trainopt));
    end
end


% set figure size
function setFigureSize( FH, WIDTH, HEIGHT)
    figurePos = get( FH, 'Position');
    figurePos( 3:4) = [ WIDTH HEIGHT];
    set( FH, 'Position', figurePos);
end
