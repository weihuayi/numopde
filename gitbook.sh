#!/bin/bash
if [[ `git status --porcelain` ]]; then
    cd ../weihuayi.github.io/
    git pull origin
    cd ../numopde/
    git add .
    git commit -m "update" 
    git pull origin
    git push origin 
    gitbook build
    cp -r _book/* ../weihuayi.github.io/math/numopde/
    cd ../weihuayi.github.io/
    git add .
    git commit -m "update" 
    git push origin 
else
    git pull origin
    git push origin
fi
