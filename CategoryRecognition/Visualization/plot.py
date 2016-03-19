import numpy as np
import matplotlib.pyplot as plt
def plot_confusion_matrix(cm, target_names, title='Confusion matrix', cmap=plt.cm.Reds):
    plt.imshow(cm, interpolation='nearest', cmap=cmap, aspect='auto')
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(target_names))
    plt.xticks(tick_marks, target_names, rotation=90)
    plt.yticks(tick_marks, target_names)
    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()


def load_class_names(fpath):
    class_names = []
    with open(fpath) as f:
            lines  = f.readlines()
            for line in lines:
            	class_names.append(line.split(',')[0])
    return class_names




class_names = load_class_names('classnames.txt')
mat = np.load('conf.mat')
mat = mat /20
plot_confusion_matrix(mat, class_names)

d = np.diagonal(mat).copy()
classes_by_accuracy = [i[0] for i in sorted(enumerate(d), key=lambda x:x[1])]
