close all;
clc;
clear;
% 
mask = imread('F:\MODIS-china\sample.tif');
file_path = ['G:\Real_experient_Night\Night_Summer\AMSRE_Summer_Night_data\'];
out_path = ['G:\Real_experient_Night\Night_Summer\AMSRE_Summer_Night_data_Chazhi\'];

if exist(out_path,'dir')
        rmdir(out_path,'s');
end
mkdir(out_path);

img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);

for i=1:1:img_num
    image_name = img_path_list(i).name; 
    image = imread(strcat(file_path,image_name)); 
    image=double(image);
    image(image>600)=nan;%转化0值为nan值
    s=size(image);
    valid=find(~isnan(image));
    [i,j]=ind2sub(s,valid);
    v=image(valid);
    [ii,jj]=ndgrid(1:s(1),1:s(2));
    img=griddata(i,j,v,ii,jj,'nearest');
    str2 = strcat(out_path , image_name);
    imwrite2tif(img,[],str2,'single','Copyright','MRI', 'Compression',1);
end
% 


