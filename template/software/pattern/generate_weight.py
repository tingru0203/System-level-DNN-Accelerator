import numpy as np                

path = '../../../weight/'
name_list = ["c1.conv.weight", "c3.conv.weight", "c5.conv.weight", "f6.fc.weight", "output.fc.weight", "output.fc.bias"]
mask_8 = 0xFF
mask_32 = 0xFFFFFFFF
weights = np.array([])

# conv1, conv2
for name in name_list[:2]:
    w = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(0, len(w), 5):
        weights = np.append(weights, "0x" + format(np.bitwise_and(w[i+3], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i+2], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i+1], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i], mask_8), '0>2X'))
        weights = np.append(weights, "0x000000" + 
                                     format(np.bitwise_and(w[i+4], mask_8), '0>2X'))

# conv3, fc1, fc2
for name in name_list[2:-1]:
    w = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(0, len(w), 4):
        weights = np.append(weights, "0x" + format(np.bitwise_and(w[i+3], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i+2], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i+1], mask_8), '0>2X') + 
                                     format(np.bitwise_and(w[i], mask_8), '0>2X'))

# bias
for name in name_list[-1:]:
    w = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(len(w)):
        weights = np.append(weights, "0x" + format(np.bitwise_and(w[i], mask_32), '0>8X'))

for i in weights:
    assert len(i) == 10

print(weights[:10])
print(weights.shape)

np.savetxt('weight.h', [weights.astype(str)], 
            delimiter=',\n', header='int32_t weight[] = {', footer='}', comments='', fmt="%10s")