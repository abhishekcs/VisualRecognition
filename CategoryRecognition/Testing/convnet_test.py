#!/usr/bin/python
# -*- coding: utf-8 -*-
#Author: Axel Angel, copyright 2015, license GPLv3.

import sys
import caffe
import numpy as np
#import lmdb
import argparse
from collections import defaultdict


#######################################
### CODE REFERENCES

######################################
### This code is entirely adapted from
### https://gist.github.com/axel-angel/b2af7d980eb217a0af07.
### The path_label_file_reader function has been added
### based on the pattern for lmdb_reader, leveldb_reader


### The part on caffe.io.transformer and actual calling the
### forward function is taken from
### https://github.com/sammy-su/CS381V-caffe-tutorial/
### blob/master/CS381V_features.ipynb



######################################

def path_label_file_reader(fpath):
    parent_dir = fpath.split('/')
    parent_dir_string = '/'.join(parent_dir[:-1])
    test_dir_string = parent_dir_string + '/test_images/'
    with open(fpath) as f:
        content = f.readlines()
    for i, line in enumerate(content):
        img_path, label = line.split(' ')
        label = int(label)
        img = caffe.io.load_image(test_dir_string + img_path)
        yield (i, img, label)

def lmdb_reader(fpath):
    import lmdb
    lmdb_env = lmdb.open(fpath)
    lmdb_txn = lmdb_env.begin()
    lmdb_cursor = lmdb_txn.cursor()

    for key, value in lmdb_cursor:
        datum = caffe.proto.caffe_pb2.Datum()
        datum.ParseFromString(value)
        label = int(datum.label)
        image = caffe.io.datum_to_array(datum).astype(np.uint8)
        yield (key, flat_shape(image), label)

def leveldb_reader(fpath):
    import leveldb
    db = leveldb.LevelDB(fpath)

    for key, value in db.RangeIter():
        datum = caffe.proto.caffe_pb2.Datum()
        datum.ParseFromString(value)
        label = int(datum.label)
        image = caffe.io.datum_to_array(datum).astype(np.uint8)
        yield (key, flat_shape(image), label)

def npz_reader(fpath):
    npz = np.load(fpath)

    xs = npz['arr_0']
    ls = npz['arr_1']

    for i, (x, l) in enumerate(np.array([ xs, ls ]).T):
        yield (i, x, l)



def load_class_names(fpath):
	with open(fpath) as f:
		class_names = f.readlines()
	return class_names


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--proto', type=str, required=True)
    parser.add_argument('--model', type=str, required=True)
    parser.add_argument('--meanfile',type=str,required=True)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--lmdb', type=str, default=None)
    group.add_argument('--leveldb', type=str, default=None)
    group.add_argument('--npz', type=str, default=None)
    group.add_argument('--path-label', type=str, default=None)
    args = parser.parse_args()

    class_names = load_class_names('/work/04009/abhi23/maverick/classnames.txt')
    count = 0
    correct = 0
    matrix = np.zeros((25,25)) # (real,pred) -> int
    labels_set = set()

    net = caffe.Net(args.proto, args.model, caffe.TEST)
    #net = caffe.Classifier(args.proto, args.model,
    #                   mean=mean,
    #                   channel_swap=(2,1,0),
    #                   raw_scale=255,
    #                   image_dims=(256, 256))
    caffe.set_mode_gpu()
    print "args", vars(args)
    if args.lmdb != None:
        reader = lmdb_reader(args.lmdb)
    if args.leveldb != None:
        reader = leveldb_reader(args.leveldb)
    if args.npz != None:
        reader = npz_reader(args.npz)
    if args.path_label != None:
        reader = path_label_file_reader(args.path_label)

    proto_data = open(args.meanfile, 'rb').read()
    a = caffe.io.caffe_pb2.BlobProto.FromString(proto_data)
    mu  = caffe.io.blobproto_to_array(a)[0]

    print 'mean-subtracted values:', zip('BGR', mu)

# create transformer for the input called 'data'
    transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})

    transformer.set_transpose('data', (2,0,1))  # move image channels to outermost dimension
    transformer.set_mean('data', mu)            # subtract the dataset-mean value in each channel
    transformer.set_raw_scale('data', 255)      # rescale from [0, 1] to [0, 255]
    transformer.set_channel_swap('data', (2,1,0))  # swap channels from RGB to BGR
    for i, image, label in reader:
        #image_caffe = image.reshape(1, *image.shape)
	net.blobs['data'].data[...] = transformer.preprocess('data', image)
        out = net.forward()
	print out
	prob = out['prob'][0]
        plabel = int(out['prob'][0].argmax(axis=0))
        #prediction = net.predict([image]) 
        #plabel = int(prediction[0].argmax())

        count += 1
        iscorrect = label == plabel
        correct += (1 if iscorrect else 0)
        matrix[label, :] = matrix[label, :] + prob
        labels_set.update([label, plabel])

        if not iscorrect:
            print("\rError: i=%s, expected %i but predicted %i" \
                    % (i, label, plabel))

        sys.stdout.write("\rAccuracy: %.1f%%" % (100.*correct/count))
        sys.stdout.flush()

    print(", %i/%i corrects" % (correct, count))

    print ""
    print "Confusion matrix:"
    print matrix
    matrix.dump('/work/04009/abhi23/maverick/caffe/logs/conf.mat')


