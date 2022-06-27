#Question 4
create variable from text in a terraform tfvars file
accountid=`awk '/accountid/ {print$3}' terraform.tfvars|sed 's/"//g`

#question 5
python file attached
