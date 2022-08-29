close all;
clear;
clc;
%
file_path = 'E:\AMSR_E_Data\test\day1_crop\AMSRE_LST_merged_20091231\';   %批量拼接重建后小块图像
file_path_list  = dir(strcat(file_path,'*.tif'));
file_num = length(file_path_list);

for q1=1:1:file_num
    file_name = file_path_list(q1).name;% 每一天？
    subpath=strcat(file_path, file_name, '\');
    emptypath='F:\zhan\Landsat\cropped_empty20\2001_313_09nov\channel4';%含空值影像
    pinjiename=strcat('E:\AMSR_E_Data\test\day_mosaic\', file_name, '_Day.tif');%输出名字

    length=143;%原图像长度
    width=248;%原图像宽度
    step=4;%切割时步长
    size=24;%切割图像大小

    subimgs=dir(strcat(subpath,'*.tif'));%融合影像
    emptyimgs=dir(strcat(emptypath,'*.tif'));%含空值影像

    length_num=0;
    f_length=0;
    f_width=0;

    for f_length=1:step:length-size+1   %计算在长度方向、宽度方向裁切的个数
        length_num=length_num+1;
        width_num=0;
        for f_width=1:step:width-size+1
           width_num=width_num+1;
        end
    end

    f_length=f_length+size-1;%拼接以后的长宽
    f_width=f_width+size-1;

    imgname=zeros(length_num+2,width_num+2);%图像名称与在原图像中位置一一对应，并且扩充两行两列?
    imgname1=reshape(1:length_num*width_num,width_num,length_num);
    imgname1=imgname1';
    imgname(2:length_num+1,2:width_num+1)=imgname1;
    imgname(1,:)=30000+(1:width_num+2);
    imgname(length_num+2,:)=40000+(1:width_num+2);
    imgname(2:length_num+1,1)=50000+(1:length_num);
    imgname(2:length_num+1,width_num+2)=60000+(1:length_num);

    wd = zeros(f_length,f_width); 
    
    wdata = Tiff(strcat(pinjiename),'w');%创建拼接图像
    wdata.setTag('ImageLength',f_length);%设置头文件
    wdata.setTag('ImageWidth', f_width);
    wdata.setTag('Photometric',1);%颜色空间解释方式
    wdata.setTag('BitsPerSample', 64);
    wdata.setTag('SamplesPerPixel', 1);
    wdata.setTag('TileWidth', 16);
    wdata.setTag('TileLength', 16);
    wdata.setTag('SampleFormat', Tiff.SampleFormat.IEEEFP);%设置数据类型
    wdata.setTag('Compression', 1);
    wdata.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    wdata.setTag('Software', 'MATLAB');
    
    for i=2:length_num+1%读取预测影像和含空值影像
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
    for i=2:length_num+1%补充第一列和最后一列的影像
        eval(['rimg_',num2str(imgname(i,1)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(i,1)),'(:,size/2+1:size)=rimg_',num2str(imgname(i,2)),'(:,1:size/2);'])
        eval(['rimg_',num2str(imgname(i,width_num+2)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(i,width_num+2)),'(:,1:size/2)=rimg_',num2str(imgname(i,width_num+1)),'(:,size/2+1:size);'])
    end
    for j=2:width_num+1%补充第一行和最后一行的影像
        eval(['rimg_',num2str(imgname(1,j)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(1,j)),'(size/2+1:size,:)=rimg_',num2str(imgname(2,j)),'(1:size/2,:);'])
        eval(['rimg_',num2str(imgname(length_num+2,j)),'=zeros(size,size);'])
        eval(['rimg_',num2str(imgname(length_num+2,j)),'(1:size/2,:)=rimg_',num2str(imgname(length_num+1,j)),'(size/2+1:size,:);'])
    end
    %补充四个角落的影像
    eval(['rimg_',num2str(imgname(1,1)),'(size/2+1:size,size/2+1:size)=rimg_',num2str(imgname(2,2)),'(1:size/2,1:size/2);'])
    eval(['rimg_',num2str(imgname(length_num+2,1)),'(1:size/2,size/2+1:size)=rimg_',num2str(imgname(length_num+1,2)),'(size/2+1:size,1:size/2);'])
    eval(['rimg_',num2str(imgname(1,width_num+2)),'(size/2+1:size,1:size/2)=rimg_',num2str(imgname(2,width_num+1)),'(1:size/2,size/2+1:size);'])
    eval(['rimg_',num2str(imgname(length_num+2,width_num+2)),'(1:size/2,1:size/2)=rimg_',num2str(imgname(length_num+1,width_num+1)),'(size/2+1:size,size/2+1:size);'])
    weight=(0:size-step-1);%设置权重
    weight=weight/(size-step-1);
    weight1=weight;
    for m=1:size-step-1
        weight=[weight weight1];
    end
    weight=reshape(weight,size-step,size-step);%上下加权的权重
    weight2=weight';%左右加权的权重
    i=1;
    for l=1:step:length-size+1+step%拼接
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



        
        
    
    

