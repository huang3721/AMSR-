close all;
clc;
clear;
%�����޸�Ӱ������ 1.tif �޸�Ϊ 20100307_1.tif

path = 'E:\ң��Ӱ�������о���Ŀ\��������\����\Night_S4\';
folder_list = dir(path);
folder_list(1) = [];
folder_list(1) = []; %ȥ��ǰ����

for i = 1:length(folder_list)
    fold_name = folder_list(i).name;
    img_path = strcat(path,fold_name,'\');
    img_list = dir(strcat(img_path,'*.tif'));
    for j = 1:length(img_list)
        img_name_old = img_list(j).name;
        img_name_new = strcat(fold_name(18:end),'_',img_name_old);
        movefile(strcat(img_path,img_name_old),strcat(img_path,img_name_new)); %·��дȫ
    end
end
