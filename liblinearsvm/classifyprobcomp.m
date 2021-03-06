## -*- texinfo -*-
## @deftypefn {Function File} {} classifyprobcomp( POS);
## Compare different combinations of points and options, and their classification results.
##
## @var{POS} is a structure array, that each of them contains, a 'tpoints' field for training,
## a 'ppoints' field for prediction, and a 'option' field.
## A 'tpoints'/'ppoints' field is a structure array, that each of them contains a 'label' field, and a 'pos' field.
## An 'option' field is a structure, that contains fields 'lib', 'trainopt', and 'predictopt'.
## @end deftypefn

function classifyprobcomp( POS)
    numInstSet = length( POS);

    fh = figure();
    setFigureSize( fh, numInstSet * 200, 3 * 200);

    offset = 0;
    for eachPO = POS
        tpoints = eachPO.tpoints;
        ppoints = eachPO.ppoints;
        opt = reformclassifyopt( eachPO.option);
        hPreNoProb = subplot( 3, numInstSet, 1 + offset);
        hPreWithProb = subplot( 3, numInstSet, 1 + numInstSet + offset);
        hProbWithProb = subplot( 3, numInstSet, 1 + 2*numInstSet + offset);

        internal_classifyprobcomp( hPreNoProb, hPreWithProb, hProbWithProb, tpoints, ppoints, opt);
        offset += 1;
    end
end


function internal_classifyprobcomp( hPreNoProb, hPreWithProb, hProbWithProb, tpoints, ppoints, opt)
    assert( nargin == 6, 'There must be 6 arguments');

    [ trainFunc, predictFunc] = classifyname2funcs( opt.lib);

    % Do not allow '-b' option, no matter it is '-b 1' or '-b 0'
    assert( isempty( strfind( opt.trainopt, '-b')), 'No -b allowed in train option');
    assert( isempty( strfind( opt.predictopt, '-b')), 'No -b allowed in predict option');

    % train model without probability estimation
    % assume opt.trainopt and opt.predictopt contain no '-b 1'
    [ regionX, regionY, regionPredict] = classifyregion( tpoints, ppoints, trainFunc, opt.trainopt, predictFunc, opt.predictopt);
    draw_prediction( hPreNoProb, ppoints, regionX, regionY, regionPredict);
    title( hPreNoProb,
            { sprintf( 'Num of training points: %d', length( tpoints)),
              sprintf( 'Num of prediction points: %d', length( ppoints)),
              cstrcat( opt.lib, ' train: ', opt.trainopt, ' predict: ', opt.predictopt)
            });

    % Add '-b 1' option and re-predict
    newTrainOpt = cstrcat( opt.trainopt, ' -b 1');
    newPredictOpt = cstrcat( opt.predictopt, ' -b 1');
    [ regionX, regionY, regionPredict, regionProb] = classifyregion( tpoints, ppoints,
                        trainFunc, newTrainOpt, predictFunc, newPredictOpt);
    draw_prediction( hPreWithProb, ppoints, regionX, regionY, regionPredict);
    title( hPreWithProb, cstrcat( opt.lib, ' train: ', newTrainOpt, ' predict: ', newPredictOpt));

    draw_probability( hProbWithProb, ppoints, regionX, regionY, regionPredict, regionProb);
    title( hProbWithProb, cstrcat( opt.lib, ' train: ', newTrainOpt, ' predict: ', newPredictOpt));
end


% Draw prediction for axis handle AH.
function draw_prediction( AH, points, regionX, regionY, regionPredict);
    % draw classification
    oldHold = ishold( AH);
    hold( AH, 'on');

    plotpoints( AH, points);
    plotregionpredict( AH, regionX, regionY, regionPredict);

    if !oldHold, hold( AH, 'off'); end
end


% Draw probability for axis handle AH.
function draw_probability( AH, points, regionX, regionY, regionPredict, regionProb)
    % draw classification
    oldHold = ishold( AH);
    hold( AH, 'on');

    plotpoints( AH, points);
    plotregionprobability( AH, regionX, regionY, regionProb);
    contour( AH, regionX, regionY, regionPredict, 1);
    colorbar( 'peer', AH, 'SouthOutside');

    if !oldHold, hold( AH, 'off'); end
end

% set figure size
function setFigureSize( FH, WIDTH, HEIGHT)
    figurePos = get( FH, 'Position');
    figurePos( 3:4) = [ WIDTH HEIGHT];
    set( FH, 'Position', figurePos);
end
