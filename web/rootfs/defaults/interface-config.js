{{ if .Env.APP_NAME -}}
interfaceConfig.APP_NAME = '{{ .Env.APP_NAME | js }}';
{{ end -}}
