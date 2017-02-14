#!/bin/sh

BFG_CHANGEFILE=$1
shift 1

function do_print_diff {
  while read change
  do
    #echo $change
    before_ref=$(echo "${change}" | cut -d' ' -f1 -)
     after_ref=$(echo "${change}" | cut -d' ' -f2 -)
      filename=$(echo "${change}" | cut -d' ' -f3 -)
    echo "######## ${filename}:"
    git diff --color ${before_ref}..${after_ref}
  done <$BFG_CHANGEFILE
}

do_print_diff | less -F -X -r

