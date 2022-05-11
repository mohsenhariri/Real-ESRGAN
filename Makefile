# https://www.gnu.org/software/make/manual/make.html
PATH := ./env/bin:${PATH}
PY := python3

include .env.dev
export

SRC := src
DIST := dist
BUILD := build

.PHONY: test all dev clean dev pyserve $(SRC) $(DIST) $(BUILD)


env:
		$(PY) -m venv env

check:
		$(PY) -m ensurepip --default-pip
		$(PY) -m pip install --upgrade pip setuptools wheel

test:
		echo $(PATH)
		$(PY) --version
		$(PY) -m pip --version

test-os:
		$(PY) -c 'import sys;print(sys.platform)'


pi:
		$(PY) -m pip install $(filter-out $@,$(MAKECMDGOALS))
		$(PY) -m pip freeze > requirements.txt

piu:
		$(PY) -m pip install --upgrade $(filter-out $@,$(MAKECMDGOALS))
		$(PY) -m pip freeze > requirements.txt

pia: requirements.txt
		$(PY) -m pip install -r requirements.txt

pn1:
		$(PY) -m pip  list --outdated

build:
		$(PY) -m pip install --upgrade build
		$(PY) -m build

preview:
		twine upload -r testpypi -u $(PYPIU) -p $(PYPIP) --repository-url https://test.pypi.org/legacy/ dist/*  --verbose

preview2:
		twine upload  --config-file .pypirc -r testpypi dist/*  --verbose



publish:
		# $(PY) -m pip install --upgrade twine
		$(PY) -m twine upload --config-file .pypirc --repository testpypi dist/* --verbose


%: # https://www.gnu.org/software/make/manual/make.html#Automatic-Variables
		@:


pre: # https://github.com/xinntao/Real-ESRGAN#installation
		$(PY) setup.py develop


get_pretrained:
		wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P experiments/pretrained_models

get_pretrainedx2:
		wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.1/RealESRGAN_x2plus.pth -P experiments/pretrained_models


infere1:
		$(PY) inference_realesrgan.py -n RealESRGAN_x4plus -i upload --outscale 3.5 --face_enhance


infere2:
		$(PY) inference_realesrgan.py -n RealESRGAN_x4plus -i upload --outscale 3.5

dev3:
		$(PY) inference_realesrgan_nii.py -n RealESRGAN_x2plus -i inputs -s 2

dev_f1:
		$(PY) inference_realesrgan_nii.py -n RealESRGAN_x2plus -i $(array_data_root) -s 2


dev_f1_labels:
		$(PY) inference_realesrgan_nii.py -n RealESRGAN_x2plus -i $(array_data_labels_root) -s 2
