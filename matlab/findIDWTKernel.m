function f = findDWTKernel(wave_name)
    if strcmp(wave_name, 'cdf97')
        f = @(x, symm, dual) IDWTKernel97(x, symm, dual);
    elseif strcmp(wave_name, 'cdf53')
        f = @(x, symm, dual) IDWTKernel53(x, symm, dual);
    elseif strcmp(wave_name, 'pwl0')
        f = @(x, symm, dual) IDWTKernelpwl0(x, symm, dual);
    elseif strcmp(wave_name, 'pwl2')
        f = @(x, symm, dual) IDWTKernelpwl2(x, symm, dual);
    elseif strcmp(wave_name, 'Haar')
        f = @(x, symm, dual) IDWTKernelHaar(x, symm, dual);
    elseif (strcmp(wave_name(1:2), 'db') && ~strcmp(wave_name(end), 'x'))
        vm = str2double(wave_name(3:end));
        filters = liftingfactortho(vm, 0);
        f = @(x, symm, dual) IDWTKernelOrtho(x, filters, symm, dual);
    elseif (strcmp(wave_name(1:2), 'db') && strcmp(wave_name(end), 'x'))
        vm = str2double(wave_name(3:end-1));
        filters = liftingfactortho(vm, 1);
        f = @(x, symm, dual) IDWTKernelOrtho(x, filters, symm, dual);
    end
end
