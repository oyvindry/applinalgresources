function x = DWTKernelOrtho(x, filters, mode, dual)
    % mode 2 boundary handling
    % mode 3 preconditioning 
    
    
    N = size(x, 1);
  
    y1 = 0; y2 = 0;
    if mode == 3
        x(1:size(filters.A_L_pre,1)) = filters.A_L_pre*x(1:size(filters.A_L_pre,1));
        x((end-size(filters.A_R_pre,1)+1):end) = filters.A_R_pre*x((end-size(filters.A_R_pre,1)+1):end);
    end
    if mode >= 2
        y1 = filters.AL'*x(1:size(filters.AL,1));
        y2 = filters.AR'*x((N-size(filters.AR,1)+1):N);
        dual = ~dual;
    end
    if dual
        x(1:2:N, :) = x(1:2:N, :)/filters.alpha;
        x(2:2:N, :)=x(2:2:N, :)/filters.beta;
        for stepnr = size(filters.lambdas,1):(-2):2
            x = liftingstepodd(filters.lambdas(stepnr,2), filters.lambdas(stepnr,1), x, mode);
            x = liftingstepeven(filters.lambdas(stepnr-1,2), filters.lambdas(stepnr-1,1), x, mode);
        end
  
        if stepnr == 3
            x = liftingstepodd(filters.lambdas(1,2), filters.lambdas(1,1), x, mode);
        end
    else
        x(1:2:N, :) = x(1:2:N, :)*filters.alpha;
        x(2:2:N, :) = x(2:2:N, :)*filters.beta;
        for stepnr = size(filters.lambdas,1):(-2):2
            x = liftingstepeven(-filters.lambdas(stepnr,1), -filters.lambdas(stepnr,2), x, mode);
            x = liftingstepodd(-filters.lambdas(stepnr-1,1), -filters.lambdas(stepnr-1,2), x, mode);
        end
  
        if stepnr == 3
            x = liftingstepeven(-filters.lambdas(1,1), -filters.lambdas(1,2), x, mode);
        end
    end
    if mode >= 2
        x(1:size(filters.AL,2)) = x(1:size(filters.AL,2)) + y1;
        x((N-size(filters.AR,2)+1):N) = x((N-size(filters.AR,2)+1):N) + y2;
    end
