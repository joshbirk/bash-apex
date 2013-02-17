#!/bin/bash
if [ ! -d "files" ]; then
	echo 'No files dir found, making...'
	mkdir files
fi 

cd files
rm -R *
cd ..

echo 'Static Resources:'
cd staticresources
for f in *xml
do
	filename="${f%.resource-meta*}"
	echo "processing $filename"
	contentType=`sed -n -e 's/.*<contentType>\(.*\)<\/contentType>.*/\1/p' $f`
	echo $contentType
	IFS='/' read -ra str <<< "$contentType"
	echo ${str[1]}
	cp ./$filename.resource ../files/$filename.${str[1]}
	if [ ${str[1]} == 'zip' ]
	then
		unzip -d "../files/$filename" ../files/$filename.${str[1]}
		rm ../files/$filename.${str[1]}
	fi
done