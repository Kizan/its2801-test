#!/usr/bin/python

from Adafruit_BME280 import *
import sys

#print 'Reading from i2c at address', sys.argv[1]

sensor = BME280(mode=BME280_OSAMPLE_8, address=int(sys.argv[1], 16))

f = open('tempOffset.txt')
tempOffset = f.read()
f.close()

floatTempOffset = float(tempOffset)

temp = (sensor.read_temperature() * 9 / 5.0 + 32) + floatTempOffset
print '{0:0.2f}'.format(temp)

