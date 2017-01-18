function filters=liftingfactortho(N, mode, debug_mode)
    % Assume that length(h1)==length(h0), and that h0 and h1 are even length
    % and as symmetric as possible, with h0 more filter coefficients to the
    % right, h1 to the left To compute H: first multiply with
    % diag(alpha,beta), then the inverses if the lifting steps in reverse
    % order The first step is odd if and only if the number of steps is odd.
    % The last lifting step is always odd All even lifting steps have only
    % coefficients 0,1. All odd lifting steps have only coefficients -1,0
  
    % To compute G: apply the lifting steps in the right order, finally
    % multiply with diag(1/alpha,1/beta)
  
    %global AL AR h0 h1 g0 g1 A_L_pre A_L_pre_inv A_R_pre A_R_pre_inv
    
    if (nargin <  3)
        debug_mode = 0;
    end
    if (nargin == 1)
        mode = 1;
    end
    
    % We remove the persistent variables until we are done testing, so that
    % everything is recomputed each time one call this function.

    %persistent filterMap;
    %if (isempty(filterMap)) 
    %    filterMap = containers.Map('KeyType', 'double', 'ValueType', 'any');
    %end
    %if (filterMap.isKey(N) && debugMode == 0) 
    %    filters = filterMap(N);
    %else
        
    % First the right edge
    if (mode == 1)
        [h0, h1, g0, g1] = h0h1computeortho(N);
    elseif (mode == 2)
        [h0, h1, g0, g1] = h0h1computesym(N);
    end
    h0 = flip(h0);
    h1 = flip(h1);
    g0 = flip(g0);
    g1 = flip(g1);
    filters = liftingstepscomputeortho(h0, h1);
    
    [W, A_pre, A_pre_inv] = bw_compute_left(h0, g0, debug_mode); % Lower right (3N-1)x(2N) matrix
    %filters.A_R_pre = fliplr(flipud(A_pre));
    %filters.A_R_pre_inv = fliplr(flipud(A_pre_inv));
    WR = zeros(size(W));
    for k=1:N
        WR(:,[2*k-1 2*k]) = W(size(W,1):(-1):1,2*N+1-[2*k 2*k-1]); 
    end

    % Then the left edge
    h0 = flip(h0);
    h1 = flip(h1);
    g0 = flip(g0);
    g1 = flip(g1);
    filters = liftingstepscomputeortho(h0, h1);
    filters.A_R_pre = fliplr(flipud(A_pre));
    filters.A_R_pre_inv = fliplr(flipud(A_pre_inv));
    [WL,A_pre, A_pre_inv] = bw_compute_left(h0, g0, debug_mode); % Upper left (3N-1)x(2N) matrix
    filters.A_L_pre = A_pre;
    filters.A_L_pre_inv = A_pre_inv;
  
    % Compute the left and right parts of the IDWT for boundary handling
    M = 6*N;
    seg1 = zeros(M); % One bigger than is actually needed
    
    filters.AL = zeros(size(WL));
    filters.AR = zeros(size(WR));
    for k=0:(M-1)
        x = zeros(M,1);
        x(k+1) = 1;
        seg1(:,k+1) = IDWTKernelOrtho(x, filters, 2, 0);
    end
    
    [w1, w2] = size(WL);
    filters.AL=WL-seg1(1:w1,1:w2);
    filters.AR=WR-seg1((M-w1+1):M,(M-w2+1):M);
    
        %if (debugMode == 0)
        %    % Store filters to current session
        %    filterMap(N) = filters;
        %end
    %end
end
