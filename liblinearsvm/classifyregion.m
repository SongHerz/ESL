## -*- texinfo -*-
## @deftypefn {Function File} {[@var{REGIONX}, @var{REGIONY}, @var{REGIONPREDICT}, @var{REGION_DEC_PROB}] =} classifyregion ( @var{TPOINTS}, @var{PPOINTS}, @var{trainH}, @var{trainOPT}, @var{predictH}, @var{predictOPT})
## Get matrix with classified region
##
## @var{TPOINTS} and @var{PPOINTS} are structure arrays that contain label and position.
## @var{TPOINTS} is for training, and @var{PPOINTS} is for prediction.
##
## @var{trainH} is a function handle to train function.
##
## @var{trainOPT} is a the option for train function.
##
## @var{predictH} is a function handle to predict function.
##
## @var{predictOPT} is the option for predict function.
##
## Return values: 
## @var{REGIONX}, @var{REGIONY}, @var{REGIONPREDICT}, and @var{REGION_DEC_PROB} are x, y vectors, prediction of each point, and decision values/probabilities of the region that contains @var{PPOINTS}.
##
## @var{REGIONX}, @var{REGIONY} and @var{REGIONPREDICT} can be passed to contourf( ...) to plot prediction of the region.
##
## @var{REGIONX}, @var{REGIONY} and @var{RETION_DEC_PROB} can be passed to imagesc( ...) to plot decision values/probabilities of the retion.
## @end deftypefn
function [REGIONX REGIONY REGIONPREDICT, REGION_DEC_PROB] = classifyregion( TPOINTS, PPOINTS, trainH, trainOPT, predictH, predictOPT)
    assert( nargin == 6, 'There must be 6 arguments');

    tlabels = vertcat( TPOINTS.label);
    tinsts = vertcat( TPOINTS.pos);
    assert( size( tinsts, 2) == 2);

    % LibLinear requires sparse matrix as training samples
    % LibSVM accepts both full and sparse training samples
    model = trainH( tlabels, sparse( tinsts), trainOPT);

    plabels = vertcat( PPOINTS.label);
    pinsts = vertcat( PPOINTS.pos);
    assert( size( pinsts, 2) == 2);

    % sample points from region
    ppointX = pinsts(:, 1);
    ppointY = pinsts(:, 2);
    pminX = min( ppointX);
    pmaxX = max( ppointX);
    pminY = min( ppointY);
    pmaxY = max( ppointY);
    
    if pminY == pmaxY
        pminY -= (pmaxX - pminX)/2;
        pmaxY += (pmaxX - pminX)/2;
    end

    psampleX = linspace( pminX, pmaxX, 100);
    psampleY = linspace( pminY, pmaxY, 100);

    [ psampleXX psampleYY] = meshgrid( psampleX, psampleY);
    assert( size( psampleXX) == size( psampleYY));
    psamplePoint = [ psampleXX(:) psampleYY(:)];

    % predict sample points
    % LibLinear requires sparse matrix as predict samples
    % LibSVM accepts both full and sparse predict samples
    [ predictLabel, dummyAccuracy, decProb] = predictH( sparse( zeros( size( psamplePoint, 1), 1)), sparse( psamplePoint), model, predictOPT);

    % predict matrix
    predictLabelMatrix = reshape( predictLabel, size( psampleXX));
    % decision values/probabilities matrix, just pick the max column, and reshape.
    decProbMatrix = reshape( max( decProb, [], 2), size( psampleXX));

    REGIONX = psampleX;
    REGIONY = psampleY;
    REGIONPREDICT = predictLabelMatrix;
    REGION_DEC_PROB = decProbMatrix;
end
