close all;
clear;
clc;
%
file_path = 'E:\AMSR_E_Data\test\day1_crop\AMSRE_LST_merged_20091231\';   %����ƴ���ؽ���С��ͼ��
file_path_list  = dir(strcat(file_path,'*.tif'));
file_num = length(file_path_list);

for q1=1:1:file_num
    file_name = file_path_list(q1).name;% ÿһ�죿
    subpath=strcat(file_path, file_name, '\');
    emptypath='F:\zhan\Landsat\cropped_empty20\2001_313_09nov\channel4';%����ֵӰ��
    pinjiename=strcat('E:\AMSR_E_Data\test\day_mosaic\', file_name, '_Day.tif');%�������

    length=143;%ԭͼ�񳤶�
    width=248;%ԭͼ����
    step=4;%�и�ʱ����
    size=24;%�и�ͼ���С

    subimgs=dir(strcat(subpath,'*.tif'));%�ں�Ӱ��
    emptyimgs=dir(strcat(emptypath,'*.tif'));%����ֵӰ��

    length_num=0;
    f_length=0;
    f_width=0;

    for f_length=1:step:length-size+1   %�����ڳ��ȷ��򡢿�ȷ�����еĸ���
        length_num=length_num+1;
        width_num=0;
        for f_width=1:step:width-size+1
           width_num=width_num+1;
        end
    end

    f_length=f_length+size-1;%ƴ���Ժ�ĳ���
    f_width=f_width+size-1;

    imgname=zeros(length_num+2,width_num+2);%ͼ����������ԭͼ����λ��һһ��Ӧ������������������?
    imgname1=reshape(1:length_num*width_num,width_num,length_num);
    imgname1=imgname1';
    imgname(2:length_num+1,2:width_num+1)=imgname1;
    imgname(1,:)=30000+(1:width_num+2);
    imgname(length_num+2,:)=40000+(1:width_num+2);
    imgname(2:length_num+1,1)=50000+(1:length_num);
    imgname(2:length_num+1,width_num+2)=60000+(1:length_num);

    wd = zeros(f_length,f_width); 
    
    wdata = Tiff(strcat(pinjiename),'w');%����ƴ��ͼ��
    wdata.setTag('ImageLength',f_length);%����ͷ�ļ�
    wdata.setTag('ImageWidth', f_width);
    wdata.setTag('Photometric',1);%��ɫ�ռ���ͷ�ʽ
    wdata.setTag('BitsPerSample', 64);
    wdata.setTag('SamplesPerPixel', 1);
    wdata.setTag('TileWidth', 16);
    wdata.setTag('TileLength', 16);
    wdata.setTag('SampleFormat', Tiff.SampleFormat.IEEEFP);%������������
    wdata.setTag('Compression', 1);
    wdata.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    wdata.setTag('Software', 'MATLAB');
    
    for i=2:length_num+1%��ȡԤ��Ӱ��ͺ���ֵӰ��
        for j=2:width_num+1
            if exist(strcat('rimg_',num2str(imgname(i,j))))
            elseif ismember(strcat(num2str(imgname(i,j)),'.tif'),{emptyimgs.name})
                rpath=strcat(emptypath,'\',num2str(imgname(i,j)),'.tif');
                eval(['rimg_',num2str(imgname(i,j)),'=imread(rpath);'])
            elseif ismember(strcat(num2str(imgname(i,j)),'.tif'),{subimgs.name})
                fpath = strcat(subpath,'\',num2str(imgname(i,j)),'.tif');
                eval(['rimg_',num2str(imgname(i,j)),'=imread(fpath);'])
            end
        end
    end
    for i=2:length_num+1%�����һ�к����һ�е�Ӱ��
        eval(['rimg_',num2str(imgname(i,1)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(i,1)),'(:,size/2+1:size)=rimg_',num2str(imgname(i,2)),'(:,1:size/2);'])
        eval(['rimg_',num2str(imgname(i,width_num+2)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(i,width_num+2)),'(:,1:size/2)=rimg_',num2str(imgname(i,width_num+1)),'(:,size/2+1:size);'])
    end
    for j=2:width_num+1%�����һ�к����һ�е�Ӱ��
        eval(['rimg_',num2str(imgname(1,j)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(1,j)),'(size/2+1:size,:)=rimg_',num2str(imgname(2,j)),'(1:size/2,:);'])
        eval(['rimg_',num2str(imgname(length_num+2,j)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(length_num+2,j)),'(1:size/2,:)=rimg_',num2str(imgname(length_num+1,j)),'(size/2+1:size,:);'])
    end
    %�����ĸ������Ӱ��
    eval(['rimg_',num2str(imgname(1,1)),'(size/2+1:size,size/2+1:size)=rimg_',num2str(imgname(2,2)),'(1:size/2,1:size/2);'])
    eval(['rimg_',num2str(imgname(length_num+2,1)),'(1:size/2,size/2+1:size)=rimg_',num2str(imgname(length_num+1,2)),'(size/2+1:size,1:size/2);'])
    eval(['rimg_',num2str(imgname(1,width_num+2)),'(size/2+1:size,1:size/2)=rimg_',num2str(imgname(2,width_num+1)),'(1:size/2,size/2+1:size);'])
    eval(['rimg_',num2str(imgname(length_num+2,width_num+2)),'(1:size/2,1:size/2)=rimg_',num2str(imgname(length_num+1,width_num+1)),'(size/2+1:size,size/2+1:size);'])
    weight=(0:size-step-1);%����Ȩ��
    weight=weight/(size-step-1);
    weight1=weight;
    for m=1:size-step-1
        weight=[weight weight1];
    end
    weight=reshape(weight,size-step,size-step);%���¼�Ȩ��Ȩ��
    weight2=weight';%���Ҽ�Ȩ��Ȩ��
    i=1;
    for l=1:step:length-size+1+step%ƴ��
        i=i+1;
        j=1;
        for w=1:step:width-size+1+step
            j=j+1;
            eval(['wd1=rimg_',num2str(imgname(i-1,j-1)),'(size-step+1:size,size-step+1:size).*(1-weight2)+rimg_',num2str(imgname(i-1,j)),'(size-step+1:size,1:size-step).*weight2;'])
            eval(['wd2=rimg_',num2str(imgname(i,j-1)),'(1:size-step,size-step+1:size).*(1-weight2)+rimg_',num2str(imgname(i,j)),'(1:size-step,1:size-step).*weight2;'])
            wd(l:l+step-1,w:w+step-1)=wd1.*(1-weight)+wd2.*weight;
        end
    end
    wdata.write(wd);
    wdata.close(); 
end



        
        
    
    

