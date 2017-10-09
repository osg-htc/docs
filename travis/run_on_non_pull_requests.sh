#!/bin/bash -xe

openssl aes-256-cbc -K $encrypted_8bf0fadbb437_key -iv $encrypted_8bf0fadbb437_iv -in deploy-key.enc -out deploy-key -d
chmod 600 deploy-key
eval `ssh-agent -s`
ssh-add deploy-key
git config user.name "Automatic Publish"
git config user.email "djw8605@gmail.com"
git remote add gh-token "${GH_REF}";
git fetch gh-token && git fetch gh-token gh-pages:gh-pages
echo "Pushing to github"
PYTHONPATH=src/ mkdocs gh-deploy -v --clean --remote-name gh-token
git push gh-token gh-pages
