function [ RESULT ] = ch_spr(MASK, THETA_S, THETA_I, THETA_E, RESOL)

THETA = THETA_S:THETA_I:THETA_E;
I = ones(RESOL);    % original image
D = radon(I,THETA); % projection data

%%
for i = 1:size(MASK,3)    
    D_u = D .* MASK(:,:,i);
    recon_I_u = iradon(D_u, THETA, RESOL);
    frequency_under = (1/sqrt(length(recon_I_u(:)))) * fftshift(fft2(recon_I_u));
    abs_frequency_under = abs(frequency_under);
    B = sort(abs_frequency_under(:),'descend');
    RESULT(i) = B(2)/B(1);
end

end