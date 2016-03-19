import sys
from subprocess import call

class_paths_file = sys.argv[1]
data_root = sys.argv[2]
path_label_file_path = sys.argv[3]

path_label_pairs = []

with open(class_paths_file) as f:
	lines = f.readlines()
	print len(lines)
	class_label = 0
	for line in lines:
		line = line.strip()
		list_of_paths = line.split(',')
		first_path = list_of_paths[0]
		class_id = first_path.split('/')[6]
		class_input_directory = '/'.join(first_path.split('/')[:7])

		path_label_pairs_for_given_class = []
		for j, path in enumerate(list_of_paths):
			image_path = path.split('/')[7]
			path_label_pairs.append((class_id + '/' + image_path, class_label))
		path_label_pairs.extend(path_label_pairs_for_given_class)
		class_label = class_label + 1
		print class_label


with open(path_label_file_path,'w') as f:
	for path_label_pair in path_label_pairs:
		f.write(str(path_label_pair[0]) + ' ' + str(path_label_pair[1]) + '\n')