close all;
clear;
clc;
int = 0;
num=0;
%�ü����롣�����е�Ӱ����л����ü��������ؿ���й�һ���������NaNֵ�����ؿ�

max_value = 0;
min_value = 0;


for i = 1:1:1
    file_path = 'E:\AMSR_E_Data\Day_S1\';%ԭʼ����
    crop_file_dir = 'E:\AMSR_E_Data\test\day1_crop\'; %���н���ļ���

%% �ü�����
    img_path_list = dir(strcat(file_path,'*.tif'));
    img_num = length(img_path_list);
    tic;
    for j = 1:1:img_num  %��ѭ��������ÿһ��Ӱ��
        strj = num2str(j);
        image_name = img_path_list(j).name;
        imagetime = image_name(18:end-8); %��ȡӰ��ʱ�� �ļ�����AMSRE_LST_merged_20100101_Day.tif ��ȡ20100101
        t1_dir = imagetime;%20100101
        t1len = length(t1_dir);
        t1_time = t1_dir(1:t1len);
        [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
        if  (t1h>=1)&&(t1h<=31) %�����·ݵ�Ҫ��
            image = imread(strcat(file_path,image_name));
            max_value = max(max(image));
            min_value = min(min(image));
            crop_image_directory = strcat(crop_file_dir, image_name(1:end-8));%��Ӧÿ����ļ�·��            
            if exist(crop_image_directory,'dir')
                rmdir(crop_image_directory,'s');
            end
            mkdir(crop_image_directory);   %ÿ��ü�����ļ��� AMSRE_LST_merged_20100101   
            [h,w] = size(image);
            k = 0;
            for x = 1:4:h-23   %����Ϊ4,��Ӱ����ȱʧֵ�����ؿ�����ӦΪ
                for y = 1:4:w-23
                    k=k+1;
                    strk=num2str(k);
                    tmp_img = image(x:x+23, y:y+23);
                    col_0 = all(~isnan(tmp_img));  %������NaN ����1
                    %col_1 = all(tmp_img>218);%������ֵ����218��ȥ���¶Ƚϵ͵��쳣ֵ
                    no_0 = all(col_0);%�������ص��޿�ֵ������1
                    %no_1 = all(col_1);%��������ֵ����218 ����1
                    if  no_0 ==1
                        tmp_img =single(tmp_img-170)/(336-178);  %����һ����
                        str2 = [strk ,'.tif'];
                        crop_image_directory = strcat(crop_image_directory,'\');
                        str2 = strcat(crop_image_directory,str2);
                        imwrite2tif(tmp_img,[],str2,'single','Copyright',...
                            'MRI', 'Compression',1);%���棨�����ڱ��棬24*24���ؿ���޿�ֵ��
                    end
                    %tmp_img =single(tmp_img-213)/130;  %����һ���� 
                end
            end
         end

    end
    toc;
end
