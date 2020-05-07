#!/usr/bin/bash
NULL_UUID=00000000-0000-0000-0000-000000000000

# TODO
# rank based on time
# optionally watch
# subgraphs for larger datasets

WATCH=1
SINGLE=1

usage()
{
    echo "$0 [-w] <storage-mount> <output>"
    echo " -w   Watches the storage"
    exit 1
}

MNT="$1"
OUTPUT="$2"
SET="$3"
[ -d "$MNT" ] || usage

node()
{
    local ID=$1
    echo "_${ID:0:8}"
}

sets()
{
    for d in $MNT/set/* ; do
        ls -1 $d
    done
}

points()
{
    local SET=$1
    ls -1 $MNT/set/${SET:0:2}/$SET | sed -e "s/point.//" -e "s/.dep//"
}

images()
{
    find $MNT/image/ -mindepth 2 -maxdepth 2 -type d | xargs basename -a
}

images_by_point()
{
    local POINT=$1
    ls -rt1 $MNT/point/${POINT:0:2}/$POINT/image.*.dep | sed -e "s/.*image\.\(.\{36\}\)\.dep/\1/"
}

point_refs()
{
    local IMG=$1
    ls -1 $MNT/image/${IMG:0:2}/$IMG/point*.ref | sed -e "s/.*point\.\(.\{36\}\)\.ref/\1/"
}

image_refs()
{
    local IMG=$1
    ls -1 $MNT/image/${IMG:0:2}/$IMG/image.*.ref | sed -e "s/.*image\.\(.\{36\}\)\.ref/\1/"
}

image_deps()
{
    local IMG=$1
    ls -d1 $MNT/image/${IMG:0:2}/$IMG/image.*.dep | sed -e "s/.*image\.\(.\{36\}\)\.dep/\1/"
}

image_cons()
{
    local IMG=$1
    ls -d1 $MNT/image/${IMG:0:2}/$IMG/image.*.con | sed -e "s/.*image\.\(.\{36\}\)\.con/\1/"
}

image_has_point_ref()
{
    local IMG=$1
    compgen -G "$MNT/image/${IMG:0:2}/$IMG/point.*.ref" > /dev/null
}

image_is_garbage()
{
    local IMG=$1
    test -e "$MNT/image/${IMG:0:2}/$IMG.garbage"
}

output_point()
{
    echo "$(node $1) [shape=oval]"
}

output_ref()
{
    echo "$(node $1) -> $(node $2) [style=dotted,weight=0.5]"
}

graph()
{
    local NO_RP='[style=filled]'
    local HAS_RP='[style=solid]'
    local GARBAGE='[color=red]'
    echo 'digraph xafe {'
    echo 'rankdir=BT'
    echo "node $NO_RP;"
    echo "{ rank=min; $(node $NULL_UUID) }"
    #for SET in $(sets); do
    #    echo "subgraph {"
        for IMAGE in $(images); do
            if image_has_point_ref $IMAGE ; then
                echo "$(node $IMAGE) $HAS_RP;"
            fi
            if image_is_garbage $IMAGE ; then
                echo "$(node $IMAGE) $GARBAGE;"
            fi
        done
        for IMAGE in $(images); do
            echo -n "$(node $IMAGE) -> {"
            for DEP in $(image_deps $IMAGE); do
                echo -n " $(node $DEP)"
            done
            echo '}'
            CONS=$(image_cons $IMAGE)
            if [ -n "$con" ]; then
                echo -n "$(node $IMAGE) -> {"
                for CON in $CONS; do
                    echo -n " $(node $CON)"
                done
                echo ' [style=filled]}'
            fi
            for REF in $(image_refs $IMAGE); do
                output_ref $IMAGE $REF
            done
        done
    #    echo '}'
    #done
    echo '}'
}

if [ $SINGLE -eq 1 ]; then
    graph > /tmp/$OUTPUT.dot
    exit
fi

while true; do
    graph > /tmp/$OUTPUT.dot~
    if ! cmp -s ~/$OUTPUT.dot~ ~/$OUTPUT.dot ; then
        mv /tmp/$OUTPUT.dot~ /tmp/$OUTPUT.dot
        dot -T jpeg /tmp/$OUTPUT.dot > ~/$OUTPUT.jpg~
        if ! cmp -s ~/$OUTPUT.jpg~ ~/$OUTPUT.jpg ; then
            mv ~/$OUTPUT.jpg~ ~/$OUTPUT.jpg
        fi
    fi
    [ $WATCH -eq 1 ] || break
    sleep 1
done
