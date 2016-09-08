# VisualRecognition
This folder contains the assignments for the course CS381V - Visual Recognition at UT Austin (http://vision.cs.utexas.edu/381V-spring2016/)
## Ransac Based Instance Recognition
VLFEAT path is assumed to be added.
Scene and Template images are assumed to be in the same
directory.

Code Structure

```
1. matchComparison -- (Skeleton code for matchComparison)
	-- matchComparisonHelper (file where the 3 tests are performed)
		-- ransac
			-- applyAffinePars -- (Applying affine transformation)


2. detectObject -- (Skeleton code for detecting object)
	-- detectObjectHelper -- (3 Tests are applied and detection decision is made)
		-- ransac
			-- applyAffinePars
		-- applyAffinePars 
```

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


