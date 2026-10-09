{{/* The chart name, honouring nameOverride. */}}
{{- define "horopter-flux.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The release-scoped name every resource takes. A parent chart renames everything by setting
fullnameOverride.
*/}}
{{- define "horopter-flux.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "horopter-flux.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "horopter-flux.labels" -}}
helm.sh/chart: {{ include "horopter-flux.chart" . }}
{{ include "horopter-flux.selectorLabels" . }}
app.kubernetes.io/version: {{ include "horopter-flux.versionLabel" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "horopter-flux.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horopter-flux.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "horopter-flux.tag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
The tag as a label value. A digest pin contains ":" and runs to 71 characters, and a label value
allows neither, so it is made label-safe rather than left to fail at apply.
*/}}
{{- define "horopter-flux.versionLabel" -}}
{{- include "horopter-flux.tag" . | replace ":" "_" | trunc 63 | trimSuffix "-" | trimSuffix "_" | trimSuffix "." }}
{{- end }}

{{- define "horopter-flux.image" -}}
{{- $tag := include "horopter-flux.tag" . }}
{{- if hasPrefix "sha256:" $tag }}
{{- printf "%s/horopter-flux@%s" .Values.image.registry $tag }}
{{- else }}
{{- printf "%s/horopter-flux:%s" .Values.image.registry $tag }}
{{- end }}
{{- end }}
