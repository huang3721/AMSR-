close all;
clear;
clc;
allimgs_path = 'E:\ң��Ӱ�������о���Ŀ\΢���ؽ��������\AMSR-Eԭʼ����\Day\';
allimgs = dir(strcat(allimgs_path,'*.tif'));

out_path = 'G:\AMSR_E_Data\Day_Normalization2\';

for i=1:length(allimgs)
    imgname = strcat(allimgs_path,allimgs(i).name);
    img = imread(imgname);
    max_value = max(max(img));
    min_value = min(min(img));
    out_name = strcat(out_path,allimgs(i).name);
    % ������һ���ķ�ʽ
    %img1 = (img-(min_value-1))/(max_value-min_value); % minmax��׼��  0-1,�������0�ĳ���
    img1 = (img-100)/200; 
    imwrite2tif(img1 ,[],out_name,'single','Copyright','MRI', 'Compression',1);
    disp(i)
    disp(max(max(img1)));
    disp(min(min(img1)));
end

