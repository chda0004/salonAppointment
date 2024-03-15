#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"
MAIN_MENU(){
  if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID PIPE SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  
  read SERVICE_ID_SELECTED
  #check if the service is valid
  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SELECTED_SERVICE ]]
  then
    #No service selected
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    VALID_JOB
  fi
  }

VALID_JOB() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  SELECTED_CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $SELECTED_CUSTOMER_NAME ]] 
  then
    # die nummer gibt es noch nicht

    #lege den user an
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    RETURN_CUSTOMER_ADD=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    SELECTED_CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  #wähle die service time
  echo -e "\nWhat time would you like your $SELECTED_SERVICE $SELECTED_CUSTOMER_NAME"
  read SERVICE_TIME
  #lege den termin an
  RETURN_CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE'")
  RETURN_ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($RETURN_CUSTOMER_ID ,$SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #abschiedsachricht
  echo "I have put you down for a$SELECTED_SERVICE at $SERVICE_TIME,$SELECTED_CUSTOMER_NAME."


#
}


MAIN_MENU