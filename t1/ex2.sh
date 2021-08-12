#！/bin/bash

a=$RANDOM 
read -p "This is a guess! please input an integer:" num
while [ $num != $a ]; 
do
  if [[ $num -lt $a ]]; then
  	echo "Smaller! Please input again:"
  fi
  if [[ $num -gt $a ]]; then
  	echo "Larger! Please input again:"
  fi 
  read num
done

echo "Congratulations!"