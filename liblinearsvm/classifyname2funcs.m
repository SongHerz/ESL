## -*- texinfo -*-
## @deftypefn {Function File} {[@var{TRAINFUNC}, @var{PREDICTFUNC}] =} classifyname2funcs( @var{LIBNAME})
## Get train/predict function handles @var{TRAINFUNC} and @var{PREDICTFUNC} according to the @var{LIBNAME}.
## @end deftypefn
function [TRAINFUNC, PREDICTFUNC] = classifyname2funcs( LIBNAME)
    switch LIBNAME
        case 'linear'
            [ TRAINFUNC, PREDICTFUNC] = deal( @train, @predict);
        case 'svm'
            [ TRAINFUNC, PREDICTFUNC] = deal( @svmtrain, @svmpredict);
        otherwise
            assert( 0, 'Unknown library');
    end
end
