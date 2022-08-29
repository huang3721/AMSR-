close all;
clc;
clear;
%²Ã¼ôÑÚÄ¤

path = 'G:\AMSR_LST_China\Day_Normalization\AMSRE_LST_merged_20091231_Day.tif';
target_path = 'E:\delete\test2\';
image = imread(path);
[h,w] = size(image);

k=0;
for x=1:24:h-23
    for y=1:24:w-23
        k = k + 1;
        tmp_img = image(x:x+23, y:y+23);
        crop_path = strcat(target_path,num2str(k),'.tif');
        imwrite2tif(tmp_img,[],crop_path,'single','Copyright', 'MRI', 'Compression',1);
    end
end
