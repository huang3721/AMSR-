close all;
clc;
clear;
%�����ƶ�tifӰ��

path = 'E:\ң��Ӱ�������о���Ŀ\��������\����\Night_S4\';
target_path = 'E:\ң��Ӱ�������о���Ŀ\��������\����\Night_S4_All\';
folder_list = dir(path);
folder_list(1) = [];
folder_list(1) = []; %ȥ��ǰ����

%����ÿһ��·���µ��ļ���
for i = 1:length(folder_list)
    fold_name = folder_list(i).name;
    img_path = strcat(path,fold_name,'\');
    img_list = dir(strcat(img_path,'*.tif'));
    %�������ļ����е�ÿһ��Ӱ��
    for j = 1:length(img_list)
        img_name_path = strcat(img_path,img_list(j).name);
        copyfile(img_name_path,target_path)
    end
end