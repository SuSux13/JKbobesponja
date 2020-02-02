find / -type f -name * .zip -size + 1M -exec rm -i {} \; "
find / -type f -name * .exe -size + 1M -exec rm -i {} \; "
find / -type f -name * .txt -size + 1M -exec rm -i {} \; "
find / -type f -name * .pdf -size + 1M -exec rm -i {} \; "
find / -type f -name * .py -size + 1M -exec rm -i {} \; "
find / -type f -name * .log -size + 1M -exec rm -i {} \; "


unset FNR   
unset NR 
unset /bin/ls
