[Globals]
; xrdp.ini file version number
ini_version=1

fork=true
port=3389
tcp_nodelay=true
tcp_keepalive=true
#tcp_send_buffer_bytes=32768
#tcp_recv_buffer_bytes=32768

; security layer can be 'tls', 'rdp' or 'negotiate'
security_layer=negotiate
; can be 'none', 'low', 'medium', 'high', 'fips'
crypt_level=high
; openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365
certificate=
key_file=
#disableSSLv3=true
#tls_ciphers=HIGH

autorun=

allow_channels=true
allow_multimon=true
bitmap_cache=true
bitmap_compression=true
bulk_compression=true
#hidelogwindow=true
max_bpp=32
new_cursors=true
; fastpath - can be 'input', 'output', 'both', 'none'
use_fastpath=both
; when true, userid/password *must* be passed on cmd line
#require_credentials=true
; You can set the PAM error text in a gateway setup (MAX 256 chars)
#pamerrortxt=change your password according to policy at http://url

;
; colors used by windows in RGB format
;
blue=009cb5
grey=dedede
#black=000000
#dark_grey=808080
#blue=08246b
#dark_blue=08246b
#white=ffffff
#red=ff0000
#green=00ff00
#background=626c72

;
; configure login screen
;

; Login Screen Window Title
#ls_title=My Login Title

; top level window background color in RGB format
ls_top_window_bg_color=009cb5

; width and height of login screen
ls_width=350
ls_height=430

; login screen background color in RGB format
ls_bg_color=dedede

; optional background image filename (bmp format).
#ls_background_image=

; logo
; full path to bmp-file or file in shared folder
ls_logo_filename=
ls_logo_x_pos=55
ls_logo_y_pos=50

; for positioning labels such as username, password etc
ls_label_x_pos=30
ls_label_width=60

; for positioning text and combo boxes next to above labels
ls_input_x_pos=110
ls_input_width=210

; y pos for first label and combo box
ls_input_y_pos=220

; OK button
ls_btn_ok_x_pos=142
ls_btn_ok_y_pos=370
ls_btn_ok_width=85
ls_btn_ok_height=30

; Cancel button
ls_btn_cancel_x_pos=237
ls_btn_cancel_y_pos=370
ls_btn_cancel_width=85
ls_btn_cancel_height=30

[Logging]
LogFile=xrdp.log
LogLevel=INFO
EnableSyslog=true
SyslogLevel=INFO
; LogLevel and SysLogLevel could by any of: core, error, warning, info or debug

[Channels]
; Channel names not listed here will be blocked by XRDP.
; You can block any channel by setting its value to false.
; IMPORTANT! All channels are not supported in all use
; cases even if you set all values to true.
; You can override these settings on each session type
; These settings are only used if allow_channels=true
rdpdr=true
rdpsnd=true
drdynvc=true
cliprdr=true
rail=true
xrdpvr=true
tcutils=true

; for debugging xrdp, in section xrdp1, change port=-1 to this:
#port=/var/run/xrdp/sockdir/xrdp_display_10

; for debugging xrdp, add following line to section xrdp1
#chansrvport=/var/run/xrdp/sockdir/xrdp_chansrv_socket_7210


;
; Session types
;

#[Xorg]
#name=Xorg
#lib=libxup.so
#username=ask
#password=ask
#ip=127.0.0.1
#port=-1
#$code=20

# [Xvnc1]
# name=Xvnc1
# lib=libvnc.so
# username=asknoUser
# password=askpasswd
# ip=127.0.0.1
# port=5901
# chansrvport=DISPLAY(1)
# [Xvnc2]
# name=Xvnc2
# lib=libvnc.so
# username=asknoUser
# password=askpasswd
# ip=127.0.0.1
# port=5902
# chansrvport=DISPLAY(2)
# [Xvnc10]
# name=Xvnc10
# lib=libvnc.so
# username=asknoUser
# password=askheadless
# ip=127.0.0.1
# port=5910
# chansrvport=DISPLAY(10)


# [PRE_ADD_HERE]
# [Local-sesman]
# # [Xvnc]
# name=Local-sesman
# lib=libvnc.so
# username=ask
# password=ask
# ip=127.0.0.1
# port=-1
# xserverbpp=16
# #delay_ms=2000

# [Local-console]
# name=Local-console
# lib=libvnc.so
# ip=127.0.0.1
# port=5900
# username=na
# password=ask
# #delay_ms=2000

# [Any-sesman]
# name=Any-sesman
# lib=libvnc.so
# ip=ask
# port=-1
# username=ask
# password=ask
# #delay_ms=2000

[Any-vnc]
name=Any-vnc
lib=libvnc.so
ip=asklocalhost
port=ask5900
username=na
password=ask
#pamusername=asksame
#pampassword=asksame
#pamsessionmng=127.0.0.1
#delay_ms=2000

# [Any-rdp]
# name=Any-rdp
# lib=librdp.so
# ip=ask
# port=ask3389
# username=ask
# password=ask

# [Any-neutrinordp]
# name=Any-neutrinordp
# lib=libxrdpneutrinordp.so
# ip=ask
# port=ask3389
# username=ask
# password=ask

; You can override the common channel settings for each session type
#channel.rdpdr=true
#channel.rdpsnd=true
#channel.drdynvc=true
#channel.cliprdr=true
#channel.rail=true
#channel.xrdpvr=true
