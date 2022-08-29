close all;
clc;
clear;

image_path='G:\AMSR_E_Data\experiment5\Day_S1_345\';
out_path ='G:\AMSR_E_Data\experiment5\Day_S1_enhance\';

%��0�ȿ�ʼ,ÿ��3����תһ�� 
for degree =0:6:360
     img_path_list = dir(strcat(image_path, '*.tif'));
     img_num = length(img_path_list);
     % ��������Ӱ��
     for j =1:1:img_num
        image_name = img_path_list(j).name; 
        image = imread(strcat(image_path,image_name));
        image_1=imrotate(image,degree ,'nearest');  % ��ת�����䱳��ֵΪ0
        str2=strcat(out_path ,image_name(18:end-4),'_',num2str(degree), '.tif' );
        imwrite2tif(image_1 ,[],str2,'single','Copyright','MRI', 'Compression',1);
     end
end





 
