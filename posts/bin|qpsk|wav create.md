---
titles: bin|qpsk|wav create
date: 2020-03-01 02:04:00
---

缺少解码过程
- 频率确定
- 前导声音识别确定基准
- 时间分割
- 杂音影响

磁带双面一般60min，长的90min，信息密度需要优化

```
import os
import struct
import wave

import numpy as np

def write_wav(wf,frequency=2000,duration=1,volume=1000):
	# 写入wav数据
	# 	成功返回 True
	# 	失败返回 False
	# wf
	# 	wave文件对象
	# frequency
	# 	频率 2000
	# duration  
	# 	长度 1s
	# volume 
	# 	音量 1000

	framerate = wf.getframerate() # 获取采样率

	block=int(duration*framerate) # 下方num要求必须是int才能准确分块，block分块提前转换
	x = np.linspace(0, duration, num=block)
	y = np.sin(2 * np.pi * frequency * x) * volume

	# 将波形数据转换成数组
	sine_wave = y

	try:
		for i in sine_wave:
			data = struct.pack('<h', int(i))
			# Python中struct.pack()和struct.unpack()用法详细说明
#    https://blog.csdn.net/D_R_L_T/article/details/91910774
			wf.writeframesraw(data)
		return True
	except:
		return False

def create_wav(wav_name):
	# 创建wave文件对象
	# 	成功返回wave文件对象
	# 	失败返回False
	# wav_name
	# 	wave文件对象路径/文件名
	framerate = 44100  # 采样率
	sample_width = 2  # 位宽 bytes needed every sample

	try:
		wf = wave.open(str(wav_name), 'wb')
		wf.setnchannels(1)
		wf.setframerate(framerate)
		wf.setsampwidth(sample_width)

		return wf
	except:
		return False

def close_wav(wf):
	# 关闭wave文件对象
	# 	成功返回 True
	# 	失败返回 False
	# wf
	# 	wave文件对象 来自wave.open(wavfile_name, 'wb')
	try:
		wf.close()
		return True
	except:
		return False

# example:
# wf1=create_wav('aa.wav')
# write_wav(wf1,2000,2,1000)
# write_wav(wf1,1000,3,1000)
# close_wav(wf1)

if __name__ == '__main__':

	filepath=input("Enter file name/path: ")
	binfile = open(filepath, 'rb') #打开二进制文件
    
	size = os.path.getsize(filepath) #获得文件大小

	wav_name1=input("Enter wav name/path: ")
	wf1=create_wav(wav_name1)

	write_wav(wf1,2250,1.5,1500)
	write_wav(wf1,2500,0.1,1500)
	write_wav(wf1,2250,0.4,1500)
	print("leading indentification segment completed")

	for i in range(size):
	# for i in range(0,20):
		data = binfile.read(1) #每次取一个字节
		# print('{0:08b}'.format(ord(data))) # 可以直接把bytes以二进制打印出来
		bb='{0:08b}'.format(ord(data))
		print(bb,end=' ')
	
		for i in range(4):
			cc=bb[2*i:2*(i+1)]
			# print(cc)

			# 00 1000
			# 01 1500
			# 10 2000
			# 11 2500

			if cc=='00':
				write_wav(wf1,1000,0.1,1000)
			elif cc=='01':
				write_wav(wf1,1500,0.1,1000)
			elif cc=='10':
				write_wav(wf1,2000,0.1,1000)
			elif cc=='11':
				write_wav(wf1,2500,0.1,1000)

	close_wav(wf1)
	binfile.close()

# TODO:还要压缩60min大致只有5kb的存储量 0.2s
# 	现在达到60min 8kb 0.1s
# 	压缩算法后面再弄
# TODO:前面要加前导的识别校准声音
```
