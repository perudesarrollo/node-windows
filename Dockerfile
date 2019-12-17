FROM mcr.microsoft.com/windows/servercore:1803

WORKDIR /inetpub/wwwroot

COPY sources/ .

#COPY sources/node_modules/webworker-threads C:/Users/ContainerAdministrator/AppData/Roaming/npm/node_modules/webworker-threads

COPY /sources/package*.json ./

RUN powershell Add-WindowsFeature Web-Asp-Net45,Web-Http-Tracing,Web-Scripting-Tools,Web-WebSockets;

ADD https://nodejs.org/dist/v8.11.4/node-v8.11.4-x64.msi node-v8.11.4-x64.msi
RUN powershell Start-Process msiexec -ArgumentList '/i node-v8.11.4-x64.msi /qn /l*v nodejs.log' -Wait ;

ADD http://go.microsoft.com/fwlink/?LinkID=615137 rewrite_amd64.msi
RUN powershell Start-Process msiexec -ArgumentList '/i rewrite_amd64.msi /qn /l*v rewrite.log' -Wait ;

ADD https://github.com/tjanczuk/iisnode/releases/download/v0.2.21/iisnode-full-v0.2.21-x64.msi iisnode-full-v0.2.21-x64.msi
RUN powershell Start-Process msiexec -ArgumentList '/i iisnode-full-v0.2.21-x64.msi /qn /l*v iisnode.log' -Wait ;

RUN powershell npm install --global --production  npm
RUN powershell npm install --global --production  node-gyp
RUN powershell npm --vcc-build-tools-parameters='[""--allWorkloads""]' install --global --production windows-build-tools

ENV PATH 'C:\users\containeradministrator\.windows-build-tools\Python27;C:\Program Files (x86)\MSBuild\14.0\bin\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\nodejs\;C:\Users\ContainerAdministrator\AppData\Local\Microsoft\WindowsApps;C:\Users\ContainerAdministrator\AppData\Roaming\npm;'
ENV PYTHON '%USERPROFILE%\.windows-build-tools\Python27\python.exe'
ENV PYTHONPATH '%USERPROFILE%\.windows-build-tools\python27'
ENV VCTargetsPath "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\v140"
ENV NODE_PATH "C:\Users\ContainerAdministrator\AppData\Roaming\npm\node_modules"

#RUN powershell npm install express
#--global --production body-parser busboy cluster consolidate cookie-parser debug express express-fileupload favicon http logger math net path querystring url util jade bindings
EXPOSE 8080

ENTRYPOINT node.exe ./app.js