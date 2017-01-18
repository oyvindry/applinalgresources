% This function desperately need some documentation
function x = DWTIm(x, nres, wave_name, symmarg, dualarg)
    
    if (~exist('symmarg')) symmarg = 1; end
    if (~exist('dualarg')) dualarg  = 0; end
    
    f = findDWTKernel(wave_name);
    x = DWTReadKernel(x, nres, f, symmarg, dualarg);
end
