#!/bin/sh

for image in *
do
    echo "Address to e-mail this image to?"
    read email
    echo "Message to accompany image?"
    read message
    mutt -s "$message" -e 'set copy=no' -a $file -- $email
    echo "${file} sent to ${email}"
done
