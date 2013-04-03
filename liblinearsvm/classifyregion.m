## -*- texinfo -*-
## @deftypefn {Function File} {[@var{REGIONX}, @var{REGIONY}, @var{REGIONPREDICT}, @var{REGION_DEC_PROP}] =} classifyregion ( @var{AH}, @var{POINTS}, @var{trainH}, @var{trainOPT}, @var{predictH}, @var{predictOPT})
## Get matrix with classified region
##
## @var{AH} is a axis handle, where to draw.
##
## @var{POINTS} is a structure array that contains label and position.
##
## @var{trainH} is a function handle to train function.
##
## @var{trainOPT} is a the option for train function.
##
## @var{predictH} is a function handle to predict function.
##
## @var{predictOPT} is the option for predict function.
##
## Return
## @var{REGIONX}, @var{REGIONY}, @var{REGIONPREDICT}: values that can be pssed to contourf(...)
## @end deftypefn
function [REGIONX REGIONY REGIONPREDICT] = classifyregion( AH, POINTS, trainH, trainOPT, predictH, predictOPT)
    assert( nargin == 6, 'There must be 6 arguments');

    labels = vertcat( POINTS.label);
    insts = vertcat( POINTS.pos);
    assert( size( insts, 2) == 2);

    % LibLinear requires sparse matrix as training samples
    % LibSVM accepts both full and sparse training samples
    model = trainH( labels, sparse( insts), trainOPT);

    % sample points from region
    pointX = insts(:, 1);
    pointY = insts(:, 2);
    minX = min( pointX);
    maxX = max( pointX);
    minY = min( pointY);
    maxY = max( pointY);
    
    if minY == maxY
        minY -= (maxX - minX)/2;
        maxY += (maxX - minX)/2;
    end

    sampleX = linspace( minX, maxX, 100);
    sampleY = linspace( minY, maxY, 100);

    [ sampleXX sampleYY] = meshgrid( sampleX, sampleY);
    assert( size( sampleXX) == size( sampleYY));
    samplePoint = [ sampleXX(:) sampleYY(:)];

    % predict sample points
    % LibLinear requires sparse matrix as predict samples
    % LibSVM accepts both full and sparse predict samples
    predictLabel = predictH( sparse( zeros( size( samplePoint, 1), 1)), sparse( samplePoint), model, predictOPT);
    % predict matrix
    predictLabelMatrix = reshape( predictLabel, size( sampleXX));

    REGIONX = sampleX;
    REGIONY = sampleY;
    REGIONPREDICT = predictLabelMatrix;
end
