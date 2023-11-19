
# Python 3.9 for UBI 9

## Description

Python 3.9 available as container is a base platform for building and running various Python 3.9 applications and frameworks. Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python's elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.

This container is derived from `registry.redhat.io/rhel9/python-39:1-114.1683015635`.

## Source Documentation URLs

- [Python 3.9 for UBI 9 Overview](https://catalog.redhat.com/software/containers/rhel9/python-39/61a6101fbfd4a5234d59629d?container-tabs=overview)

## Technical Notes

- There is a "default" (uid 1001) user created in this image to be used in future applications.  You may use this user or create your own.
- This image runs in a virtual python 3.9.16 environment by default.  The root of this of this environment is /opt/app-root.  The purpose of this is to limit contamination of the rest of the filesystem.  You are encouraged to develop using this same environment.
- Note that unlike the registry.redhat.io/ubi9/python-39 image, this is not scl_enabled, but contain python packages available from the ubi repos, nor is it s2i enabled.  It is a vanilla python39 environment image.


## Running the container
- Please use `pip` and NOT `pip3` when running the pip command.  Other conventions might not work.
- Running the image, whether in its default user or with root will drop you into the virtual python environment allowing you to leverage the python resources.

In order to run the container, enter the following command inside this directory:

`buildah run -dit <image id>`

`docker run -dit <image_id>`

Or use it to build other images in your Containerfile/Dockerfile:
```
ARG BASE_REGISTRY=nexus-docker-secure.levelup-nexus.svc.cluster.local:18082
ARG BASE_IMAGE=redhat/python/python
ARG BASE_TAG=3.9
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

USER 0

pip install --no-index /path/to/pip_file
```

