{{- if .Values.sshd.monitoring.enabled }}
#!/bin/bash
set -ex
## @usage :
##    bash install-prometheuse-exporter-active-ssh-users.sh
## or
##     bash install-prometheuse-exporter-active-ssh-users.sh offline
## $1 offline or not exist
###   if "offline": script will use proxy.
# cert CA
if [ "$1" = "offline" ]; then 
   export HTTP_PROXY=10.33.195.36:8082 HTTPS_PROXY=10.33.195.36:8082
else
   curl -O https://nexus.elm.sa/repository/packages/elm-cert.der && \
      openssl x509 -inform der -in elm-cert.der -out /etc/pki/ca-trust/source/anchors/elm-cert.crt && \
      cat /etc/pki/ca-trust/source/anchors/elm-cert.crt >> /etc/ssl/certs/ca-certificates.crt && \
      update-ca-trust
fi

#    download exporter
declare -r owner="stfsy"
declare -r name="prometheus-what-active-users-exporter"

declare -r latest_release_url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/${owner}/${name}/releases/latest)
declare -r latest_version=$(echo ${latest_release_url} | awk -F'/' '{print $8}')
declare -r latest_version_name=${name}-${latest_version}-linux-x64

declare -r shasum_url=https://github.com/${owner}/${name}/releases/download/${latest_version}/sha256sums.txt
declare -r binary_url=https://github.com/${owner}/${name}/releases/download/${latest_version}/${latest_version_name}

if [ ! -f ${latest_version_name} ]; then
   curl -L ${shasum_url} > shasums256.txt
   curl -L ${binary_url} > ${latest_version_name}

   declare -r hash_sum_line=$(cat shasums256.txt | grep ${latest_version_name})
   declare -r hash_sum=$(echo ${hash_sum_line} | awk -F' ' '{print $1}')

   echo "${hash_sum}  ${latest_version_name}" | sha256sum --check
   cp ${latest_version_name} ${name}
   rm shasums256.txt
fi

# install
chmod a+x ${name}
sudo mv ${name} /usr/local/bin/${name}
# validate
/usr/local/bin/${name} --help

# service
if [ ! -f /etc/systemd/system/${name}.service ]; then
   cat > /etc/systemd/system/${name}.service <<EOF
[Unit]
Description=${name}

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStart=/usr/local/bin/${name} --listen.host=0.0.0.0 --listen.port={{ .Values.sshd.monitoring.port }}
[Install]
WantedBy=multi-user.target
EOF

   systemctl daemon-reload
fi


systemctl restart ${name}
systemctl enable ${name}
systemctl status ${name}

{{- else }}
echo "WARNING - Enable SSH monitoring (sshd.monitoring.enabled=true) in order to get the script"

{{- end }}