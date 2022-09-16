-- Credits for https://stackoverflow.com/a/52484134/747579
{{- if .Values.auth.createLogin }}
USE [master]
GO
CREATE LOGIN [{{ .Values.auth.username }}] WITH PASSWORD=N'$(MSSQL_PASSWORD)'
GO
{{- end }}
{{- if .Values.auth.username }}
USE [master]
GO
CREATE USER [{{ .Values.auth.username }}] FOR LOGIN [{{ .Values.auth.username }}]
GO
{{- end }}

{{- if and .Values.auth.database .Values.auth.username }}
USE [{{ .Values.auth.database }}]
GO
CREATE USER [{{ .Values.auth.username }}] FOR LOGIN [{{ .Values.auth.username }}]
ALTER ROLE db_owner ADD MEMBER [{{ .Values.auth.username }}]
GO

{{- end }}
