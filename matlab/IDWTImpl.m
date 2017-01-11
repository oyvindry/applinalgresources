function x = IDWTIm(x, nres, wave_name, symmarg, dualarg)
    
    if (~exist('symmarg')) symmarg = 1; end
    if (~exist('dualarg')) dualarg  = 0; end
    
    f = findIDWTKernel(wave_name);
    x = IDWTReadKernel(x, nres, f, symmarg, dualarg);
end

