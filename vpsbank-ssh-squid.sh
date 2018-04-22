#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 2.0.1" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irá:" ; echo ""
echo "● ติดตั้ง และ ตั้งค่าพร็อกซี ปลาหมึกไว้ที่ 80, 3128, 8080 e 8000" ; echo "
echo "● กำหนดค่า OpenSSH เพื่อเรียกใช้พอร์ต 22 กับ 143" กำหนดค่า Dropbear เพื่อเรียกใช้พอร์ต 110" ; tput sgr0
echo ""
echo "● ติดตั้ง ชุดของสคริปต์ เป็นคำสั่ง ระบบสำหรับการจัดการผู้ใช้ เย็ดเข้ " ; tput sgr0
echoecho ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte กดปุ่มใดก็ได้เพื่อดำเนินการต่อ..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Ao เมื่อใช้ 'VPS Manager 2.0' คุณยอมรับข้อกำหนดการใช้งานต่อไปนี้:"
echo ""
echo "1.คุณสามารถ:"ติดตั้งและใช้ 'VPS Manager 2.0' 
echo "2 บนเซิร์ฟเวอร์ของคุณบนเซิร์ฟเวอร์ของคุณ
echo "3 สร้างจัดการและนำออกผู้ใช้จำนวนไม่จำกัด จำนวนผ่านชุดสคริปต์นี้."
echo " 
echo "
echo "

echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "กดปุ่มใดก็ได้เพื่อดำเนินการต่อ..."" ; echo "" ; echo "" ; tput sgr0
echo "2.ห้ามดัดแปลง หรือ เอาไป ปรับเปลี่ยน แก้เป็นจุด เพื่อให้คุณมีลักษณะเหมือนนักพัฒนาสคริปต์:"
echo "3  คุณไม่สามารถ  แก้ไขแก้ไขแชร์หรือจัดแจกจ่ายใหม่ )"


echo ""
echo "3. คุณยอมรับไหม :"
echo "a. O valor pago por esse conjunto de scripts não inclui garantias ou suporte adicional,"
echo "porém o usuário poderá, de forma promocional e não obrigatória, por tempo limitado,"
echo "receber suporte e ajuda para solução de problemas desde que respeite os termos de uso."
echo "b. O usuário desse conjunto de scripts é o único resposável por qualquer tipo de implicação"
echo "ética ou legal causada pelo uso desse conjunto de scripts para qualquer tipo de finalidade."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. Você concorda que o desenvolvedor não se responsabilizará pelos:"
echo "a. Problemas causados pelo uso dos scripts distribuídos sem autorização."
echo "b. Problemas causados por conflitos entre este conjunto de scripts e scripts de outros desenvolvedores."
echo "c. Problemas causados por edições ou modificações do código do script sem autorização."
echo "d. Problemas do sistema causados por programas de terceiro ou modificações/experimentações do usuário."
echo "e. Problemas causados por modificações no sistema do servidor."
echo "f. Problemas causados pelo usuário não seguir as instruções da documentação do conjunto de scripts."
echo "g. Problemas ocorridos durante o uso dos scripts para obter lucro comercial."
echo "h. Problemas que possam ocorrer ao usar o conjunto de scripts em sistemas que não estão na lista de sistemas testados."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " Você não digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Uma base de dados de usuários ('usuarios.db') foi encontrada!"
	echo "Deseja mantê-la (preservando o limite de conexões simultâneas dos usuários)"
	echo "ou criar uma nova base de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Manter Base de Dados Atual"
	echo "[2] Criar uma Nova Base de Dados"
	echo "" ; tput sgr0
	read -p "Opção?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Deseja ativar a compressão SSH dropbear (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuração automática" ; echo "" ; tput sgr0
sleep 3
apt-get update -y
apt-get upgrade -y
rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda > /dev/null
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh > /dev/null
apt-get install squid3 bc screen nano unzip dos2unix wget -y
killall apache2
apt-get purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid3/" ]
then
	wget https://raw.githubusercontent.com/3955/user-bank/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/3955/user-bank/master/squid2.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
	wget https://raw.githubusercontent.com/3955/user-bank/master/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid3/payload.txt
	grep -v "^Port 143" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 143" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/3955/user-bank/master/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/3955/user-bank/master/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/3955/user-bank/master/criarusuario2.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/3955/user-bank/master/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/3955/user-bank/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/3955/user-bank/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/3955/user-bank/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/3955/user-bank/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/3955/user-bank/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/3955/user-bank/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/3955/user-bank/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid3" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://raw.githubusercontent.com/3955/user-bank/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/3955/user-bank/master/squid.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://raw.githubusercontent.com/3955/user-bank/master/payload.txt -O /etc/squid/payload.txt
	echo " " >> /etc/squid/payload.txt
	grep -v "^Port 143" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 143" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/3955/user-bank/master/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/3955/user-bank/master/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/3955/user-bank/master/criarusuario2.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/3955/user-bank/master/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/3955/user-bank/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/3955/user-bank/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/3955/user-bank/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/3955/user-bank/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/3955/user-bank/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/3955/user-bank/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/3955/user-bank/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid ติดตั้ง ให้ ใช้งาน ใน พอร์ต: 80, 3128, 8080 e 8000" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "SSH dropbear ใช้งาน ใน พอร์ต 22 e 143 e 110" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "สคริปต์ จัดการ สำหรับงาน ที่ ตั้ง  usuário instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "อ่าน เอกสาร เพื่อ หลีกเลี่ยง ปัญหา dúvidas e problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "เรียกดู คำสั่ง ใช้งาน ที่มี ของคุณ : ajuda" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "เสร็จแล้ว ไอ้เหี้ย ไอ้สัส เลว"
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1
