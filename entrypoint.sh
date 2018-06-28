#!/bin/bash
set -e

set_env(){
  if [ ! "$GMAIL_NAME" ]; then
    echo "What is your full name? ex jane doe"
    read GMAIL_NAME
  fi
  if [ ! "$GMAIL_LOGIN" ]; then
    echo "what is your gmail address?  ex jdoe@gmail.com"
    read GMAIL_LOGIN
  fi
  if [ ! "$GMAIL_PASS" ]; then
    until [ "$GMAIL_PASS" == "$CONFIRMED" ] && [ "$GMAIL_PASS" != "" ]; do
      echo "What is your gmail password?"
      read -s GMAIL_PASS
      echo "confirm the password"
      read -s CONFIRMED
      if [[ "$GMAIL_PASS" != "$CONFIRMED" ]]; then
        echo "Password mismatch, try again."
      fi
    done
  fi
  if [ ! "$USERID" ]; then
    echo "set enduser - output of 'id -u'"
    read USERID
  fi
  if [ ! "$GMAIL_FROM" ]; then
    GMAIL_FROM="$GMAIL"
  fi
  if [ ! "$GMAIL_NAME" ]; then
    GMAIL_NAME="$GMAIL_FROM"
  fi
}

set_config(){
  sed -i "s/%GMAIL_LOGIN%/$GMAIL_LOGIN/g" "$HOME/.muttrc"
  sed -i "s/%GMAIL_PASS%/$GMAIL_PASS/g" "$HOME/.muttrc"
  sed -i "s/%GMAIL_FROM%/$GMAIL_FROM/g" "$HOME/.muttrc"
  sed -i "s/%GMAIL_NAME%/$GMAIL_NAME/g" "$HOME/.muttrc"
  if [ -e "$HOME/.muttrc.local" ]; then
    echo "source $HOME/.muttrc.local" >> "$HOME/.muttrc"
  fi
}

set_user(){
  usermod -u $USERID user
  chown -R user:user /home/user/
}

set_env
set_config
set_user
su user
exec "$@"
