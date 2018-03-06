import RPi.GPIO as GPIO
import argparse
try:
    import RPi.GPIO as GPIO
except RuntimeError:
    print("Error importing RPi.GPIO!")

GPIO.setwarnings(False)

parser = argparse.ArgumentParser()
parser.add_argument("pin")
parser.add_argument("st")
args = parser.parse_args()
pin = int(args.pin)
st = int(args.st)

GPIO.setmode(GPIO.BCM)

GPIO.setup(pin, GPIO.OUT, initial=GPIO.HIGH) ## GPIO como salida

if st == 1:
    GPIO.output(pin, GPIO.LOW)
elif st == 0:
    GPIO.output(pin, GPIO.HIGH)
