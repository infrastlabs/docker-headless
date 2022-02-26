FROM x11docker/cinnamon

# non-root?
RUN useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo headless \
  && echo "headless:headless" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' >> /etc/sudoers \
  && echo "headless ALL=(root) NOPASSWD: ALL" >> /etc/sudoers

# 手工进入调试: cinnamon-session ##dbus-conn err.
# headless@host-xx:/usr/local/bin$ dbus-launch cinnamon-session ##still crashed(UI 跳框)

