#!/bin/bash
echo " ____            _     __  __      _        "
echo "|  _ \          | |   |  \/  |    | |       "
echo "| |_) | __ _ ___| |__ | \  / | ___| |_ __ _ "
echo "|  _ < / _\` / __| '_ \| |\/| |/ _ \ __/ _\` |"
echo "| |_) | (_| \__ \ | | | |  | |  __/ || (_| |"
echo "|____/ \__,_|___/_| |_|_|  |_|\___|\__\__,_|.v1.0"
echo "________Escrito_por_Juampa_Rodríguez________"
echo -e "\n[i] Iniciando la búsqueda de ficheros en Bing y Google..."
for ext in $(echo doc docx pdf xls xlsx);
do curl -s "http://www.bing.com/search?q=site:$1%20filetype:$ext&count=100" -A "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" | sed 's/<a href="/\nURL#/g' | sed 's/" h="ID=/\n/g' | grep -v "live.com/" | grep 'URL#' | cut -d "#" -f2 >> URLs_Bing.tmp;
curl -s "https://www.google.com/search?q=site:$1+filetype:$ext&num=100" -A "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" | sed 's/><a href="h/\nURL#h/g' | sed 's/" onmousedown="/\n/g' | grep -v google.com | grep $1 | sed 's/" data/\n/g' | grep http | grep "URL#" | cut -d "#" -f2 >> URLs_Google.tmp;
done;
TotalURLsBing=$(cat URLs_Bing.tmp | wc -l);
echo -e "[i] Se identificaron" $TotalURLsBing "ficheros en Bing...";
sleep 2
TotalURLsGoogle=$(cat URLs_Google.tmp | wc -l);
echo -e "[i] Se identificaron" $TotalURLsGoogle "ficheros en Google...";
sleep 2
mkdir Ficheros_$1; cd Ficheros_$1
cat ../URLs_*.tmp | sort | uniq > ../URLs_$1.txt
rm ../URLs_*.tmp
TotalURLs=$(cat ../URLs_$1.txt | wc -l);
echo "[+] Se cuenta con" $TotalURLs "ficheros únicos..."
sleep 1
echo "[-] Se procede con la descarga. Esto puede demorar unos minutos..."
for files in $(cat ../URLs_$1.txt);
do wget --no-check-certificate $files -U "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" 2>/dev/null;
Descargado=$(ls | wc -l);
echo "[+] Se ha descargado" $Descargado "de" $TotalURLs"...";
done
TotalDownloads=$(ls | wc -l)
sleep 1
echo "[!] Se analizarán los metadatos de" $TotalDownloads "ficheros..."
sleep 2
echo -e "\n Usuarios:"
echo "---------------"
exiftool * | grep Author | cut -d ':' -f2 | sed '/^ *$/d' | sed 's/^[[:space:]]*//' | sort | uniq
echo -e "\n Software:"
echo "---------------"
exiftool * | egrep "Producer|Creator Tool" | cut -d ":" -f2 | sed 's/^[[:space:]]*//' | sort | uniq
echo -e "\n Idioma:"
echo "---------------"
exiftool * | grep Language | cut -d ":" -f2 | sed 's/^[[:space:]]*//' | sort | uniq; echo ""
cd ..
