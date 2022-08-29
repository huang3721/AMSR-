close all;
clc;
clear;

% �������������ļ���
ori_file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(��NaN)\';%ԭʼ����
mask_path = 'G:\AMSR_LST_China\china_mask2.tif'; % 248*144
dir_path = 'G:\AMSR_LST_China\Day_S1_crop\';
out_path = 'G:\AMSR_LST_China\Day_S1_Restruct\';
folder_list = dir(dir_path);
folder_list(1) = [];folder_list(1) = [];

mask = double(imread(mask_path));

for date = 1:length(folder_list)
    img_date = folder_list(date).name;
    img_folder = strcat(dir_path,img_date,'\all_pred\');
    
    oriimg_path = strcat(ori_file_path,'AMSRE_LST_merged_',img_date,'_Day.tif');
    oriimg = double(imread(oriimg_path));
    add_0 = -ones(1,248); % ���һ�м���-1
    T2img = [oriimg;add_0]; % �й�������Ϊ-1��ȱʧֵ����Ϊ0
    
    r1 = 1-T2img./T2img;
    r1(isnan(r1))=1; % ȱʧֵ����Ϊ1 ����Ϊ0
    
    img_list = dir(strcat(img_folder,'*.tif'));
    num = length(img_list);
    nameCell = cell(length(img_list),1);
    for i = 1:length(img_list)
        nameCell{i} = img_list(i).name;
    end
    img_list = sort_nat(nameCell);% ����
    h = 144;
    w = 248;
    result = zeros(h,w);
    n = 1;
    for x=1:4:h-23
        for y=1:4:w-23
            img = double(imread(strcat(img_folder,img_list{n})));
            n = n+1;
            % ������Ҫ����һ����Ȩƴ��
            result(x:x+23,y:y+23) = img;
            if n > num
                break;
            end
        end
        if n > num
            break;
        end
    end
    lst_img = result.*mask.*r1+T2img;
    lst_img(lst_img==-1) = 0;
    lst_img = lst_img*200+100; %�ָ���K��λ
    lst_img(lst_img==100) = 0;
    str = strcat(out_path,img_date,'.tif');
    imwrite2tif(lst_img,[],str,'single','Copyright','MRI', 'Compression',1);
end






