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
	if [ -d $f ]
	then
		filename="${f%.*}"
		cd $f
		zip -r ../$filename.zip *
		cd ..
		
		cp ./$filename.zip ../staticresources/$filename.resource
		rm ./$filename.zip
		
		echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><StaticResource xmlns=\"http://soap.sforce.com/2006/04/metadata\"><cacheControl>Public</cacheControl><contentType>application/zip</contentType></StaticResource>" > ../staticresources/$filename.resource-meta.xml	
	else	
		filename="${f%.*}"
		extension="${f##*.}"
		echo "processing $filename"
		contentType="";
		if [[ $extension == 'gif' || $extension == 'jpg' || $extension == 'jpeg' || $extension == 'png' ]]
		then
			contentType="image/$extension"
		elif [[ $extension == 'text'  || $extension == 'css'  ||  $extension == 'csv' ||  $extension == 'xml' || $extension == 'rtf' || $extension == 'html' ]]
		then	
			contentType="text/$extension"
		else	
			contentType="application/$extension"
		fi
	
		cp ./$filename.$extension ../staticresources/$filename.resource
		cp ../staticresources/$filename.resource ./staticresources
		echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><StaticResource xmlns=\"http://soap.sforce.com/2006/04/metadata\"><cacheControl>Public</cacheControl><contentType>$contentType</contentType></StaticResource>" > ../staticresources/$filename.resource-meta.xml
	    cp ../staticresources/$filename.resource-meta.xml ./staticresources
		
		echo "processing $filename.$extension $contentType"
	fi
done