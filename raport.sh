#!/bin/bash

director_baza="users"

#Citim numele utilizatorului pentru care vom face raport
read -p "Introduceți numele de utilizator pentru raport: " username

#Salvam locul unde va fi creat raportul
director_user="$director_baza/$username"

#Verificam daca exista acest director al utilizatorului
if [ ! -d $director_user ]; then
    echo "Directorul home pentru utilizatorul $username nu există!"
    exit 1
fi

#Cream fisierul text al raportului in fisierul user-ului
raport_file="${director_user}/raport.txt"


numar_fisiere=$(find $director_user -type f | wc -l)
numar_directoare=$(find $director_user  -type d | wc -l)
dimensiune_totala=$(du -sh $director_user  | cut -f1)

#Afisam in fisierul .txt valorile anterior calculare
echo "Raport pentru utilizatorul $username" > $raport_file
echo "Număr de fișiere: $numar_fisiere" >> $raport_file
echo "Număr de directoare: $numar_directoare" >> $raport_file
echo "Dimensiunea totală a fișierelor: $dimensiune_totala" >> $raport_file

#Afisam un mesaj pentru ca utilizatorul sa stie unde a fost creat fisierul .txt
echo "Raportul a fost generat în $raport_file"

#Mutam utilizatorul in fisierul sau pentru a nu realiza comenzile in linie de comanda
cd $director_baza

cd $username

exec bash


