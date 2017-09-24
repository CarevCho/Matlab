function [ OVERLAP ] = ch_overlap ( MASK_1 , MASK_2 )

input_1 = MASK_1;
input_2 = MASK_2;

result = input_1 & input_2;

OVERLAP = sum(sum(result))/sum(sum(input_1))*100;