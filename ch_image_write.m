function ch_image_write(FILE_NAME,FORMAT, DATA, PRECISION)
% save image file to specific format(FORMAT)
%
% @param FILE_NAME : file name to save file
% @param FORMAT : file format ( i.e., '.i', '.s', etc... )
% @param DATA : to be saved image
% @param PRECISION : precision

%
rows = size(DATA,1);
cols = size(DATA,2);

fileID = fopen(strcat(FILE_NAME,FORMAT),'w');
for r = 1:rows
    fwrite(fileID, DATA(r,1:cols), PRECISION);
end
fclose(fileID);

end