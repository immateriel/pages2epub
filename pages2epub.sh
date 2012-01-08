#! /bin/sh
# -*- mode: shell-script; -*-
VERSION=0.1
eval file=\${$#}
if [ ! -e "$file" ] || [ ! "$1" ] ; then
    cat <<EOH
pages2ePub v${VERSION}
 Usage: pages2ePub.sh [--debug] [--output=file.epub] [--basename=basename] [--identifier=isbn] [--publisher=publisher] [--title=title] [--author=author] file.pages
EOH
else

	while getopts "dobipta:-:" OPT 
	do
	    # gestion des options longues avec ou sans argument
	    [ $OPT = "-" ] && case "${OPTARG%%=*}" in
	        debug) OPT="d" ; debug="true" ;;
	        output) OPT="o" ; output="${OPTARG#*=}" ;;
	        basename) OPT="b" ; basename="${OPTARG#*=}" ;;
	        identifier) OPT="i" ; identifier="${OPTARG#*=}" ;;
	        publisher) OPT="p" ; publisher="${OPTARG#*=}" ;;
	        title) OPT="t" ; title="${OPTARG#*=}" ;;
	        author) OPT="a" ; author="${OPTARG#*=}" ;;
	        *) echo "option longue non permise -- ${OPTARG%%=*}" >&2 ; exit 65 ;;
	    esac
	done
	
	
	if [ ! $debug ] ; then
		debugzip="-q"
	fi
	
    xsltfile=./pages2ePub.xsl
#TODO accepter un répertoire en argument et 
#boucler sur tous les fichiers Pages
#for pagefile in $pagedir do
		
    pagefile=$file
    basedir=$(pwd)
		if [ ! $basename ] ; then
    	base=$(basename ${pagefile} .pages)
		else
			base=$basename
    fi
		mkdir -p /tmp/epub/${base}
    epubdir=$(mktemp -d /tmp/epub/${base}/XXX) || exit 1
    extractdir=/tmp/extract/${base}
    mkdir -p ${extractdir} || exit 1
#    echo "Extract dir : $extractdir"
    unzip ${debugzip} -o -d ${extractdir} ${pagefile}
    xmlfile=${extractdir}/index.xml
    xmllint --format $xmlfile > ${extractdir}/${base}.xml
# Récupération de la couverture
#    cp ${extractdir}/QuickLook/Thumbnail.jpg ${epubdir}/cover.jpg
#		cp ${extractdir}/*.JPG ${epubdir}/
#		cp ${extractdir}/*.jpg ${epubdir}/
#		cp *.otf ${epubdir}/
    convert ${extractdir}/QuickLook/Thumbnail.jpg ${epubdir}/cover.png
# Création du fichier mimetype
    echo "application/epub+zip" > ${epubdir}/mimetype
# Copie du fichier de couv
    cp cover.html ${epubdir}/
# Création rep META-INF
    mkdir ${epubdir}/META-INF
# On crée tous les fichiers via la transformation XSLT
    htmlfile=${base}.html

		if [ ! $identifier ] ; then
			identifier="http://livre.im/content/${base}.epub"
		fi
		
		if [ ! "$publisher" ] ; then
			publisher="immatériel.fr"
		fi
		
		if [ ! "$title" ] ; then
			title="undefined"
		fi

		if [ ! "$author" ] ; then
			author="undefined"
		fi

		#	 --stringparam title ${title} \
#			echo "${epubdir}"

    xsltproc --stringparam maindir ${epubdir} \
	--stringparam mainfile ${htmlfile} --stringparam identifier ${identifier} --stringparam publisher "${publisher}" \
	--stringparam author "${author}" --stringparam basename ${base} \
	--stringparam title "${title}" \
	${xsltfile} ${xmlfile} >${epubdir}/$htmlfile \
2>${extractdir}/last_transfo.log
# On crée une archive zip

conv_imgs=$(xsltproc --stringparam maindir ${epubdir} --stringparam extractdir ${extractdir} generate_images.xsl ${epubdir}/${base}.html)
if [ $debug ] ; then 
	echo $conv_imgs
fi
sh -c "${conv_imgs}"

cd ${epubdir}
cnt=$(ls -1 *.html| wc -l)


#echo $cnt
	if [ $cnt -gt 4 ] ; then
		if [ ! $debug ] ; then
			rm ${base}.html
		fi
	fi
   zip ${debugzip} -0Xr ${epubdir}/${base}.zip mimetype
   zip ${debugzip} -X9Dr ${epubdir}/${base}.zip .
	cd ${basedir}
	if [ ! $output ] ; then
		output=${basedir}/${base}.epub
	fi

   mv ${epubdir}/${base}.zip ${output}
if [ ! $debug ] ; then
	# On supprime le rep temp
	   rm -r ${epubdir}
fi
if [ $debug ] ; then
    cat <<EOF 
*****
* Les fichiers ePub correspondant à ${pagefile} se trouvent dans ${epubdir} 
**
EOF
fi
   echo "Création du fichier ${output}"
fi