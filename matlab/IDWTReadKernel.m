function x = IDWTReadKernel(x, nres, f, symmarg, dualarg)
    x = reorganize_coefficients(x, nres, 0);
    N = size(x, 1);
    for res = (nres - 1):(-1):0
        x(1:2^res:N, :) = f(x(1:2^res:N, :), symmarg, dualarg);
    end
    
    
    
