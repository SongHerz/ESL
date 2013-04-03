## -*- texinfo -*-
## @deftypefn {Function File} { @var{REFORMED_OPT} =} reformclassifyopt( @var{OPT})
## Reform classify option @var{OPT} to make sure returned option contains fields 'lib', 'trainopt' and 'predictopt'. Other non-relative fields are removed.
## @end deftypefn
function REFORMED_OPT = reformclassifyopt( OPT)
    assert( isfield( OPT, 'lib'));
    REFORMED_OPT.lib = OPT.lib;

    assert( isfield( OPT, 'trainopt'));
    REFORMED_OPT.trainopt = OPT.trainopt;

    % predictopt may miss from OPT
    if isfield( OPT, 'predictopt') && !isempty( OPT.predictopt)
        REFORMED_OPT.predictopt = OPT.predictopt;
    else
        REFORMED_OPT.predictopt = '';
    end
end
