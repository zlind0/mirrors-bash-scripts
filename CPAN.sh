[[ $MIRROR_SITE =~ default ]] && MIRROR_SITE='https://www.cpan.org'
cpan << !

o conf urllist push $MIRROR_SITE/CPAN/
o conf commit
!