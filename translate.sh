#!/bin/sh

languages="ru de nl uk"
#languages="ru fr it de nl uk"
all_languages="ru ac af al am an ab ar an ar as as gn av ay az az bm bn bj zh ma ba be be bh bc bi bg ba bo bs br ca cv ce cs cb co cy da pd de dv nv ds et el em my es eo ex eu fa hi fo fr fy fu ga gv gd gl ga go ha ko ha ha hy hi hs hr io ig il id ia ie iu os zu is it he jv kl kn pa ka ks kk kw rw sw ht ku ky la lo lt la lv lb lt li li ln jb lm hu mk mg ml mt mi mr xm ar mz ms cd mn my na na nl nd ne ne ja na ce fr pi no nn nr oc mh or uz pa pa pn pa ps km pm tp nd pl pt ka cr ty ks ro rm qu ru ru sa se sa sc sc ns sq sc si si sk sl sz so ck sr sr sh su fi sv tl ta ka ro tt te te th tg ch ch tr tk uk ur ug ve ve vi vo wa vl wa wu yi yo zh di ze ba zh"
in_data="data_10000.js"
#in_data="data_sample.js"
new_links_file="_links"

get_links(){
    cat $in_data | grep -o http[^\"]* >> "$1"
}

get_translated_links(){ //file_old_links lungauge
    while read my_link ; do
	echo "$my_link https:$(curl $my_link | grep interwiki-${2} | grep -o //${2}.wiki[^\"]*)" >> ${2}$new_links_file
    done < "$1"
}

change_links(){
    cp $in_data ${l}_$in_data
    while read old_link new_link; do
	if [ "s$new_link" == "s" ] ; then
	    new_link="$old_link"
	fi
	sed -i "s|$old_link|$new_link|g" ${l}_$in_data
    done < "$1$new_links_file" 
}

translate(){
    for l in $languages ; do
	my_run $l &
    done	
}

my_run(){
    l="$1"
    file_old_links=${l}_old_links
    get_links $file_old_links
    get_translated_links $file_old_links $l
    change_links $l
}

clean_all(){
    for l in $languages ; do
	rm -f $l*
    done    
}

clean_links(){
    rm -f *$new_links_file
}

[ "s$1" == "s" ] && translate ; clean_links
[ "s$1" == "sc" ] && clean_all
[ "s$1" == "sl" ] && clean_links
