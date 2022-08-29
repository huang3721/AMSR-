close all;
clear;
clc;
%�ü����롣�����е�Ӱ����л����ü��������ؿ���й�һ�����޳���NaNֵ�����ؿ�

for i = 1:1:1
    file_path = 'G:\AMSR_E_Data\experiment5\Day_S1_enhance\';%ԭʼ����
    crop_image_directory = 'G:\AMSR_E_Data\experiment5\Day_S1_enhance_clip\'; %���н���ļ���
%% �ü�����
    tic;
    img_path_list = dir(strcat(file_path,'*.tif'));
    img_num = length(img_path_list);
    for j = 1:1:img_num  %��ѭ��������ÿһ��Ӱ��
        strj = num2str(j);
        image_name = img_path_list(j).name; % 20091231_Day_0.tif
        imagetime = image_name(1:end-4); 
        t1_dir = imagetime;%20100101
        t1len = length(t1_dir);
        t1_time = t1_dir(1:t1len);
        [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
        if  (t1h>=1)&&(t1h<=31) %�����·ݵ�Ҫ��
            image = imread(strcat(file_path,image_name));
            add_0 = zeros(1,248);
            img = [image;add_0];
            [h,w] = size(ime);
            k = 0;
            for x = 1:4:h-23   %248�о����ü�
                for y = 1:4:w-23
                    k=k+1;
                    strk=num2str(k);
                    tmp_img = img(x:x+23, y:y+23); % 117��117+23 117��140 ���3��δ���ü������һ��0���ɡ�248*144
                    col_1 = all(tmp_img>0);  %��ת�����ӱ���ֵΪ0,ȥ��0
                    no_1 = all(col_1);
                    col_0 = all(~isnan(tmp_img));  %������NaN ����1
                    no_0 = all(col_0);%�������ص��޿�ֵ������1
                    if  no_0==1&&no_1==1 %��������
                            str2 = strcat(crop_image_directory,image_name(1:end-4),'_',strk,'.tif');
                            tmp_img = (tmp_img-100)/200; % ����һ����
                            imwrite2tif(tmp_img,[],str2,'single','Copyright',...
                               'MRI', 'Compression',1);
                            disp(str2)
                     end
                end
            end
        end
    end
    toc;
end
