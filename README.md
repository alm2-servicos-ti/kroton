# Teste Técnico - DevOps Engineer = KROTON/AMPLI

Escreva um terraform que crie a seguinte a seguinte infraestrutura: 
 
• Criar uma máquina Virtual, com um ip público 
• Expor os protocolos HTTP e HTTP/S  
• Instalar um servidor web NGINX 
• Garantir a execução do webserver 
• Testar a conexão com a porta 80 
• Criar um storage 
• Enviar o log do NGINX para o storage criado.  
 
Para este teste você pode usar o provider de sua preferência, a entrega pode ser feita via 
GitHub onde exista um readme com as instruções para replicar este ambiente. 
 
Prazo para entrega do teste: 48 horas

=======================================================================
# PRÉ-REQUISITOS:

* Conta em algum provedor de cloud (eg: AWS)
* Uma VM com acesso às portas 22 e 80
* Nginx
* AWS Cli para configurar as credenciais [.aws/config]

=======================================================================

# Instruções para acesso à VM:

* HOSTNAME: ec2-54-209-78-186.compute-1.amazonaws.com
* IPADDR: 54.209.78.186
* OS: AMAZON LINUX
* NGINX_SRV: ec2-54-209-78-186.compute-1.amazonaws.com:80
* S3_BUCKET: s3://alm2nginxlogs/WSNginxLogs/ [Acesso Público]
* OBJ GERADO NO BUCKET: https://alm2nginxlogs.s3.amazonaws.com/WSNginxLogs/i-02645525bf10dc7db/ngxlog_2021-08-04.tar.gz
* ssh-user: ec2-user [Se precisar acessar o console, favor solicitar o arquivo PEM]


=======================================================================

1- INSTALAR NGINX [REDHAT BASED]
$ sudo yum install nginx
$ sudo systemctl start nginx
$ curl ec2-54-209-78-186.compute-1.amazonaws.com [Teste de acesso à url na porta 80]
$ wget http://s3.amazonaws.com/ec2metadata/ec2-metadata => para coletar a id da instância (opcional se estiver usando AWS como provedor)

* Criar e executar o seguinte script para coletar os logs e enviá-los ao S3


#!/bin/bash
logdate=`date +'%Y-%m-%d'`
source=/var/log/nginx
shopt -s dotglob
sudo tar zcvf $source/ngxlog_$logdate.tar.gz $source/*.log
for file in "${source}"/*.gz
do
   if [ -f "${file}" ]; then
      instance_details=` /home/ec2-user/scripts/ec2-metadata -i`
      find_str="instance-id: "
      replace_str=""
      instance_id=${instance_details//$find_str/$replace_str}
      aws s3 cp $file s3://alm2nginxlogs/WSNginxLogs/$instance_id/
      rm -f $file
   fi
done


* Como opção, podemos adicionar o mesmo ao cron para agendamento de execução
