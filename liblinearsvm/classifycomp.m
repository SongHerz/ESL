## -*- texinfo -*-
## @deftypefn {Function File} {} classifycomp( POINTS, OPTS, WIDTH, HEIGHT)
## Compare classifiers for given points @var{POINTS} with classifytoy().
##
## Each classifier parameters are given from @var{OPTS}.
## For each train parameter there is a subplot.
##
## The ratio of width/height of the whole figure are specified by @var{WIDTH} and @var{HEIGHT}
##
## @var{POINTS} are a structure array, that contains points to be classified.
## @example
## E.g.
## s(1).label = label_value_1; s(1).pos = [ x_value_1 y_value_1];
## s(2).label = label_value_2; s(2).pos = [ x_value_2 y_value_2];
## @end example
##
## @var{OPTS} are a structure array, that contains various classify parameters.
## It contains 'lib', 'trainopt', and 'predictopt' fields, and 'predictopt' can be omitted.
## @example
## E.g.
## t(1).lib = 'svm'; t(1).trainopt = '-s 0 -t 0 -b 1'; t(1).predictopt = '-b 1';
## t(2).lib = 'linear'; t(2).trainopt = '-s 1';
## @end example

function classifycomp( POINTS, OPTS, WIDTH, HEIGHT)
    numClassifiers = length(OPTS);
    assert( numClassifiers > 0, 'There must be at least one classifiers');

    % calculate rows and columns of subplots
    % col : row = WIDTH : HEIGHT;
    % ( HEIGHT * x) * ( WIDTH * x) = number of subplots
    numRow = floor( HEIGHT * sqrt( numClassifiers / ( WIDTH * HEIGHT)));
    if numRow == 0, numRow = 1; end
    numCol = ceil( numClassifiers / numRow);

    
    fh = figure();
    setFigureSize( fh, numCol * 200, numRow * 200);
    numIdx = 0;
    for eachOpt = OPTS
        numIdx += 1;
        ah = subplot( numRow, numCol, numIdx);
        predictopt = '';
        if isfield( eachOpt, 'predictopt') && !isempty( eachOpt.predictopt)
            predictopt = eachOpt.predictopt;
        end 
        classifytoy( ah, POINTS, eachOpt.lib, eachOpt.trainopt, predictopt);
        title( ah, cstrcat( eachOpt.lib, ' train: ', eachOpt.trainopt, ' predict: ', predictopt));
    end
end

% set figure size
function setFigureSize( FH, WIDTH, HEIGHT)
    figurePos = get( FH, 'Position');
    figurePos( 3:4) = [ WIDTH HEIGHT];
    set( FH, 'Position', figurePos);
end
