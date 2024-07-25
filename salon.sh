#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n FCC-Salon \n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  echo -e "\n Welcome to FCC Salon, how can I help you?"
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  case $SERVICE_ID_SELECTED in
  1) SERVICE_MENU ;;
  2) SERVICE_MENU ;;
  3) SERVICE_MENU ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE_CHECK=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo $PHONE_CHECK
  if [[ -z $PHONE_CHECK ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    ADD_CUSTOMER_TO_DB=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')");

  fi
  GET_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo What time would you like your $SERVICE_NAME, $GET_CUSTOMER_NAME?
  read SERVICE_TIME
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo "C_ID: $GET_CUSTOMER_ID"
  GET_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
      echo "S_ID: $GET_SERVICE_ID"


  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$(echo $SERVICE_TIME | sed 's/ |/"/')', $(echo $GET_CUSTOMER_ID | sed 's/ |/"/'), $(echo $GET_SERVICE_ID | sed 's/ |/"/'))")
  
  
  echo -e "I have put you down for a $(echo $SERVICE_NAME | sed 's/ |/"/') at $(echo $SERVICE_TIME | sed 's/ |/"/'), $(echo $GET_CUSTOMER_NAME. | sed 's/ |/"/')"
}


EXIT() {
  echo -e "\nThank you for stopping by.\n"
}

MAIN_MENU