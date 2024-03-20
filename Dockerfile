FROM debian:12

# Install the required packages
RUN apt-get update && apt-get install -y openssh-server python3 python3-pip sudo

ENV SSH_PUB_KEY_NAME=docker-key.pub

COPY ${SSH_PUB_KEY_NAME} /root/.ssh/authorized_keys

COPY sshd_config /etc/ssh/sshd_config

# Create a new user
ENV NEW_USER=tmendy
RUN useradd -ms /bin/bash ${NEW_USER}
RUN echo "${NEW_USER}:password" | chpasswd
RUN mkdir /home/${NEW_USER}/.ssh
COPY ${SSH_PUB_KEY_NAME} /home/${NEW_USER}/.ssh/authorized_keys

# Add the new user to the sudo group
RUN usermod -aG sudo ${NEW_USER}
# Allow the new user to run sudo without a password
RUN echo "${NEW_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

EXPOSE 22

ENTRYPOINT service ssh restart && tail -f /dev/null
