function data = swap(data, sw, swc)

data = data.*sw + data(:,[3 4 1 2]).*swc;