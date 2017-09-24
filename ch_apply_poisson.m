function [ NOISE_DATA, NOISE_RATIO ] = ch_apply_poisson( DATA ,SCALE_FACTOR )

if nargin < 2
    SCALE_FACTOR = 1;
end

SCALE = 1;

switch class(DATA)
    case 'double'
        % double
        SCALE = 1e12;
    case 'single'
        % single
        SCALE = 1e6;
    otherwise
        % uint8 or uint 16
        SCALE = 1;
end

% add poisson noise
TMP = SCALE * SCALE_FACTOR * imnoise( DATA / (SCALE * SCALE_FACTOR),'poisson');
TMP = TMP / sum(TMP(:));
TMP = TMP * sum(DATA(:));
NOISE_DATA = TMP;

% calculate poisson noise ratio
NOISE_RATIO = sum(sum(abs(DATA - TMP))) / sum(DATA(:)) * 100;

end