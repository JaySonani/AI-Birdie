


import requests

url = 'https://audio-27.el.r.appspot.com/predict'
files = {'file': open('sample.wav','rb')}
r = requests.post(url,files=files)
print(r.json())
