#!/bin/bash -xe

PYTHONPATH=src/ mkdocs build --verbose --strict
linkchecker --config=travis/linkchecker.config site/index.html
