close all;
clc;
clear;
%批量修改影像名称 1.tif 修改为 20100307_1.tif

path = 'E:\遥感影像样本研究项目\复现数据\裁切\Night_S4\';
folder_list = dir(path);
folder_list(1) = [];
folder_list(1) = []; %去除前两个

for i = 1:length(folder_list)
    fold_name = folder_list(i).name;
    img_path = strcat(path,fold_name,'\');
    img_list = dir(strcat(img_path,'*.tif'));
    for j = 1:length(img_list)
        img_name_old = img_list(j).name;
        img_name_new = strcat(fold_name(18:end),'_',img_name_old);
        movefile(strcat(img_path,img_name_old),strcat(img_path,img_name_new)); %路径写全
    end
end
