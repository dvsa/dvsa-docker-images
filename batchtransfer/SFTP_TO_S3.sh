#!/bin/bash

project_name="SFTP_TO_S3"
aws_cmd_retry_attempts="${AWS_CMD_RETRY_ATTEMPTS:-2}"
region="${REGION:-eu-west-1}"
squid="${SQUID:-proxy.mgmt.olcs.dvsacloud.uk}"
squid_port="${SQUID_PORT:-3128}"
squid_noproxy=${SQUID_NOPROXY:-}

sendzabbix=${SENDZABBIX:-0}
zabbixservertag="${ZABBIXSERVERTAG:-MGMT-MGMT-PRI-ZABBIX2-EC2}"
zabbixserverhostnameprefix="${ZABBIXSERVERHOSTNAMEPREFIX:-zabbix2}"
zabbixserverdomain="${ZABBIXSERVERDOMAIN:-mgmt.olcs.dev-dvsacloud.uk}"
zabbix_key="${ZABBIXKEY:-AWS_BATCH_JOB_ID}"

emailonsuccess="${EMAILONSUCCESS:-0}"
emailonfailure="${EMAILONFAILURE:-0}"
emailserver="${EMAILSERVER:-smtp.mgmt.olcs.dvsacloud.uk}"
emailserverport="${EMAILSERVERPORT:-25}"
emailuser="${EMAILUSER:-olcs-tss@bjss.com}"
emailfrom="${EMAILFROM:-}"

sftp_folder="${SFTP_FOLDER:-}"
sftp_endpoint_username="${SFTP_ENDPOINT_USERNAME:-}"
sftp_endpoint_hostname="${SFTP_ENDPOINT_HOSTNAME:-}"
sftp_endpoint_port="${SFTP_ENDPOINT_PORT:-22}"
sftp_private_ssh_key="${SFTP_PRIVATE_SSH_KEY:-}"
#FILE GLOB
sftp_file_regex="${SFTP_FILE_REGEX:-*.gz}"

#Uses JUMPHOST to transfer file - used if set to 1. You must set JUMPHOST variables as well. This option allows job to run on private subnet and transfer the file via jumphost.
sftp_use_jumphost="${SFTP_USE_JUMPHOST:-0}"
jumphost_endpoint_username="${JUMPHOST_ENDPOINT_USERNAME:-mftres}"
jumphost_endpoint_hostname="${JUMPHOST_ENDPOINT_HOSTNAME:-jumphost.mgmt.olcs.dvsacloud.uk}"
jumphost_endpoint_port="${JUMPHOST_ENDPOINT_PORT:-22}"
jumphost_private_ssh_key="${JUMPHOST_PRIVATE_SSH_KEY:-}"

s3_bucket="${S3_BUCKET:-}"
s3_bucket_path="${S3_BUCKET_PATH:-}"

export http_proxy="http://$squid:$squid_port"
export https_proxy="http://$squid:$squid_port"
export no_proxy="$squid_noproxy"

sftp_private_ssh_key_file=/tmp/.id_rsa
jumphost_private_ssh_key_file=/tmp/.id_rsa_jumphost
sftp_config_file=/tmp/sftp.config
#sftp_options="-vv"
sftp_options="${SFTP_OPTIONS:-}"
#This path is mounted by Batch Fargate
file_download_path="${FILE_DOWNLOAD_PATH:-/var/scratch}"
temp_file_download_path="${file_download_path}/temporary"

# Store SSH Keys and create SSH Config if going via jump host
echo "$sftp_private_ssh_key">$sftp_private_ssh_key_file && chmod 400 $sftp_private_ssh_key_file
echo "$jumphost_private_ssh_key">$jumphost_private_ssh_key_file && chmod 400 $jumphost_private_ssh_key_file


if [ "$sftp_use_jumphost" -ne 0 ]; then
	cat<<-EOF>$sftp_config_file
	ServerAliveInterval 15
	Host *
		GSSAPIAuthentication no
	Host jumphost 
		Hostname $jumphost_endpoint_hostname 
		IdentityFile $jumphost_private_ssh_key_file 
		Port $jumphost_endpoint_port 
		User $jumphost_endpoint_username 
		StrictHostKeyChecking no
	Host sftpserver
		Hostname $sftp_endpoint_hostname  
		ProxyJump jumphost 
		IdentityFile $sftp_private_ssh_key_file 
		Port $sftp_endpoint_port 
		User $sftp_endpoint_username 
		StrictHostKeyChecking no
	EOF
else
	cat<<-EOF>$sftp_config_file
	ServerAliveInterval 15
	Host *
		GSSAPIAuthentication no
	Host sftpserver
		Hostname $sftp_endpoint_hostname  
		IdentityFile $sftp_private_ssh_key_file  
		Port $sftp_endpoint_port 
		User $sftp_endpoint_username 
		StrictHostKeyChecking no
	EOF
fi

# Built in vars
#https://docs.aws.amazon.com/batch/latest/userguide/job_env_vars.html


#global variable to capture output
aws_cmd_output=
aws_cmd() {
  cmd=$1
  max_retries=$2
  sleep_between=$3

  aws_cmd_output=
  if [ -z "$max_retries" ]; then
    max_retries=10
  fi
  if [ -z "$sleep_between" ]; then
    sleep_between=5
  fi

  cmd_count=1
  while [ $cmd_count -le $max_retries ];
  do
    echo "Executing [$cmd_count] - [$cmd] .."
    aws_cmd_output=$(eval "$cmd" 2>&1)
    if [ $? -eq 0 ]; then
      echo "Command successful.."
      return 0
    else
      sleep $(($sleep_between * $cmd_count))
      cmd_count=$(($cmd_count + 1))
    fi
  done
  echo "Exhausted all retries [$cmd_count] - giving up.."
  # counter has reached max - fail.
  return 1
}

die() {
  msg="$1"
  exitcode="${2:-1}"
  
  if [ $exitcode -eq 0 ]; then
    #success
    zabbix_exitcode=1
  else
    zabbix_exitcode=0
  fi 
  echo "$msg"
  if [ "$sendzabbix" -ne 0 ]; then
    zabbix_sender  -z "$zabbixserverip" -s "$zabbixserverhostname" -o "$zabbix_exitcode" -k "$zabbix_key"
    echo "Zabbix alert sent."
  fi
  if [ "$emailonfailure" -ne 0  -a "$exitcode" -ne 0 ]; then
    echo "$msg"| mailx -s "[$AWS_BATCH_JQ_NAME] Failed to transfer File" -r "$emailfrom" -S smtp="$emailserver:$emailserverport" $emailuser
    sleep 20 && echo "Email sent."
  fi
  rm -f $sftp_private_ssh_key_file  $jumphost_private_ssh_key_file 2>/dev/null
  exit $exitcode 
}

echo "Starting Job [$project_name] - [$AWS_BATCH_JOB_ID] on [$AWS_BATCH_JQ_NAME] .."
rm -Rf $temp_file_download_path && mkdir -p $temp_file_download_path && cd $temp_file_download_path 

if [ "$sendzabbix" -ne 0 ]; then
  aws_cmd "aws ec2 describe-instances --region=eu-west-1 --filters Name=tag:Name,Values=${zabbixservertag}" "$aws_cmd_retry_attempts"
  if [ $? -ne 0 ]; then
    echo "Unable to get Zabbix server IP!"
    exit 2
  fi
  zabbixserverinstanceid=`echo $aws_cmd_output|jq -r '.Reservations[].Instances[].InstanceId'`
  zabbixserverip=`echo $aws_cmd_output|jq -r '.Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress'`
  zabbixserverhostname="${zabbixserverhostnameprefix}-${zabbixserverinstanceid}.${zabbixserverdomain}"
fi

echo "Now getting files using config file [$sftp_config_file].."
sftpgetoutput=$(sftp $sftp_options -F"$sftp_config_file" -b - "sftpserver:$sftp_folder" 2>&1 <<EOF
mget $sftp_file_regex
exit
EOF
)
sftp_rc=$?

echo "$sftpgetoutput"
if [ $sftp_rc -ne 0 ]; then
  if ! echo "$sftpgetoutput" | grep -q 'not found'; then
    die "Failed to SFTP to $sftp_endpoint_hostname!"
  fi
fi

ls $sftp_file_regex >/dev/null 2>&1

if [ $? -ne 0 ]; then
  #Did not find any files to transfer. We don't want to clear any alerts here.
  echo "No files to transfer for Job [$project_name] - [$AWS_BATCH_JOB_ID] on [$AWS_BATCH_JQ_NAME]. Exiting.." 
  exit 0
fi

for i in $sftp_file_regex
do
	echo "Now copying to S3.."
	aws_cmd "aws s3 cp $i \"s3://${s3_bucket}/${s3_bucket_path}/\" --region $region" "$aws_cmd_retry_attempts" || die "Unable to upload to S3! - ${aws_cmd_output}"
	echo "Now copying to S3 archive.."
	aws_cmd "aws s3 cp $i \"s3://${s3_bucket}/${s3_bucket_path}/archive/\" --region $region" "$aws_cmd_retry_attempts" || die "Unable to upload to S3 archive! - ${aws_cmd_output}"
	echo "Now removing files using config file [$sftp_config_file]..[`cat $sftp_config_file`]"
	sftp $sftp_options -F$sftp_config_file -b - sftpserver:$sftp_folder <<-EOF
	rm $i
	exit
	EOF
  	if [ $? -ne 0 ]; then
    		die "Failed to SFTP to $sftp_endpoint_hostname to remove file $i!"
  	fi
  	if [ "$emailonsuccess" -ne 0 ]; then
    		echo "File [$i] transferred successfully for [$project_name] - [$AWS_BATCH_JOB_ID] on [$AWS_BATCH_JQ_NAME]."| mailx -s "[$AWS_BATCH_JQ_NAME] File [$i] transferred successfully" -r "$emailfrom" -S smtp="$emailserver:$emailserverport" $emailuser 
    		sleep 20 && echo "Email sent."
  	fi
done

die "Job [$project_name] - [$AWS_BATCH_JOB_ID] on [$AWS_BATCH_JQ_NAME] completed successfully." "0"

