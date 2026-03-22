#!/bin/bash

inregistrare="lista.csv"
director_baza="users"

#fisierul in care se vor salva userii logati
useri_logati_file="useri_logati.txt"
#vectorul in care se vor salva userii logati
useri_logati=()

#subprogram care aduce userii din fisier in vector
din_fisier_in_vector()
{

    if [ -f "$useri_logati_file" ]; then
        readarray -t useri_logati < "$useri_logati_file"
    else
        useri_logati=()
    fi
}

#subprogram care trece userii din vector inapoi in fisier
din_vector_in_fisier()
{

    printf "%s\n" "${useri_logati[@]}" > "$useri_logati_file"
}



#functia de logare
function login()
{

read -p "Introduceti numele de utilizator: " username

#Verificam daca exista userul in lista.csv
        if ! grep -q "^.*,${username},.*$" $inregistrare; then

                echo "Utilizatorul $username nu exista!"
                return

        fi

#Transferam ce aveam in fisier anterior in vector
din_fisier_in_vector

#Cautam acum in vectorul incarcat cu nume daca userul este deja logat.
        if [[ " ${useri_logati[@]} " =~ " ${username} " ]]; then

                echo "Utilizatorul $username este deja autentificat!"
                return

        fi

#Salvam linia din fisierul .csv unde intalnim numele citit de la tastatura
utilizator_actual=$(grep "^.*,${username},.*$" $inregistrare)

#Extragem parola de pe coloana a 5-a a listei
parola_extrasa=$(echo $utilizator_actual | cut -d',' -f5)

#Salvam timpul la care ne aflam
current_time=$(date '+%Y-%m-%d %H:%M:%S')

#Definim un for care permite introducerea parolei de doar 3 ori
for (( i=1; i<=3; i++ ))
do

#Folosim aceeasi intrebare ca la inregistrare.sh, userul putand sa-si aleaga vizibilitatea parolei
        read -p "Doriti sa vedeti parola la tastare?(DA/NU): " arata_parola

         if [[ "$arata_parola" == "da" || "$arata_parola" == "DA" || "$arata_parola" == "Da" || "$arata_parola" == "dA" ]]; then

                 read -p "Introduceți parola: " password
        else

                read -s -p "Introduceți parola: " password
                echo

        fi

        if [ "$password" != "$parola_extrasa" ]; then

                echo "Parola gresita! Incercarea $i/3."

#Daca parolele s-au potrivit, putem sa afisat in lista.csv lastlogin

        else

                sed -i "/^.*,${username},.*$/s/[^,]*$/${current_time}/" $inregistrare
                echo "Parola corecta! Bine ai revenit $username!"
                echo

#echo ${PWD}
#cd $director_baza
#echo ${PWD}
#cd $username
#echo ${PWD}
#exec bash


#Adaugam numele userului logat in vector
useri_logati+=("$username")

#Pentru a salva chiar daca iesim din script, trecem numele si intr-un fisier text
            din_vector_in_fisier

#Pentru verificare afisam o lista cu userii actual logati
echo "Utilizatorii logati "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " ${useri_logati[@]}"


                 break

        fi

done

}

#Functia de logout
function logout
{
    read -p "Introduceți numele de utilizator: " username

#trecem din fisier iar in vector pentru a putea prelucra
    din_fisier_in_vector

#parcurgem tot vectorul si cautam numele citit
for i in "${!useri_logati[@]}"; do

        if [ "${useri_logati[$i]}" == "$username" ]; then

                 unset 'useri_logati[$i]'
                 din_vector_in_fisier
                 echo "Utilizatorul $username a fost deconectat."
                 echo
                 echo "Utilizatorii care au rămas logați"
                 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                 echo " ${useri_logati[@]}"
                 return
        fi

done

#Daca nu s-a gasit username-ul, nu s-a ajuns sa se dea return, inseamna ca user-ul nu era autentificat

echo "Utilizatorul $username nu este autentificat."
echo
echo "Utilizatorii care au rămas logați"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " ${useri_logati[@]}"
}

#Meniul principal care permite utilizatorului sa aleaga daca vrea sa se logeze, sa se delogheze sau sa renunte la actiune


while true; do

        read -p "Doriti login sau logout?(IN/OUT/X)" actiune

        if [[ "$actiune" == "IN" || "$actiune" == "in" || "$actiune" == "In" || "$actiune" == "iN" ]]; then

                login


        elif [[ "$actiune" == "X" || "$actiune" == "x" ]]; then

                break


        else
                logout


        fi

done
