import os
import matplotlib.pyplot as plt
import cv2 as cv
import numpy as np
from shutil import copyfile
import shutil

def get_data(t1_path,t2_path,t3_path,label_path):
    """获取样本集数据T1 T2 T3 label"""
    img_size = 24

    t1_names = get_filename(t1_path, '.tif')
    t2_names = get_filename(t2_path, '.tif')
    t3_names = get_filename(t3_path, '.tif')
    label_names = get_filename(label_path, '.tif')

    T1 = []
    T2 = []
    T3 = []
    Label = []


    num = len(label_names)
    for i in range(num):
        t1_name = t1_names[i]
        t2_name = t2_names[i]
        t3_name = t3_names[i]
        label_name = label_names[i]

        # 读入数据维度(24,24)
        t1_img = cv.imread(t1_name, cv.IMREAD_UNCHANGED)
        t2_img = cv.imread(t2_name, cv.IMREAD_UNCHANGED)
        t3_img = cv.imread(t3_name, cv.IMREAD_UNCHANGED)
        label_img = cv.imread(label_name, cv.IMREAD_UNCHANGED)
        t1_img = t1_img.reshape([img_size, img_size,1])
        t2_img = t2_img.reshape([img_size, img_size, 1])
        t3_img = t3_img.reshape([img_size, img_size, 1])
        label_img = label_img.reshape([img_size, img_size, 1])

        T1.append(t1_img)
        T2.append(t2_img)
        T3.append(t3_img)
        Label.append(label_img)

    T1 = np.array(T1)
    T2 = np.array(T2)
    T3 = np.array(T3)
    Label = np.array(Label)

    # (num,24,24,1)
    return T1,T2,T3,Label


def get_filename(path,suffix):
    """获取指定目录下指定后缀名的文件"""
    file_list = []
    f_list = os.listdir(path)
    f_list.sort(key=lambda x:int(x[:-4])) # .tif   注意，这里使用数字命名时用 int进行排序；其他用str排序
    for file in f_list:
        if os.path.splitext(file)[1] == suffix:
            file_list.append(os.path.join(path,file))
    return file_list

def test_data():
    input1_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T1/'
    input2_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T2/'
    input3_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T3/'
    input_label_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T2_label/'
    t1_clip_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T1_clip/'
    t3_clip_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T3_clip/'

    target_T1_path = 'G:/AMSR_E_Data/test6/T1/'
    target_T2_path = 'G:/AMSR_E_Data/test6/T2/'
    target_T3_path = 'G:/AMSR_E_Data/test6/T3/'
    target_label_path = 'G:/AMSR_E_Data/test6/T2_label/'
    target_T1__clip_path = 'G:/AMSR_E_Data/test6/T1_clip/'
    target_T3__clip_path = 'G:/AMSR_E_Data/test6/T3_clip/'

    mask1_path = 'E:/AMSR_E_Data/mask/'

    t1_names = os.listdir(input1_path)
    t2_names = os.listdir(input2_path)
    t3_names = os.listdir(input3_path)
    tlabel = os.listdir(input_label_path)
    t1_clip_names = os.listdir(t1_clip_path)
    t3_clip_names = os.listdir(t3_clip_path)


    mask_names = os.listdir(mask1_path)


    sum = len(t1_names)
    n = 0
    #
    t1_names.sort(key=lambda x: str(x[:-4]))
    t2_names.sort(key=lambda x: str(x[:-4]))
    t3_names.sort(key=lambda x: str(x[:-4]))
    tlabel.sort(key=lambda x: str(x[:-4]))
    t1_clip_names.sort(key=lambda x: str(x[:-4]))
    t3_clip_names.sort(key=lambda x: str(x[:-4]))

    #数据打乱
    # np.random.seed(37)
    # np.random.shuffle(t1_names)
    # np.random.seed(37)
    # np.random.shuffle(t2_names)
    # np.random.seed(37)
    # np.random.shuffle(t3_names)
    # np.random.seed(37)
    # np.random.shuffle(tlabel)
    # np.random.seed(37)
    # np.random.shuffle(t1_clip_names)
    # np.random.seed(37)
    # np.random.shuffle(t3_clip_names)

    for i in range(0,sum,10):
        t1_name = t1_names[i]
        t2_name = t2_names[i]
        t3_name = t3_names[i]
        tlabel_name = tlabel[i]
        t1_clip_name = t1_clip_names[i]
        t3_clip_name = t3_clip_names[i]


        print(n+1,t1_name,'\t',t2_name,'\t',t3_name,'\t',tlabel_name)
        print(n+1,t1_clip_name, '-*-', t3_clip_name)
        n=n+1


        # shutil.move(input1_path+t1_name,target_T1_path+t1_name)
        # shutil.move(input2_path+t2_name,target_T2_path+t2_name)
        # shutil.move(input3_path+t3_name,target_T3_path+t3_name)
        # shutil.move(input_label_path+tlabel_name,target_label_path+tlabel_name)
        #
        # shutil.move(t1_clip_path+t1_clip_name,target_T1__clip_path+t1_clip_name)
        # shutil.move(t3_clip_path+t3_clip_name,target_T3__clip_path+t3_clip_name)

        # copyfile(input1_path+t1_name,target_T1_path+t1_name)
        # copyfile(input2_path+t2_name,target_T2_path+t2_name)
        # copyfile(input3_path+t3_name,target_T3_path+t3_name)
        # copyfile(input_label_path+tlabel_name,target_label_path+tlabel_name)

if __name__ == '__main__':
    test_data()
