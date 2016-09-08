# VisualRecognition
This folder contains the assignments for the course CS381V - Visual Recognition at UT Austin

## Category Recognition
### InputPreprocessing
This contains matlab scripts for writting all the given matlab objects
as files ( classnames, extraTrainImNames etc)

	createData.py
	This copies out the relevant class folders (of images) into a local directory.
	It also creates the path labels file (each line contains path of image and its class label)


### Testing
convnet_test.py
	Apply forward function on test images, compute confusion matrix
	Entirely adapted from

	https://gist.github.com/axel-angel/b2af7d980eb217a0af07.
	https://github.com/sammy-su/CS381V-caffe-tutorial/
	blob/master/CS381V_features.ipynb


### Visualization
	plot.py
		Plotting the confusion matrix.
		Based on 
		http://scikit-learn.org/stable/auto_examples/model_selection/plot_confusion_matrix.html


