close all;
clc;
clear;
%批量移动tif影像

path = 'E:\遥感影像样本研究项目\复现数据\裁切\Night_S4\';
target_path = 'E:\遥感影像样本研究项目\复现数据\裁切\Night_S4_All\';
folder_list = dir(path);
folder_list(1) = [];
folder_list(1) = []; %去除前两个

%遍历每一个路径下的文件夹
for i = 1:length(folder_list)
    fold_name = folder_list(i).name;
    img_path = strcat(path,fold_name,'\');
    img_list = dir(strcat(img_path,'*.tif'));
    %遍历子文件夹中的每一幅影像
    for j = 1:length(img_list)
        img_name_path = strcat(img_path,img_list(j).name);
        copyfile(img_name_path,target_path)
    end
end