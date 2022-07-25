 #!/bin/bash

# https://manpages.debian.org/testing/xrdp/xrdp-genkeymap.8.en.html
# 00000409 en-us US English
cat > /tmp/.km-xrdp.txt<<EOF
/etc/xrdp/km-00000407.ini
/etc/xrdp/km-00000409.ini
/etc/xrdp/km-0000040a.ini
/etc/xrdp/km-0000040b.ini
/etc/xrdp/km-0000040c.ini
/etc/xrdp/km-00000410.ini
/etc/xrdp/km-00000411.ini
/etc/xrdp/km-00000412.ini
/etc/xrdp/km-00000414.ini
/etc/xrdp/km-00000415.ini
/etc/xrdp/km-00000416.ini
/etc/xrdp/km-00000419.ini
/etc/xrdp/km-0000041d.ini
/etc/xrdp/km-00000807.ini
/etc/xrdp/km-00000809.ini
/etc/xrdp/km-0000080c.ini
/etc/xrdp/km-00000813.ini
/etc/xrdp/km-00000816.ini
/etc/xrdp/km-0000100c.ini
EOF

# judge, generate
# in DISPLAY env?
cat $file | while read one; do
    test -s $one || /usr/local/xrdp/bin/xrdp-genkeymap $one
done