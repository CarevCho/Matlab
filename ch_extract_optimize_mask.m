function [ result ] = ch_extract_optimize_mask( REF, MASK, OVERLAP_RATIO ,MASK_NUMBER)
%% Select sampling mask cosidering overlap ratio.
%
%
%
if nargin < 5 , MASK_NUMBER = 1;        end
if nargin < 4 , OVERLAP_RATIO = 0.3;    end

m_ref_mask = REF;
m_mask = MASK;
m_extract_number = MASK_NUMBER;

m_ref_mask(find(m_ref_mask~=0)) = 1;
m_accept_count = uint32(sum(m_ref_mask(:)) * OVERLAP_RATIO);

if size(m_mask,3) < m_extract_number
    result = -1;
else
    overlap_count = zeros(size(1,m_extract_number));    % for count overlap
    
    for i = 1:size(m_mask,3)
        overlap_mask = m_ref_mask & m_mask(:,:,i)
        overlap_mask(find(overlap_mask~=0)) = 1;
        if sum(overlap_mask(:)) < m_accept_count
            result(:,:,1) = m_mask(:,:,i);
            break;
        end
    end
    
    if m_extract_number == 1
    else
        for i = 1:size(m_mask,3)
            
           for j=1:size(result,3)
               
        end
        
    end
    
    result = 1;
    end

