## -*- texinfo -*-
## @deftypefn {Function File} {} plotpoints ( @var{AH}, @var{POINTS})
## Plot points according to their label and position
##
## @var{AH} is a axis handle, where the points will be drawed.
##
## @var{POINTS} is a structure array that contains label and position for each point.
## @end deftypefn
function plotpoints( AH, POINTS)
    oldHold = ishold( AH);
    hold( AH, 'on');

    for point = POINTS
        label = point.label;
        pointX = point.pos(1);
        pointY = point.pos(2);
        color = '';
        switch label
            case -1 color = 'r';
            case  1 color = 'b';
            case  0 color = 'm';
            otherwise assert( 0, sprintf("Unknown label: %f", label));
        end
        % printf("X = %f, Y = %f\n", pointX, pointY);
        plot( AH, pointX, pointY, '.',
             'Marker', 's',
             'MarkerFaceColor', color,
             'MarkerEdgeColor', color,
             'MarkerSize', 10);
    end

    assert( ishold( AH));
    if !oldHold
        hold( AH, 'off');
    end
end
