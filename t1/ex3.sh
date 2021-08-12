#！/bin/sh
declare -a letter
word=$(sed -n "$(($RANDOM%273))p" cmd.txt|cut -d ' ' -f 1)
word_length=${#word}
for((i=0; i<word_length; i++)) ; do
	letter[$i]=_
done

echo "This is a hangman game. You need to guess a word. You have six chances to make wrong guesses on whether a letter is in this word.
	Now, input your first letter(the letter has $word_length words): "
wrong=0
while (($wrong<=5));do
	echo "input your guess:"
	read guess
	for((i=0;i<word_length;i++)); do
		if [ "$guess" == "${word:$i:1}" ];then
			letter[$i]=$guess
		fi
	done
	for((i=0;i<word_length;i++)); do
		if [ "$guess" == "${word:$i:1}" ];then
			break;
		fi
	done
	if [ $i == $word_length ];then
		let "wrong++"
	fi
	case $wrong in
    0)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
	;;
    1)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
	;;
    2)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "         |         |"
		echo "         |         |"
		echo "         |         |"
		echo "         |         |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
    ;;
    3)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "         |         |"
		echo "      ---|         |"
		echo "         |         |"
		echo "         |         |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
    ;;
    4)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "         |         |"
		echo "      ---|---      |"
		echo "         |         |"
		echo "         |         |"
		echo "                   |"
		echo "                   |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
    ;;
    5)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "         |         |"
		echo "      ---|---      |"
		echo "         |         |"
		echo "         |         |"
		echo "        /          |"
		echo "       /           |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
	;;
    6)  clear
		echo "          __________"
		echo "         |         |"
		echo "         |         |"
		echo "       _/_\_       |"
		echo "        |_|        |"
		echo "         |         |"
		echo "      ---|---      |"
		echo "         |         |"
		echo "         |         |"
		echo "        / \        |"
		echo "       /   \       |"
		echo "                   |"
		echo "      _____________|_____"
		echo "you make $wrong mistake(s)."
    ;;
esac
	echo ${letter[*]}

	for((i=0;i<word_length;i++)); do
		if [ "${letter[$i]}" != "${word:$i:1}" ];then
			break;
		fi
	done
	if [ $i == $word_length ]; then
		echo "you win."
		man $word
		exit 0
	fi
done


echo "You lose."
man $word

