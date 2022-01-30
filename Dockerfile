ARG PYTORCH="1.10.0"
ARG CUDA="11.3"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX 8.6"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
ARG PYTORCH="1.10.0"
ARG MMCUDA="113"
ARG MMCVFULL="1.4.4"
ARG USERNAME=user
ARG WKDIR=/home/${USERNAME}
WORKDIR ${WKDIR}

# Install dependencies
RUN apt-get update && apt-get install -y \
        git ninja-build libglib2.0-0 wget \
        libsm6 libxrender-dev libxext6 ffmpeg \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mmcv-full
RUN pip install pip --upgrade \
    && pip install onnx==1.10.2 \
    && pip install onnxruntime==1.10.0 \
    && pip install onnxruntime-extensions==0.4.2 \
    && pip install onnxoptimizer==0.2.6 \
    && pip install onnx-simplifier==0.3.6 \
    && pip install cython==0.29.27 --no-cache-dir \
    && pip install mmcv-full==${MMCVFULL} \
        -f https://download.openmmlab.com/mmcv/dist/cu${MMCUDA}/torch${PYTORCH}/index.html \
    && pip cache purge

# Install MMAction2
RUN conda clean --all
ENV FORCE_CUDA="1"
COPY . .
RUN pip install --no-cache-dir -e .

# Create a user who can sudo in the Docker container
RUN echo "root:root" | chpasswd \
    && adduser --disabled-password --gecos "" "${USERNAME}" \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && echo "%${USERNAME}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}
USER ${USERNAME}
RUN sudo chown ${USERNAME}:${USERNAME} ${WKDIR} \
    && echo "cd ${WKDIR}/workdir" >> ${WKDIR}/.bashrc