close all;
clc;
clear;

image_path='G:\AMSR_E_Data\experiment5\Day_S1_345\';
out_path ='G:\AMSR_E_Data\experiment5\Day_S1_enhance\';

%从0度开始,每隔3度旋转一次 
for degree =0:6:360
     img_path_list = dir(strcat(image_path, '*.tif'));
     img_num = length(img_path_list);
     % 遍历所有影像
     for j =1:1:img_num
        image_name = img_path_list(j).name; 
        image = imread(strcat(image_path,image_name));
        image_1=imrotate(image,degree ,'nearest');  % 翻转后的填充背景值为0
        str2=strcat(out_path ,image_name(18:end-4),'_',num2str(degree), '.tif' );
        imwrite2tif(image_1 ,[],str2,'single','Copyright','MRI', 'Compression',1);
     end
end





 
