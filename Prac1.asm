.model small                                            ;Modelo de memoria Small
.stack 64                                           
                                        
.data
        MsgDir  db ' 1. Manejo de Directorios '         ;Mensaje a escribir
        FinMsgDir label byte                            ;Etiqueta para calcular la longitud
        LongDir = offset FinMsgDir - offset MsgDir

        MsgFiche  db ' 2. Manejo de Ficheros    '         ;Mensaje a escribir
        FinMsgFiche label byte                            ;Etiqueta para calcular la longitud
        LongFiche = offset FinMsgFiche - offset MsgFiche

        MsgRes  db ' 3. Resumen Operaciones  '          ;Mensaje a escribir
        FinMsgRes label byte                            ;Etiqueta para calcular la longitud
        LongRes = offset FinMsgDir - offset MsgDir

        MsgPra  db ' 4. Informacion Programa  '         ;Mensaje a escribir
        FinMsgPra label byte                            ;Etiqueta para calcular la longitud
        LongPra = offset FinMsgPra - offset MsgPra

        MsgAutor db ' 5. Autor y Asignatura    '        ;Mensaje a escribir
        FinMsgAutor label byte                          ;Etiqueta para calcular la longitud
        LongAutor = offset FinMsgAutor - offset MsgAutor

        Msgfat  db ' 6. Informacion de la FAT '         ;Mensaje a escribir
        FinMsgfat label byte                            ;Etiqueta para calcular la longitud
        Longfat = offset FinMsgfat - offset Msgfat

        MsgFin  db ' 7. Salir                 '         ;Mensaje a escribir
        FinMsgFin label byte                            ;Etiqueta para calcular la longitud
        LongFin = offset FinMsgFin - offset MsgFin

        MsgEO  db '  YA EXISTE. ELIJA UNA OPCION  '    ;Mensaje a escribir
        FinMsgEO label byte                             ;Etiqueta para calcular la longitud
        LongEO = offset FinMsgEO - offset MsgEO

        MsgBD  db ' 1. Borrar Directorio     '          ;Mensaje a escribir
        FinMsgBD label byte                             ;Etiqueta para calcular la longitud
        LongBD = offset FinMsgBD - offset MsgBD

        MsgRD  db ' 2. Renombrar Directorio  '          ;Mensaje a escribir
        FinMsgRD label byte                             ;Etiqueta para calcular la longitud
        LongRD = offset FinMsgRD - offset MsgRD

        MsgBF  db ' 1. Borrar Fichero        '          ;Mensaje a escribir
        FinMsgBF label byte                             ;Etiqueta para calcular la longitud
        LongBF = offset FinMsgBF - offset MsgBF

        MsgRF  db ' 2. Renombrar Fichero     '          ;Mensaje a escribir
        FinMsgRF label byte                             ;Etiqueta para calcular la longitud
        LongRF = offset FinMsgRF - offset MsgRF

        MsgFin2  db ' 3. Volver                '        ;Mensaje a escribir
        FinMsgFin2 label byte                           ;Etiqueta para calcular la longitud
        LongFin2 = offset FinMsgFin2 - offset MsgFin2

        Msgpor  db ' Realizado por:  Jesus Octavio y Federico'     ;Mensaje a escribir
        FinMsgpor label byte                                                            ;Etiqueta para calcular la longitud
        Longpor = offset FinMsgpor - offset Msgpor

        Msgpri  db ' Practica Gestor de ficheros'         ;Mensaje a escribir
        FinMsgpri label byte                                            ;Etiqueta para calcular la longitud
        Longpri = offset FinMsgpri - offset Msgpri

        Msgiti  db ' Lenguajes y Automatas II '     ;Mensaje a escribir
        FinMsgiti label byte                            ;Etiqueta para calcular la longitud
        Longiti = offset FinMsgiti - offset Msgiti

        nuevopar label byte                   ; Lista de parametros del nombre:
        maxnlen db 80                         ;  * long max del nombre
        nuevolen db ?                         ;  * n� de caracteres introducidos
        nuevo db 81  DUP(' ')                 ;  * nuevo nombre del fichero

        viejopar label byte                   ; Lista de parametros del nombre:
        maxvlen db 80                         ;  * long max del nombre
        viejolen db ?                         ;  * n� de caracteres introducidos
        viejo db 81  DUP(' ')                 ;  * nombre original del fichero
        
        introf db 'Introduzca el nombre del fichero:  ','$'
        introd db 'Introduzca el nombre del directorio:  ','$'
        nombredos db 'Introduzca el directorio a renombrar:  ','$'
        cadenados db 'Introduzca el fichero a renombrar:  ','$'
        info db 'Como no se ha encontrado, se ha creado','$'
        msgErrorRename db 'Se produjo un error al renombrar','$'
        msgErrorBorra db 'Se produjo un error al borrar','$'
        msg1 db 'Este programa ha sido diseñado para el tratamiento de directorios y ficheros mediante el desarrollo de la FAT. ','$'
        msg2 db 'Permite realizar tres operaciones sobre los mismos: Crear, Borrar y Renombrar. ','$'
        msg3 db 'Primeramente solicita el directorio o fichero a crear,si no existe nos informar de que se ha creado con exito, y en caso contrario nos dar��a elegir dos opciones: ','$'
        msg4 db 'Borrarlo o Renombrarlo para volver al Menu principal.','$'
        msg5 db 'La tabla de asignacion de archios (FAT) se encarga de organizar y asignar el espacio en disco para los archivos. ','$'
        msg6 db 'Fisicamente, comienza despues del registro de arranque y contiene una entrada por archivo o directorio en disco. ','$'
        msg7 db 'Proporciona informacion acerca de ls ficheros que se encuentran en un medio de almacenamiento.','$'
        nfc  db 'No de Ficheros Creados __________ ','$'
        nfb  db 'No de Ficheros Borrados _________ ','$'
        nfr  db 'No de Ficheros Renombrados ______ ','$'
        ndc  db 'No de Directorios Creados _______ ','$'
        ndb  db 'No de Directorios Borrados ______ ','$'
        ndr  db 'No de Directorios Renombrados ___ ','$'

        ContCd db 0
        ContCf db 0
        ContBd db 0
        ContBf db 0
        ContRd db 0
        ContRf db 0
       
.code                                   ;Segmento de codigo

escribir MACRO texto                    ;Macro que usaremos para visualizar
       lea dx,texto                     ;cadenas de texto declaradas en el
       mov ah,09h                       ;segmento de datos
       int 21h
endm

cursor MACRO fila,columna
                                        ;Posicionamiento del cursor
        mov ah,2                        ;C�digo de funci�n
        mov dh,fila                     ;Fila y la columna
        mov dl,columna                  ;en la que queremos posicionarlo
        mov bh,0
        int 10h
endm

transformar MACRO variable
                                        ;Macro para generar el n� en ASCII
        mov dx,0                        ;del contador de operaciones hechas
        mov dl,variable                
        add dl,48
        mov ah,02h
        int 21h
endm

begin Proc far                          ;Procedimiento Begin
    
        mov ax,@data                    ;Valor del segmento para ".Data"
        mov ds,ax                       ;Paso al segmento de datos
        mov es,ax                       ;Se requiere por la func. 13h

     buclePpal:                         ;Etiqueta del bucle del menu principal

        call pintar
                                        ;Imprimir cadena Dir
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongDir                  ;Long. de la cadena Dir
        mov dh,3                        ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgDir            ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena Fiche
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongFiche                ;Long. de la cadena
        mov dh,6                        ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgFiche          ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena Resumen Op.
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongRes                  ;Long. de la cadena
        mov dh,9                        ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgRes            ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena Info. Practica
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongPra                  ;Long. de la cadena
        mov dh,12                       ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgPra            ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena Autor
        mov ah,13h
        mov al,0

        mov bh,0                        ;Pagina de video
        mov bl,17h                      ;Atributo

        mov cx,LongAutor                ;Cadena Autor
        mov dh,15                       ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgAutor          ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena FAT
        mov ah,13h
        mov al,0                        ;P�gina de video

        mov bh,0                        ;Atributo
        mov bl,17h

        mov cx,Longfat                  ;Cadena FAT
        mov dh,18                       ;Fila
        mov dl,30                       ;Columna
        mov bp,offset Msgfat            ;Desplazamiento de la cadena

        int 10h
                                        ;Imprimir cadena Fin
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongFin                  ;Long. de la cadena
        mov dh,21                       ;Fila
        mov dl,30                       ;Columna
        mov bp,offset MsgFin            ;Desplazamiento de la cadena

        int 10h

        call pausa

        cmp al,55                       ;Compara contenido AL con c�d. ASCII "7" (55)
        jz  Fin                         ;Salta a etiqueta Fin si el reg flag que
                                        ;almacena el resultado de la comparaci�n
                                        ;es 0, es decir si 7-7=0 y al=7

        cmp al,49                       ;Compara AL y "1"
        jz  Creadir                     ;Salta a la etiqueta bucledir
                                        ;si al y 49 son iguales                                        
        cmp al,50                       ;Compara AL y "2"
        jz CreaF                        ;Salto condicional etiqueta bucleFich

        cmp al,51                       ;Compara AL y "3"
        jz Resumen                      ;Salto a la etiqueta Resumen

        cmp al,52                       ;Compara AL y "4"
        jz Programa                     ;Salto condicional etiqueta Programa

        cmp al,53                       ;Compara AL y "5"
        jz Autor                        ;Salto a Autor

        cmp al,54                       ;Compara AL y "6"
        jz fat                          ;Salto condicional etiqueta FAT

        call pitido                     ;Pitido si no se pulsa 1,2,3,4,5,6
        
        jmp buclePpal                   ;Salto a la etiqueta buclePpal


    Autor:

        call limpiar
        call pintar
                                        ;Imprimir cadena "Realizado por..."
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,Longpor                  ;Long. de la cadena por
        mov dh,8                        ;Fila
        mov dl,9                        ;Columna
        mov bp,offset Msgpor            ;Desplazamiento de la cadena
        int 10h

                                        ;Imprimir cadena pri
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,Longpri                  ;Long. de la cadena
        mov dh,12                       ;Fila
        mov dl,20                       ;Columna
        mov bp,offset Msgpri            ;Desplazamiento de la cadena
        int 10h
                                        ;Imprimir cadena iti
        mov ah,13h                      ;C�digo de func.
        mov al,0                        ;Atributos de la cadena
                                        ;no actualizar el cursor
        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,Longiti                  ;Long. de la cadena
        mov dh,16
        mov dl,25
        mov bp,offset Msgiti            ;Desplazamiento de la cadena

        int 10h

        call pausa                      ;Leer una pulsaci�n
        call limpiar                    ;Borra la pantalla
        call pintar                     ;Dibuja el fondo

        jmp bucleppal                   ;Salto a la etiqueta buclePpal
        
   
     Bucledir:                          ;Etiqueta del bucle menu directorios

        call limpiar
        call pintar
                                        ;Imprimir cadena "Elige opci�n"
        mov ah,13h                      ;Cod funci�n
        mov al,0                        ;Atributo no actualizar cursor

        mov bh,0                        ;P�gina video
        mov bl,17h                      ;Atributo

        mov cx,LongEO                   ;Long Cadena
        mov dh,6                        ;Fila
        mov dl,27                       ;Columna
        mov bp,offset MsgEO             ;Desplazamiento cadena

        int 10h

                                        ;Imprimir cadena BD
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongBD
        mov dh,10
        mov dl,30
        mov bp,offset MsgBD

        int 10h
        
                                        ;Imprimir cadena RD
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongRD
        mov dh,14
        mov dl,30
        mov bp,offset MsgRD

        int 10h

                                        ;Imprimir cadena Volver
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongFin2
        mov dh,18
        mov dl,30
        mov bp,offset MsgFin2

        int 10h

        call pausa

        cmp al,51                       ;Comparaci�n "3"
        jz  buclePpal                   ;Salto condicional a etiqueta buclePpal

        cmp al,49                       ;Comparaci�n "1"
        jz  BorraDir

        cmp al,50                       ;Comparaci�n "2"
        jz  renamedir

        call pitido                     ;Pitido si no se pulsa 1,2,3

        jmp BucleDir                    ;Salto etiqueta bucle directorios


    Buclefich:                          ;Etiqueta Buclefich

        call limpiar
        call pintar
                                        ;Imprimir cadena "Elige una opci�n"
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongEO
        mov dh,6                        ;Fila
        mov dl,27                       ;Columna
        mov bp,offset MsgEO

        int 10h

                                        ;Imprimir cadena BF
        mov ah,13h
        mov al,0

        mov bh,0                        ;P�gina de v�deo
        mov bl,17h                      ;Atributo

        mov cx,LongBF
        mov dh,10
        mov dl,30
        mov bp,offset MsgBF

        int 10h


                                        ;Imprimir cadena RF
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongRF
        mov dh,14
        mov dl,30
        mov bp,offset MsgRF

        int 10h

                                        ;Imprimir cadena Volver
        mov ah,13h
        mov al,0

        mov bh,0
        mov bl,17h

        mov cx,LongFin2
        mov dh,18
        mov dl,30
        mov bp,offset MsgFin2

        int 10h

        call pausa

        cmp al,51                       ;Comparaci�n 3
        jz buclePpal

        cmp al,49                       ;Comparaci�n 1
        jz  BorraF

        cmp al,50                       ;Comparaci�n 2
        jz renamefich
                                         
        call pitido                     ;Pitido si no se pulsa 1,2, � 3

        jmp BucleFich


   Fin:                                 ;Etiqueta Fin
        
        cursor 24,0                     ;Situa cursor penultima fila

        mov ax,4C00h                    ;Retorno a MS-DOS
        int 21h


   CreaF:

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir introf         ;Muestra el mensaje "Introduzca el nombre"
        call introcadenav       ;Recoge la cadena introducida por teclado
        call delimitarv         ;delimita la cadena de entrada
        call limpiar

        cmp viejolen,00         ;si no se escribe ningun nombre
        je CreaDir              ;vuelve a la etiqueta creadir y repite
  
        mov ah,5Bh              ;Funci�n que crea un fichero
        lea dx,viejo            ;Almacena en dx el nombre del dir a crear
        int 21h
        jc buclefich            ;Si falla xq existe salta al menu directorios

        call limpiar            ;Limpia la pantalla
        escribir info           ;Confirma que se ha creado el fichero
        call pausa              ;Lee una pulsaci�n

        add ContCf,1            ;Incrementa el contador de ficheros creados
        
        jmp buclePpal           ;Salto a la etiqueta buclePpal


   BorraF:
                
        lea dx,viejo            ;viejo = nombre del fichero a borrar
        mov ah,41h              ;Funci�n de borrado de ficheros
        int 21h
                                ;Una operaci�n erronea pone a 1 el acarreo
        cmp ax,02               ;Y marca ax con el c�d. del error
        jz ErrorBorra           ;02=Archivo no encotrado

        add ContBf,1
        
        jmp buclePpal           ;Salto a la etiqueta buclePpal

        
   Renamefich:

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir cadenados      ;Muestra el mensaje "Intro fiche a renombrar:"
        call introcadenav       ;Recoge la cadena introducida por teclado
        call delimitarv         ;delimita la cadena de entrada
        call limpiar

        cmp viejolen,00         ;si no se escribe ningun nombre
        je Renamefich           ;vuelve a la etiqueta renamefich y repite

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir introf         ;Muestra el mensaje "Introduzca nuevo nombre"
        call introcadena        ;Recoge la cadena introducida por teclado
        call delimitar          ;delimita la cadena de entrada
        call limpiar

        cmp nuevolen,00         ;si no se escribe ningun nombre
        je Renamefich           ;salta y vuelve a pedir fiche a renombrar
        
        call renombra           ;Llama al procedimiento que renombra 

        add ContRf,1
        
        jmp buclePpal           ;Salto a la etiqueta buclePpal

           
   CreaDir:

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir introd         ;Muestra el mensaje "Introduzca el nombre"
        call introcadenav       ;Recoge la cadena introducida por teclado
        call delimitarv         ;delimita la cadena de entrada
        call limpiar

        cmp viejolen,00         ;si no se escribe ningun nombre
        je CreaDir              ;vuelve a la etiqueta creadir y repite
  
        mov ah,39h              ;Funci�n que crea un directorio
        lea dx,viejo            ;Almacena en dx el nombre del dir a crear
        int 21h
        jc bucledir             ;Si falla xq existe salta al menu directorios

        call limpiar
        escribir info
        call pausa

        add ContCd,1
        
        jmp buclePpal           ;Salto a la etiqueta buclePpal


   BorraDir:
                
        mov ah,3Ah              ;Funci�n que borra un directorio
        lea dx,viejo            ;Intro en dx el nombre del dir a borrar
        int 21h
                                ;Una operaci�n erronea pone a 1 el acarreo
        cmp ax,03               ;Y marca ax con el c�d. del error
        jz ErrorBorra           ;03=Ruta no encotrada

        add ContBd,1
        
        jmp buclePpal           ;Salto a la etiqueta buclePpal


   RenameDir:

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir nombredos      ;Muestra el mensaje "Intro dir a renombrar:"
        call introcadenav       ;Recoge la cadena introducida por teclado
        call delimitarv         ;delimita la cadena de entrada
        call limpiar

        cmp viejolen,00         ;si no se escribe ningun nombre
        je RenameDir            ;vuelve a la etiqueta creaf y repite

        call limpiar            ;Llama al procedimiento q limpia la pantalla
        cursor 0,0              ;Situa el cursor en la posicion (0,0)
        escribir introd         ;Muestra el mensaje "Introduzca nuevo nombre"
        call introcadena        ;Recoge la cadena introducida por teclado
        call delimitar          ;delimita la cadena de entrada
        call limpiar

        cmp nuevolen,00         ;si no se escribe ningun nombre
        je RenameDir            ;salta y vuelve a la etiqueta renamedir
        
        call renombra           ;Llama al procedimiento que renombra

        add ContRd,1

        jmp buclePpal           ;Salto a la etiqueta buclePpal

   ErrorBorra:

        call limpiar            
        escribir msgErrorBorra
        call pausa

        jmp buclePpal           ;Salto a la etiqueta buclePpal


   Resumen:

        call limpiar
        cursor 2,0
        escribir ndc
        cursor 2,35
        transformar ContCd

        cursor 4,0
        escribir ndb
        cursor 4,35
        transformar ContBd

        cursor 6,0
        escribir ndr
        cursor 6,35
        transformar ContRd

        cursor 8,0
        escribir nfc
        cursor 8,35
        transformar ContCf

        cursor 10,0
        escribir nfb
        cursor 10,35
        transformar ContBf

        cursor 12,0
        escribir nfr
        cursor 12,35
        transformar ContRf

        call pausa

        jmp bucleppal

   Programa:

        call limpiar
        escribir msg1
        escribir msg2
        escribir msg3
        escribir msg4
        call pausa
        jmp bucleppal

   fat:
        call limpiar
        escribir msg5
        escribir msg6
        escribir msg7
        call pausa
        jmp bucleppal

  begin endp                            ;Fin del programa principal

  pausa proc near

        mov ah,00h                      ;Leer pulsaci�n
        int 16h
        ret

  pausa endp

  pintar proc near

        cursor 0,0                      ;Situa cursor en (0,0)
                                        ;Llena las primeras 25 filas
        mov ah,9                        ;C�digo de funci�n
        mov al,177                      ;C�digo del caracter ASCII "�"
        mov bh,0                        ;P�gina de video
        mov bl,0Fh                      ;Atributo
        mov cx,25*80                    ;Las 25 filas
        int 10h

        ret

  pintar endp

  introcadena proc near

        mov ah,0Ah
        lea dx,nuevopar         ;recoge la cadena a renombrar, desde teclado
        int 21h
        ret

  introcadena endp
  
  introcadenav proc near

        mov ah,0Ah
        lea dx,viejopar         ;recoge cadena original desde teclado
        int 21h
        ret

  introcadenav endp
  
  delimitar proc near

        mov bh,00
        mov bl,nuevolen         ;Delimita cadena introducida a tama�o namelen
        mov nuevo[bx],00h       ;Termina cadena con 00h para poder renombrar 
        mov nuevo[bx+1],'$'     ;Pone delimitador de exhibici�n de caracteres
        ret

  delimitar endp
  
  delimitarv proc near

        mov bh,00
        mov bl,viejolen         ;Delimita cadena introducida a tama�o viejolen
        mov viejo[bx],00h       ;Termina cadena con 00h para poder renombrar 
        mov viejo[bx+1],'$'     ;Pone delimitador de exhibici�n de caracteres
        ret

  delimitarv endp
  
  limpiar proc near

        mov ax,0600h            ;Peticion de recorrido de pantalla
        mov bh,07               ;Color (07=Blanco y negro)
        mov cx,0000             ;De 00
        mov dx,184fh            ;a  25
        int 10h
        ret
 
  limpiar endp
  
  renombra proc near         

        mov ah,56h              ;Funci�n que renombra
        lea dx,viejo            ;Directorio o fiche a renombrar
        lea di,nuevo            ;Renombra el dir o fich con la nueva cadena
        int 21h                 ;introducida por teclado.
        jc ErrorRename
                     
        ret

  renombra endp

  ErrorRename proc near         ;Muestra mensaje de error cuando se la llama 
                                ;desde el procedimiento renombra
        call limpiar            
        escribir msgErrorRename
        call pausa

        ret

  ErrorRename endp

  Pitido proc near

        mov ah,0Eh              ;Sonido
        mov al,7
        mov bh,0
        int 10h
        ret

  Pitido endp

END begin
