#by NePtYx
#Formulario de creacion
bash .banner
echo "Introduce el texto al que le quieres hacer llegar a la victima:"
read input
bash .banner
echo "Introduce el gmail al que quieras enviar el mensaje:"
read input1
bash .banner
echo "Introduce el gmail fake"
read input2
bash .banner
echo "Introduce el nombre de tu carpeta al que se le enviara el texto:"
read input3
bash .banner
echo "Ya esta listo tu gmail spoofing para ser enviado."
echo "Este se encuentra en la carpeta llamada $input3..."
#Procesos de la creacion
cd .rans
echo "$input" |& tee .banner
echo "$input1" |& tee .rec
echo "$input2" |& tee .msg
cd ..
cp .rans -r $input3
#Salida de ejecucion
bash .banner
echo "Deseas salir del programa?"
read input4
