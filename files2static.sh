#!/bin/bash
if [ ! -d "staticresources" ]; then
	echo 'No static resource dir found, making...'
	mkdir staticresources
fi 

cd staticresources
rm *
cd ..

echo 'Files:'
cd files
for f in *
do
	filename="${f%.*}"
	extension="${f##*.}"
	echo "processing $filename"
	contentType="";
	if [[ $extension == 'gif' || $extension == 'jpg' || $extension == 'jpeg' || $extension == 'png' ]]
	then
		contentType="image/$extension"
	elif [[ $extension == 'text'  ||  $extension == 'xml' || $extension == 'rtf' || $extension == 'html' ]]
	then	
		contentType="text/$extension"
	else	
		contentType="application/$extension"
	fi
	
	cp ./$filename.$extension ../staticresources/$filename.resource
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><StaticResource xmlns=\"http://soap.sforce.com/2006/04/metadata\"><cacheControl>Public</cacheControl><contentType>$contentType</contentType></StaticResource>" > ../staticresources/$filename.resource-meta.xml
	
	echo "processing $filename.$extension $contentType"
done