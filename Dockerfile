FROM alpine
MAINTAINER joshuajleigh

RUN apk --update --no-cache add ca-certificates mutt feh lynx vim bash shadow

RUN adduser user -D
ENV HOME /home/user
RUN mkdir -p $HOME/.mutt/themes/ $HOME/.mutt/cache/headers $HOME/.mutt/cache/bodies \
  && touch $HOME/.mutt/certificates

ENV BROWSER lynx
ADD comidia $HOME/.mutt/themes/comidia
ADD mailcap $HOME/.mutt/
#ADD vimrc $HOME/.vimrc

ADD entrypoint.sh /entrypoint.sh
ADD muttrc $HOME/.muttrc
ENTRYPOINT ["/entrypoint.sh"]
