import tensorflow as tf
from tensorflow.keras.layers import *


# 注意力机制
def attention_module(upconv, skipconv):
    input1 = tf.sigmoid(upconv)
    outputs = tf.multiply(skipconv, input1)
    outputs = tf.add(upconv, outputs)
    return outputs


def MTFC_model():
    input = Input(shape=(24, 24, 5))
    # L1
    # 卷积层1-1
    conv1_1 = Conv2D(64, 3, padding='same')(input)  # (24,24,64)
    conv1_1 = BatchNormalization()(conv1_1)
    conv1_1 = ReLU()(conv1_1)
    # 卷积层1-2
    conv1_2 = Conv2D(64, 3, padding='same')(conv1_1)  # (24,24,64)
    conv1_2 = BatchNormalization()(conv1_2)
    conv1_2 = ReLU()(conv1_2)
    # 池化
    average_pool1 = AveragePooling2D(pool_size=[2, 2], strides=[2, 2], padding='SAME')(conv1_2)  # (12,12,64)

    # L2
    # 卷积层2-1
    conv2_1 = Conv2D(128, 3, padding='same')(average_pool1)  # (12,12,128)
    conv2_1 = BatchNormalization()(conv2_1)
    conv2_1 = ReLU()(conv2_1)
    # 卷积层2-2
    conv2_2 = Conv2D(128, 3, padding='same')(conv2_1)  # (12,12,128)
    conv2_2 = BatchNormalization()(conv2_2)
    conv2_2 = ReLU()(conv2_2)
    # 池化
    average_pool2 = AveragePooling2D(pool_size=[2, 2], strides=[2, 2], padding='SAME')(conv2_2)  # (6,6,128)

    # L3
    # 卷积层3-1
    conv3_1 = Conv2D(256, 3, padding='same')(average_pool2)  # (6,6,256)
    conv3_1 = BatchNormalization()(conv3_1)
    conv3_1 = ReLU()(conv3_1)
    # 卷积层3-2
    conv3_2 = Conv2D(256, 3, padding='same')(conv3_1)  # (6,6,256)
    conv3_2 = BatchNormalization()(conv3_2)
    conv3_2 = ReLU()(conv3_2)
    # 池化
    average_pool3 = AveragePooling2D(pool_size=[2, 2], strides=[2, 2], padding='SAME')(conv3_2)  # (3,3,256)

    # L4
    # 卷积层4-1
    conv4_1 = Conv2D(512, 3, padding='same')(average_pool3)  # (3,3,512)
    conv4_1 = BatchNormalization()(conv4_1)
    conv4_1 = ReLU()(conv4_1)
    # 卷积层4-2
    conv4_2 = Conv2D(512, 3, padding='same')(conv4_1)  # (3,3,512)
    conv4_2 = BatchNormalization()(conv4_2)
    conv4_2 = ReLU()(conv4_2)

    # L5
    conv5_1 = Conv2DTranspose(filters=256, kernel_size=2, strides=2, padding='valid')(conv4_2)  # (6,6,256)
    conv5_2 = attention_module(conv5_1, conv3_2)
    conv5_2 = Conv2D(256, 3, padding='same')(conv5_2)
    conv5_2 = BatchNormalization()(conv5_2)
    conv5_2 = ReLU()(conv5_2)
    conv5_3 = Conv2D(256, 3, padding='same')(conv5_2)
    conv5_3 = BatchNormalization()(conv5_3)
    conv5_3 = ReLU()(conv5_3)

    # L6
    conv6_1 = Conv2DTranspose(filters=128, kernel_size=2, strides=2, padding='valid')(conv5_3)  # (12,12,128)
    conv6_2 = attention_module(conv6_1, conv2_2)
    conv6_2 = Conv2D(128, 3, padding='same')(conv6_2)
    conv6_2 = BatchNormalization()(conv6_2)
    conv6_2 = ReLU()(conv6_2)
    conv6_3 = Conv2D(128, 3, padding='same')(conv6_2)
    conv6_3 = BatchNormalization()(conv6_3)
    conv6_3 = ReLU()(conv6_3)

    # L7
    conv7_1 = Conv2DTranspose(filters=64, kernel_size=2, strides=2, padding='valid')(conv6_3)  # (24,24,64)
    conv7_2 = attention_module(conv7_1, conv1_2)
    conv7_2 = Conv2D(64, 3, padding='same')(conv7_2)
    conv7_2 = BatchNormalization()(conv7_2)
    conv7_2 = ReLU()(conv7_2)
    conv7_3 = Conv2D(64, 3, padding='same')(conv7_2)
    conv7_3 = BatchNormalization()(conv7_3)
    conv7_3 = ReLU()(conv7_3)

    # 最后两次卷积
    conv7_4 = Conv2D(32, 3, padding='same')(conv7_3)  # (24,24,32)
    conv7_4 = BatchNormalization()(conv7_4)
    conv7_4 = ReLU()(conv7_4)
    conv7_5 = Conv2D(1, 3, padding='same')(conv7_4)  # (24,24,1)

    return tf.keras.Model(input, conv7_5)


if __name__ == '__main__':
    model = MTFC_model()
    model.summary()
