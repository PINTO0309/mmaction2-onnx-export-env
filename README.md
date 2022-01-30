# mmaction2-onnx-export-env

## 1. Usage
### 1-1. Docker Pull
```bash
$ docker pull ghcr.io/pinto0309/mmaction2onnxexpenv:latest
$ git clone https://github.com/open-mmlab/mmaction2.git && cd mmaction2
$ git checkout 7c94243542985db813bb9021f97c95b59d136e52
$ mkdir -p data
$ docker run --rm -it --gpus all \
    -v `pwd`:/home/user/workdir \
    ghcr.io/pinto0309/mmaction2onnxexpenv:latest
```
### 1-2. Docker Build
```bash
$ git clone https://github.com/PINTO0309/mmaction2-onnx-export-env.git && cd mmaction2-onnx-export-env
$ git clone https://github.com/open-mmlab/mmaction2.git && cd mmaction2
$ git checkout 7c94243542985db813bb9021f97c95b59d136e52
$ mkdir -p data
$ mv docker/Dockerfile docker/Dockerfile_org
$ cp ../Dockerfile docker/Dockerfile
$ docker build -t mmaction2onnxexpenv -f docker/Dockerfile .
$ docker run --rm -it --gpus all \
    -v `pwd`:/home/user/workdir \
    mmaction2onnxexpenv:latest
```

## 2. ONNX export syntax
```
- Recognizers
 - TSN: $batch $clip $channel $height $width  1 1 3 224 224
 - I3D: $batch $clip $channel $time $height $width  1 1 3 32 224 224

$ python tools/deployment/pytorch2onnx.py \
    ${CONFIG_FILE} \
    ${CHECKPOINT_FILE} \
    --shape ${SHAPE} \
    --verify \
    --output-file ${OUTPUT_FILE} \
    --opset-version 11

========================================
- Localizers
 - BSN etc: Default  1 1 3 224 224

$ python tools/deployment/pytorch2onnx.py \
    ${CONFIG_FILE} \
    ${CHECKPOINT_FILE} \
    --shape ${SHAPE} \
    --verify \
    --output-file ${OUTPUT_FILE} \
    --is-localizer \
    --opset-version 11
```

## 3. ONNX export sample
```bash
# PoseC3D - FineGYM
## config
$ wget https://github.com/open-mmlab/mmaction2/raw/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_gym_keypoint.py
$ wget https://github.com/open-mmlab/mmaction2/raw/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_gym_limb.py
## checkpoint
$ wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_gym_keypoint/slowonly_r50_u48_240e_gym_keypoint-b07a98a0.pth
$ wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_gym_limb/slowonly_r50_u48_240e_gym_limb-c0d7b482.pth

$ MODEL=slowonly_r50_u48_240e_gym_keypoint
$ H=224
$ W=224
$ python tools/deployment/pytorch2onnx.py \
    ${MODEL}.py \
    ${MODEL}-b07a98a0.pth \
    --shape 1 1 17 32 ${H} ${W} \
    --verify \
    --output-file ${MODEL}_${H}x${W}.onnx \
    --opset-version 11

$ python -m onnxsim ${MODEL}_${H}x${W}.onnx ${MODEL}_${H}x${W}.onnx
```

## 4. Model Type - ModelZoo OVERVIEW
1. Spatio Temporal Action Detection Models
2. Action Localization Models
3. Action Recognition Models
4. Skeleton-based Action Recognition Models

https://mmaction2.readthedocs.io/en/latest/modelzoo.html

## 5. MMAction2

https://github.com/open-mmlab/mmaction2
