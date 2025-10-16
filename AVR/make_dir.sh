#!/usr/bin/env bash

cd /c/Users/pbuko/Desktop/agh/pn/avr/Programowanie-Niskopoziomowe-AVR/AVR || exit 1

read -p "Podaj numer ćwiczenia: " num

ex_num="cw_$num"

# sprawdź, czy katalog już istnieje
if [[ -d "$ex_num" ]]; then
    echo "Katalog $ex_num już istnieje!"
    sleep 1
    exit 1
fi

# skopiuj projekt bazowy
cp -r ./cw_3 "./$ex_num"

# zmień nazwy plików w nowym katalogu
mv "./$ex_num/cw_3.asmproj" "./$ex_num/$ex_num.asmproj"

echo "Projekt $ex_num został utworzony pomyślnie!"
