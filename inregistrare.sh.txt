
#!/bin/bash

inregistrare="lista.csv"
director_baza="users"

#Subprogram validare parola ( parola considerata puternica daca contine o majuscula si un caracter special )
parola_slaba() {

         if [[ ! "$password" =~ [A-Z] ]]; then

            return 0  # Parola slaba

         elif [[ ! "$password" =~ [\!\@\#\$\%\^\&\*\(\)\_\+\{\}\|\:\<\>\?\~] ]]; then

                 return 0; #Parola slaba
         else

                return 1  # Parola puternica
         fi
}


#Completare prima linie a fisierului .csv
        if [ ! -f $inregistrare ]; then
                echo "ID,Nume,Mail,Telefon,Password,Director,LastLogin" >  $inregistrare

fi

#Citirea numelui de la tastatura si validarea acestuia in cazul in care nu a mai fost utilizat anterior
while true; do
        read -p "Introduceti numele de utilizator: " username

        if grep -q "^.*,${username},.*$" $inregistrare; then

                echo "Utilizatorul $username exista deja! Incercati alt nume!"

        else break

        fi

done

#Generarea id-ului unic pentru fiecare inregistrare, de forma: 1,2,3,4....
        if [ $(wc -l < $inregistrare ) -gt 1 ]; then
                last_id=$(tail -n 1 $inregistrare | cut -d',' -f1)
        else
                last_id=0
        fi

user_id=$((last_id + 1))

#Citirea mailului si validarea sa intr-o bucla infinita
while true; do
        read -p "Introduceti adresa de mail: (obligatoriu ...@gmail.com/yahoo.com): " mail

        if ! [[ "$mail" =~ ^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com)$ ]]; then

                echo "Adresa de email nu este valida. Trebuie să fie de forma ...@gmail.com/yahoo.com"

        else break

        fi

done

# Citirea numarului de telefon si validarea sa intr-o bucla infinita

while true; do
        read -p "Introduceti numarul de telefon: " telefon


        if ! [[ "$telefon" =~ ^07[0-9]{8}$ ]]; then

                echo "Numarul de telefon nu este valid. Trebuie sa fie de forma 07xxxxxxxx si sa contină 10 cifre."
         else break

        fi

done

#Intrebare adresata utilizatorului pentru afisarea parolei la tastare
read -p "Doriti sa vedeti parola la tastare?(DA/NU): " arata_parola

#In functie de raspuns, parola va fi afisata sau nu la tastare
while true; do

        if [[ "$arata_parola" == "da" || "$arata_parola" == "DA" || "$arata_parola" == "Da" || "$arata_parola" == "dA" ]]; then
                read -p "Introduceti parola: " password
                 read -p "Confirmati parola: " password2

        else
                 read -s -p "Introduceti parola: " password
                 echo
                 read -s -p "Confirmati parola: " password2
                 echo
        fi

#Validarea celor doua parole introduse
    if [ "$password" != "$password2" ]; then
        echo "Parolele nu se potrivesc! Incercati din nou."
        continue
    fi

    # Apelarea subprogramului care verifica complexitatea parolei
    if parola_slaba "$password"; then
        echo "Parola este prea slaba! Trebuie sa contina cel putin o litera mare si un caracter special(! # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ \  |  ~ ): "
        continue
    fi

    break  # Iesire din bucla daca parola este valida
done

#Crearea directorului personal al fiecarui user de forma "users/nume"
director_user="$director_baza/$username"
mkdir -p "$director_user"





echo "${user_id},${username},${mail},${telefon},${password},${director_user}," >> $inregistrare

echo "Inregistrare realizata cu succes!"


