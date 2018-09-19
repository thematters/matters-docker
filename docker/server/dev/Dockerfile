# Image for development environment with node 10.10.0 and pm2 3.1.2.
#

FROM matters:base

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash                && \
    cat $HOME/.nvm/nvm.sh >> $HOME/.nvm/init.sh                                                         && \
    echo 'nvm install 10.10.0; nvm use 10.10.0; nvm alias default 10.10.0' >> $HOME/.nvm/init.sh        && \
    echo 'npm install -g pm2@3.1.2' >> $HOME/.nvm/init.sh                                               && \
    sh $HOME/.nvm/init.sh                                                                               && \
    rm $HOME/.nvm/init.sh                                                                               && \
    mkdir -p $HOME/materia

ENTRYPOINT bash -c 'while true; sleep 24h; do echo "" > /dev/null; done'
