. ./set_env.sh
git clone --recurse-submodules git@github.com:Flash-X/Flash-X.git
cd $HERE/Flash-X/sites && mkdir $SITE_NAME && cd $HERE/Flash-X
cp $HERE/FlashFiles/Makefile.h $HERE/Flash-X/sites/$SITE_NAME/Makefile.h
