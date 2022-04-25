import numpy as np                

path = '../../../img/img0/'
name_list = ["c1/input", "c3/input", "c5/input", "f6/input", "output/input", "output/output"]
mask_8 = 0xFF
mask_32 = 0xFFFFFFFF
activs = np.array([])

# input
for name in name_list[0:1]:
    a = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(0, len(a), 4):
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i+3], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+2], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+1], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i], mask_8), '0>2X'))
        

# conv1
for name in name_list[1:2]:
    a = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(0, len(a), 14):
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i+3], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+2], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+1], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i], mask_8), '0>2X'))
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i+7], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+6], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+5], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+4], mask_8), '0>2X'))
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i+11], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+10], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+9], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+8], mask_8), '0>2X'))
        activs = np.append(activs, "0x0000" +
                                    format(np.bitwise_and(a[i+13], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+12], mask_8), '0>2X'))

# conv2, conv3, fc1
for name in name_list[2:-1]:
    a = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(0, len(a), 4):
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i+3], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+2], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i+1], mask_8), '0>2X') + 
                                    format(np.bitwise_and(a[i], mask_8), '0>2X'))
# fc2
for name in name_list[-1:]:
    a = np.loadtxt(path+name+".csv", delimiter=',').astype(int)
    for i in range(len(a)):
        activs = np.append(activs, "0x" + format(np.bitwise_and(a[i], mask_32), '0>8X'))

for i in activs:
    assert len(i) == 10

print(activs[:10])
print(activs.shape)

np.savetxt('image00.h', [activs[:256].astype(str)], 
            delimiter=',\n', header='int32_t image[] = {', footer='}', comments='', fmt="%10s")
np.savetxt('golden00.h', [activs.astype(str)], 
            delimiter=',\n', header='int32_t golden[] = {', footer='}', comments='', fmt="%10s")