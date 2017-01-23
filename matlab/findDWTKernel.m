function f= findDWTKernel(wave_name)
    % Find the DWTKernel corresponding to the given wavelet name 
    if strcmpi(wave_name, 'cdf97')
        f = @(x, symm, dual) DWTKernel97(x, symm, dual);
    elseif strcmpi(wave_name, 'cdf53')
        f = @(x, symm, dual) DWTKernel53(x, symm, dual);
    elseif strcmpi(wave_name, 'pwl0')
        f = @(x, symm, dual) DWTKernelpwl0(x, symm, dual);
    elseif strcmpi(wave_name, 'pwl2')
        f = @(x, symm, dual) DWTKernelpwl2(x, symm, dual);
    elseif strcmpi(wave_name, 'Haar')
        f = @(x, symm, dual) DWTKernelHaar(x, symm, dual);
    elseif (strcmpi(wave_name(1:2), 'db') && ~strcmpi(wave_name(end), 'x'))
        vm = str2double(wave_name(3:end));
        filters = liftingfactortho(vm, 0, 0);
        f = @(x, symm, dual) DWTKernelOrtho(x, filters, symm, dual);
    elseif (strcmpi(wave_name(1:2), 'db') && strcmpi(wave_name(end), 'x'))
        vm = str2double(wave_name(3:end-1));
        filters = liftingfactortho(vm, 0, 1);
        f = @(x, symm, dual) DWTKernelOrtho(x, filters, symm, dual);
    elseif (strcmpi(wave_name(1:3), 'sym') && ~strcmpi(wave_name(end), 'x'))
        vm = str2double(wave_name(4:end));
        filters = liftingfactortho(vm, 1, 0);
        f = @(x, symm, dual) DWTKernelOrtho(x, filters, symm, dual);
    elseif (strcmpi(wave_name(1:3), 'sym') && strcmpi(wave_name(end), 'x'))
        vm = str2double(wave_name(4:end-1));
        filters = liftingfactortho(vm, 1, 1);
        f = @(x, symm, dual) DWTKernelOrtho(x, filters, symm, dual);
    end

