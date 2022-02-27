FROM x11docker/cinnamon

# non-root?
RUN useradd -mp j9X2HRQvPCphA -s /bin/bash -G sudo headless \
  && echo "headless:headless" |chpasswd \
  && echo 'Cmnd_Alias SU = /bin/su' >> /etc/sudoers \
  && echo "headless ALL=(root) NOPASSWD: ALL" >> /etc/sudoers



