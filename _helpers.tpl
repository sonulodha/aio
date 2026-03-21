{{/*
Expand the name of the chart.
*/}}
{{- define "eCapService.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eCapService.fullname" -}}
{{- if $.Values.fullname }}
{{- $.Values.fullname | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := $.Release.Name }}{{ $.Release.Name }}
{{- end }}
{{- end }}

{{/*
Specify the name of the namespace. This should only be used in the main kustomization.yaml and the thing
that actually creates the namespace.
*/}}
{{- define "eCapService.namespace" -}}
{{ $.Values.namespace | default (print $.Release.Name "-" .Values.env) }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eCapService.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eCapService.labels" -}}
helm.sh/chart: {{ include "eCapService.chart" . }}
{{ with (index $.Values "standard-labels") }}{{ toYaml . }}{{ end }}
{{ include "eCapService.selectorLabels" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
{{- /* app.kubernetes.io/managed-by: {{ $.Release.Service }} */}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eCapService.selectorLabels" -}}
app: {{ $.Release.Name }}
app.kubernetes.io/name: {{ $.Release.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
"Keep It The Same." Wherever possible, do not make resources different (incl. names) between dev, qa, prod.
However, in order to achieve that, we need to create objects in a unique *namespace*. Then, the namespace
suffix is what the nameSuffix would be.
*/}}
{{- define "eCapService.namespaceSuffix" -}}
-{{ $.Values.env }}
{{- end }}

{{/*
Infisical machine identity: dev/qa/uat/load (and any other non–stg/prod) use the non-prod ID;
stg and prod use the alternate ID.
*/}}
{{- define "eCapService.infisicalIdentityId" -}}
{{- if has .Values.env (list "stg" "prod") -}}
16f380c3-c602-46b6-8c04-000000000000
{{- else -}}
16f380c3-c602-46b6-8c04-47326274d9a7
{{- end -}}
{{- end }}

{{/*
K8s Secret names created by Infisical (must match volume mounts and InfisicalSecret managedSecretReference).
*/}}
{{- define "eCapService.infisicalManagedSecretNameAppsettings" -}}
{{- default (printf "%s-appsettings" $.Release.Name) .Values.secrets.infisical.appsettings.managedSecretName -}}
{{- end }}
{{- define "eCapService.infisicalManagedSecretNameEnv" -}}
{{- default (printf "%s-env" $.Release.Name) .Values.secrets.infisical.env.managedSecretName -}}
{{- end }}

