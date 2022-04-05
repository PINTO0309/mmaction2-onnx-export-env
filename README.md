# mmaction2-onnx-export-env

## 1. Usage
### 1-1. Docker Pull
```bash
$ docker pull ghcr.io/pinto0309/mmaction2onnxexpenv:latest
$ git clone https://github.com/open-mmlab/mmaction2.git && cd mmaction2
$ git checkout 6ea00d23d66fd491bbf19317b4677bf6f396d26f
$ mkdir -p data
$ docker run --rm -it --gpus all --shm-size 10gb \
-v `pwd`:/home/user/workdir \
ghcr.io/pinto0309/mmaction2onnxexpenv:latest
```
### 1-2. Docker Build
```bash
$ git clone https://github.com/PINTO0309/mmaction2-onnx-export-env.git && cd mmaction2-onnx-export-env
$ git clone https://github.com/open-mmlab/mmaction2.git && cd mmaction2
$ git checkout 6ea00d23d66fd491bbf19317b4677bf6f396d26f
$ mkdir -p data
$ mv docker/Dockerfile docker/Dockerfile_org
$ cp ../Dockerfile docker/Dockerfile
$ docker build -t mmaction2onnxexpenv -f docker/Dockerfile .
$ docker run --rm -it --gpus all --shm-size 10gb \
-v `pwd`:/home/user/workdir \
ghcr.io/pinto0309/mmaction2onnxexpenv:latest
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
# PoseC3D - FineGYM/NTU60/NTU120
## config
wget https://github.com/open-mmlab/mmaction2/raw/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_gym_keypoint.py
wget https://github.com/open-mmlab/mmaction2/raw/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_gym_limb.py
wget https://github.com/open-mmlab/mmaction2/tree/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_ntu60_xsub_keypoint.py
wget https://github.com/open-mmlab/mmaction2/tree/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_ntu60_xsub_limb.py
wget https://github.com/open-mmlab/mmaction2/tree/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_keypoint.py
wget https://github.com/open-mmlab/mmaction2/tree/master/configs/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_limb.py

## checkpoint
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_gym_keypoint/slowonly_r50_u48_240e_gym_keypoint-b07a98a0.pth -O slowonly_r50_u48_240e_gym_keypoint.pth
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_gym_limb/slowonly_r50_u48_240e_gym_limb-c0d7b482.pth -O slowonly_r50_u48_240e_gym_limb.pth
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_ntu60_xsub_keypoint/slowonly_r50_u48_240e_ntu60_xsub_keypoint-f3adabf1.pth -O slowonly_r50_u48_240e_ntu60_xsub_keypoint.pth
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_ntu60_xsub_limb/slowonly_r50_u48_240e_ntu60_xsub_limb-1d69006a.pth -O slowonly_r50_u48_240e_ntu60_xsub_limb.pth
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_keypoint/slowonly_r50_u48_240e_ntu120_xsub_keypoint-6736b03f.pth -O slowonly_r50_u48_240e_ntu120_xsub_keypoint.pth
wget https://download.openmmlab.com/mmaction/skeleton/posec3d/slowonly_r50_u48_240e_ntu120_xsub_limb/slowonly_r50_u48_240e_ntu120_xsub_limb-803c2317.pth -O slowonly_r50_u48_240e_ntu120_xsub_limb.pth

MODEL=slowonly_r50_u48_240e_gym_keypoint \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx

MODEL=slowonly_r50_u48_240e_gym_limb \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx


MODEL=slowonly_r50_u48_240e_ntu60_xsub_keypoint \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx

MODEL=slowonly_r50_u48_240e_ntu60_xsub_limb \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx


MODEL=slowonly_r50_u48_240e_ntu120_xsub_keypoint \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx

MODEL=slowonly_r50_u48_240e_ntu120_xsub_limb \
&& KEYPOINTS=17 \
&& FRAMES=30 \
&& H=64 \
&& W=64 \
&& BATCH=1 \
&& CLIP=2 \
&& python tools/deployment/pytorch2onnx.py \
${MODEL}.py \
${MODEL}.pth \
--shape ${BATCH} ${CLIP} ${KEYPOINTS} ${FRAMES} ${H} ${W} \
--verify \
--output-file ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx \
--opset-version 11 \
--softmax \
&& onnxsim ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx ${MODEL}_${BATCH}x${CLIP}x${KEYPOINTS}x${FRAMES}x${H}x${W}.onnx
```

## 4. Model Type - ModelZoo OVERVIEW
1. Spatio Temporal Action Detection Models
2. Action Localization Models
3. Action Recognition Models
4. Skeleton-based Action Recognition Models

https://mmaction2.readthedocs.io/en/latest/modelzoo.html

## 5. MMAction2

https://github.com/open-mmlab/mmaction2
