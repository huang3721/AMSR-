close all;
clc;
clear;

% 遍历所有日期文件夹
ori_file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(无NaN)\';%原始数据
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
    add_0 = -ones(1,248); % 最后一行加上-1
    T2img = [oriimg;add_0]; % 中国外区域为-1，缺失值区域为0
    
    r1 = 1-T2img./T2img;
    r1(isnan(r1))=1; % 缺失值区域为1 其余为0
    
    img_list = dir(strcat(img_folder,'*.tif'));
    num = length(img_list);
    nameCell = cell(length(img_list),1);
    for i = 1:length(img_list)
        nameCell{i} = img_list(i).name;
    end
    img_list = sort_nat(nameCell);% 排序
    h = 144;
    w = 248;
    result = zeros(h,w);
    n = 1;
    for x=1:4:h-23
        for y=1:4:w-23
            img = double(imread(strcat(img_folder,img_list{n})));
            n = n+1;
            % 这里需要进行一个加权拼接
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
    lst_img = lst_img*200+100; %恢复到K单位
    lst_img(lst_img==100) = 0;
    str = strcat(out_path,img_date,'.tif');
    imwrite2tif(lst_img,[],str,'single','Copyright','MRI', 'Compression',1);
end






