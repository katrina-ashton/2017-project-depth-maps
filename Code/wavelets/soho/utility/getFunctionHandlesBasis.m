function fhs = getFunctionHandlesBasis( basis, bioh_optimal)
%
% fhs = getFunctionHandlesBasis( basis)
%
% Get the function handles to process a basis
%
% @return  fhs  struct containing the function handles
% @param   basis  {'osh', 'bioh', 'pwh'} name of the basis

  bo = 1;
  if( nargin > 1)
    bo = bioh_optimal;
  end
  bioh_optimal = bo;

  if( 1 == strcmp( 'bioh', basis))

    fhs.filters_analysis = @biohFiltersAnalysis;
    fhs.filters_synthesis = @biohFiltersSynthesis;
    fhs.normalize = @biohNormalizeData;
    fhs.denormalize = @biohDeNormalizeData;
    fhs.enforce_equal_area = 0;
    fhs.normalization_scaling_primary= @biohNormalizationScalingFunctionPrimary;
    fhs.normalization_scaling_dual = @biohNormalizationScalingFunctionDual;    
    if( bioh_optimal > 0)
      fhs.approx = @biohContribCoeffsApprox;
    else
      fhs.approx = @getWaveletCoeffs;
    end

  elseif(( 1 == strcmp( 'osh', basis)) || ( 1 == strcmp( 'soho', basis)))

    fhs.filters_analysis = @oshFiltersAnalysis;
    fhs.filters_synthesis = @oshFiltersSynthesis;
    fhs.normalize = @oshNormalizeData;
    fhs.denormalize = @oshDeNormalizeData;
    fhs.enforce_equal_area = 1;
    fhs.normalization_scaling_primary = @oshNormalizationScalingFunctionPrimary;
    fhs.normalization_scaling_dual = @oshNormalizationScalingFunctionDual;    
    fhs.approx = @getWaveletCoeffs;

  elseif( 1 == strcmp( 'pwh', basis))

    fhs.filters_analysis = @pwhFiltersAnalysis;
    fhs.filters_synthesis = @pwhFiltersSynthesis;
    fhs.normalize = @pwhNormalizeData;
    fhs.denormalize = @pwhDeNormalizeData;
    fhs.enforce_equal_area = 0;
    fhs.normalization_scaling_primary = @pwhNormalizationScalingFunctionPrimary;
    fhs.normalization_scaling_dual = @pwhNormalizationScalingFunctionDual;    
    fhs.approx = @getWaveletCoeffs;

  elseif( 1 == strcmp( 'npwh', basis))

    fhs.filters_analysis = @npwhFiltersAnalysis;
    fhs.filters_synthesis = @npwhFiltersSynthesis;
    fhs.normalize = @npwhNormalizeData;
    fhs.denormalize = @npwhDeNormalizeData;
    fhs.enforce_equal_area = 0;
    fhs.normalization_scaling_primary= @npwhNormalizationScalingFunctionPrimary;
    fhs.normalization_scaling_dual = @npwhNormalizationScalingFunctionDual;    
    fhs.approx = @getWaveletCoeffs;
    
  elseif( 1 == strcmp( 'bonneau1', basis))

    fhs.filters_analysis = @bonneau1FiltersAnalysis;
    fhs.filters_synthesis = @bonneau1FiltersSynthesis;
    fhs.normalize = @bonneau1NormalizeData;
    fhs.denormalize = @bonneau1DeNormalizeData;
    fhs.enforce_equal_area = 0;
    % fhs.normalization_scaling_primary= rotation not supported
    % fhs.normalization_scaling_dual = rotation not supported   
    fhs.approx = @getWaveletCoeffs;

  elseif( 1 == strcmp( 'bonneau2', basis))

    fhs.filters_analysis = @bonneau2FiltersAnalysis;
    fhs.filters_synthesis = @bonneau2FiltersSynthesis;
    fhs.normalize = @bonneau2NormalizeData;
    fhs.denormalize = @bonneau2DeNormalizeData;
    fhs.enforce_equal_area = 0;
    % fhs.normalization_scaling_primary= rotation not supported
    % fhs.normalization_scaling_dual = rotation not supported   
    fhs.approx = @getWaveletCoeffs;
     
  elseif( 1 == strcmp( 'nielson1', basis))

    fhs.filters_analysis = @nielson1FiltersAnalysis;
    fhs.filters_synthesis = @nielson1FiltersSynthesis;
    fhs.normalize = @nielson1NormalizeData;
    fhs.denormalize = @nielson1DeNormalizeData;
    fhs.enforce_equal_area = 0;
    % fhs.normalization_scaling_primary= rotation not supported
    % fhs.normalization_scaling_dual = rotation not supported   
    fhs.approx = @getWaveletCoeffs;

  elseif( 1 == strcmp( 'nielson2', basis))

    fhs.filters_analysis = @nielson2FiltersAnalysis;
    fhs.filters_synthesis = @nielson2FiltersSynthesis;
    fhs.normalize = @nielson2NormalizeData;
    fhs.denormalize = @nielson2DeNormalizeData;
    fhs.enforce_equal_area = 0;
    % fhs.normalization_scaling_primary= rotation not supported
    % fhs.normalization_scaling_dual = rotation not supported   
    fhs.approx = @getWaveletCoeffs;
   
  else
    error( 'Basis not supported.');
  end
  
end
