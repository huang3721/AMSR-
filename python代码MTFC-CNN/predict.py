from PIL import Image
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt

'''
注意读取文件的排序对应问题 get_file_name get_data
注意使用掩膜，重建区域+原始T2影像
'''
from utils import *
from model import *

t1_path = 'G:/AMSR_LST_China/Day_S1_crop/20100228/all_chazhi/'
t2_path = 'G:/AMSR_LST_China/Day_S1_crop/20100301/all_queshi/'
t3_path = 'G:/AMSR_LST_China/Day_S1_crop/20100302/all_chazhi/'

label_path = 'G:/AMSR_LST_China/Day_S1_crop/20100301/all_chazhi/'
out_path = 'G:/AMSR_LST_China/Day_S1_crop/20100301/all_pred/'

checkpoint_save_path = "./checkpoint/07.ckpt"

t1, t2, t3, label = get_data(t1_path, t2_path, t3_path, label_path)

# input layer
concat_1 = tf.concat([t1, t3], 3)  # [1,24,24,2]
add_1 = tf.concat([concat_1, t2], 3)  # [1,24,24,2] + [1,24,24,1] =  [1,24,24,3]
add_2 = concat_1 + t2  # [1,24,24,2]
test = tf.concat([add_1, add_2], 3)  # [1,24,24,5] # 输入模型尺寸
test_img = np.array(test)

model = MTFC_model()
model.load_weights(checkpoint_save_path)

result = model.predict(test_img)  # (,24,24,1)

f_list = os.listdir(t2_path)
f_list.sort(key=lambda x:int(x[:-4]))


# 保存预测图像
for i in range(len(result)):
    # 使用掩膜!  T2影像进行掩膜
    name = out_path + f_list[i]
    pred_img = result[i]
    t2_img = t2[i]
    np.where(t2_img>0,1,0)  # 制作掩膜,缺失部分为0,无缺失部分为1
    img = (1-t2_img)*pred_img + t2[i]*t2_img
    cv.imwrite(name,img)




