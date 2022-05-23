import cv2
import numpy as np
import tensorflow as tf
from PIL import Image

class CNN():
    def __init__(self, model, labels) -> None:
        self.labels = labels
        self.model = tf.keras.models.load_model(model)

    def predict(self, image):
        Image.open(image).save("img.png")

        img = Image.open(image)
        img = np.array(img)[:, :, 3]

        imagecv2 = cv2.resize(img, (28,28))

        predict = self.model.predict(imagecv2.reshape(-1, 28, 28, 1))[0]

        print(predict)

        return self.__get_predicted_label(predict)

    def __get_predicted_label(self, predict):
        max_predict = predict.max();
        print(max_predict);
        if (predict.max() > 0.9):
            return self.labels[np.argmax(predict)]
        return 'Não foi possivel reconhecer esse desenho.'