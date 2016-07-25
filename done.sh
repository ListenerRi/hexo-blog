#!/bin/bash

echo -e "cd ~/hexo-blog/"
cd ~/hexo-blog/

if [[ $? != 0 ]]; then
    echo -e "\nthere is no dir named ~/hexo-blog/ !!"
    exit 1
else
    echo -e "\nhexo clean :"
    hexo clean
fi

if [[ $? != 0 ]]; then
    echo -e "\nhexo clean failed !!"
    exit 1
else
    echo -e "\nhexo generate :"
    hexo generate
fi

if [[ $? != 0 ]]; then
    echo -e "\nhexo generate failed !!"
    exit 1
else
    echo -e "\nhexo deploy :"
    hexo deploy
fi

if [[ $? != 0 ]]; then
    echo -e "\nhexo deploy failed !!"
    exit 1
else
    echo -e "\ngit add -A :"
    git add -A
    if [[ $? != 0 ]]; then
	echo "git:everything has been added to index"
    fi
fi

if [[ $? != 0 ]]; then
    echo -e "\ngit add -A failed !!"
    exit 1
else
    echo -e "\ngit commit :"
    git commit -m "add a new post"
    if [[ $? != 0 ]]; then
	echo "git:commit index to local repository"
    fi
fi

if [[ $? != 0 ]]; then
    echo -e "\ngit commit failed !!"
    exit 1
else
    echo -e "\ngit push"
    git push
fi

if [[ $? != 0 ]]; then
    echo -e "\ngit push failed !!"
    exit 1
else
    echo -e "\neverything is done!\ngood luck~~\n:)"
fi
