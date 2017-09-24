function [result] = ch_image_read ( FILE_NAME, FORMAT, PRECISION, ROWS, COLS)
% Read image from file
%
% @param FILE_NAME : file to read
% @param FORMAT : file format
% @param PRECISION : precision
% @param ROWS : data rows
% @param COLS : data columns

rows = ROWS;
cols = COLS;

fileID = fopen(strcat(FILE_NAME,FORMAT),'r');
for i =1:rows
    result(i,:) = fread(fileID, cols , PRECISION);
end
fclose(fileID);

end
