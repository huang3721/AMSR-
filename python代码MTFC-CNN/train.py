import numpy as np
from utils import *
from model import *
from sklearn.metrics import r2_score
t1_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T1/'
t2_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T2/'
t3_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T3/'
label_path = 'G:/AMSR_E_Data/experiment6/Day_S1_T2_label/'

checkpoint_save_path = "./checkpoint/07.ckpt"

t1, t2, t3, label = get_data(t1_path, t2_path, t3_path, label_path)
concat_1 = tf.concat([t1, t3], 3)  # [1,24,24,2]
add_1 = tf.concat([concat_1, t2], 3)  # [1,24,24,2] + [1,24,24,1] =  [1,24,24,3]
add_2 = concat_1 + t2  # [1,24,24,2]
# 输入层 c
train = tf.concat([add_1, add_2], 3)  # [1,24,24,5] # 输入模型尺寸
train_img = np.array(train)
label_img = label

np.random.seed(37)
np.random.shuffle(train_img)
np.random.seed(37)
np.random.shuffle(label_img)

model = MTFC_model()

# 自定义函数需要返回tensor
# 自定义acc函数 R2
# r2_score
def my_acc(y_true,y_pred):
    mse = tf.math.reduce_mean(tf.square(y_true - y_pred))
    var = tf.math.reduce_mean(tf.square(tf.math.reduce_mean(y_true) - y_pred))
    r2 = 1 - mse/var
    return r2

def custom_mean_squared_error(y_true, y_pred):
    return tf.math.reduce_mean(tf.square(y_true - y_pred))

# 自定义损失函数 RMSE
def my_loss(y_true,y_pred):
    rmse_loss = tf.reduce_mean(tf.sqrt(tf.square(tf.subtract(y_true, y_pred)))) # 损失函数计算 RMSE
    return rmse_loss


model.compile(optimizer='adam',
              loss='mse',
              metrics=[my_acc])
# 断点续训
if os.path.exists(checkpoint_save_path + '.index'):
    print('-------------load the model-----------------')
    model.load_weights(checkpoint_save_path)


cp_callback = tf.keras.callbacks.ModelCheckpoint(filepath=checkpoint_save_path,
                                                 save_weights_only=True,
                                                 save_best_only=True)

history = model.fit(train_img, label_img, batch_size=64, epochs=300, validation_split=0.1, validation_freq=1,
                    callbacks=[cp_callback])

model.summary()
print(history.history)

###############################################    show   ###############################################
# 显示训练集和验证集的acc和loss曲线
acc = history.history['my_acc']
val_acc = history.history['val_my_acc']
loss = history.history['loss']
val_loss = history.history['val_loss']

plt.subplot(1, 2, 1)
plt.plot(acc, label='Training Accuracy')
plt.plot(val_acc, label='Validation Accuracy')
plt.title('Training and Validation Accuracy')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(loss, label='Training Loss-MSE')
plt.plot(val_loss, label='Validation Loss')
plt.title('Training and Validation Loss')
plt.legend()
plt.show()