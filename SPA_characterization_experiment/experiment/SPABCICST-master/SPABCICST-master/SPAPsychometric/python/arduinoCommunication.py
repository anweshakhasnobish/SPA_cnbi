import serial
import time
import os.path
import sys

defaultSerialPort = '/dev/ttyUSB0'
defaultSerialPort = '/dev/ttyACM0'

defaultBaudRate = 115200
if len(sys.argv) > 1:
	serialPort = sys.argv[1]
elif len(sys.argv) > 2:
	baudRate = sys.argv[2]
else:
	serialPort = defaultSerialPort
	baudRate = defaultBaudRate

ser = serial.Serial(serialPort, baudRate)
lockName = '../tmp/arduino.lock'
fileName = '../tmp/arduino.txt'
countCommands 	= 0
connect 		= True
print(os.path.isfile(fileName))
print(os.path.dirname(os.path.realpath(__file__)))
print(os.getcwd())
while connect:
	start_time = time.time()
	if not os.path.isfile(lockName) and os.path.isfile(fileName):
		f = open(lockName, 'w')
		f.close()
		f = open(fileName, 'r')
		isArduinoCommand = False
		command = f.readline()
		if command == 'flushInput\n':
			pass
			#ser.flushInput();
		elif command == 'disconnect\n':
			connect = False
			print(command)
		else:
			isArduinoCommand = True;
			print(command)
			ser.write(str.encode(command));
			#print(ser.readline())
		f.close()
		os.remove(lockName)
		os.remove(fileName)
		countCommands += 1
		elapsed_time = time.time() - start_time
		if isArduinoCommand:
			print(elapsed_time)
			print(countCommands)
ser.close()
