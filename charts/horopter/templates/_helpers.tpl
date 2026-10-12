{{/* The chart name, honouring nameOverride. */}}
{{- define "horopter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The release-scoped base name every resource derives from. A parent chart renames everything
by setting fullnameOverride.
*/}}
{{- define "horopter.fullname" -}}
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

{{/*
A component's resource name: takes dict "ctx" . "component" "<ingress|egress|migrate>". The base
is cut to 55 before the suffix, so "-ingress" and "-migrate", the longest, still fit in 63, and
the suffix, which keeps the components apart, is never what gets cut.
*/}}
{{- define "horopter.componentName" -}}
{{- printf "%s-%s" (include "horopter.fullname" .ctx | trunc 55 | trimSuffix "-") .component }}
{{- end }}

{{- define "horopter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "horopter.labels" -}}
helm.sh/chart: {{ include "horopter.chart" . }}
app.kubernetes.io/name: {{ include "horopter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ include "horopter.versionLabel" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Takes dict "ctx" . "component" "<ingress|egress|migrate>". */}}
{{- define "horopter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horopter.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "horopter.tag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
The tag as a label value. A digest pin contains ":" and runs to 71 characters, and a label value
allows neither, so it is made label-safe rather than left to fail at apply.
*/}}
{{- define "horopter.versionLabel" -}}
{{- include "horopter.tag" . | replace ":" "_" | trunc 63 | trimSuffix "-" | trimSuffix "_" | trimSuffix "." }}
{{- end }}

{{/* Takes dict "ctx" . "name" "<ingress|egress|migrate>". */}}
{{- define "horopter.image" -}}
{{- $tag := include "horopter.tag" .ctx }}
{{- if hasPrefix "sha256:" $tag }}
{{- printf "%s/horopter-%s@%s" .ctx.Values.image.registry .name $tag }}
{{- else }}
{{- printf "%s/horopter-%s:%s" .ctx.Values.image.registry .name $tag }}
{{- end }}
{{- end }}

{{/*
Refuse to render below v0.2.0, the first tag with egress authentication. Only a semver tag is
judged: a digest or a tag like "edge" cannot be compared, and refusing what cannot be evaluated
would overreach. A release passes at >=0.2.0. A prerelease passes only when its core version is
strictly above 0.2.0: ">=0.2.0" alone refuses every prerelease, and ">=0.2.0-0" would admit
v0.2.0-rc.1, which sorts below the floor it is meant to enforce.
*/}}
{{- define "horopter.checkFloor" -}}
{{- $tag := include "horopter.tag" . }}
{{- if regexMatch "^v?[0-9]+\\.[0-9]+\\.[0-9]+" $tag }}
{{- $core := regexReplaceAll "^v?([0-9]+\\.[0-9]+\\.[0-9]+).*$" $tag "${1}" }}
{{- if not (or (semverCompare ">=0.2.0" $tag) (semverCompare ">0.2.0" $core)) }}
{{- fail "horopter: image.tag must be v0.2.0 or later — earlier tags predate egress authentication" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
OTEL_EXPORTER_OTLP_TRACES_ENDPOINT is used as-is: otlptracehttp appends /v1/traces only to the
general OTEL_EXPORTER_OTLP_ENDPOINT, and sends a per-signal URL with no path to "/", where a
collector answers 404. Tracing would look enabled and deliver nothing.
*/}}
{{- define "horopter.checkTracesEndpoint" -}}
{{- with .Values.telemetry.tracesEndpoint }}
{{- $path := (urlParse .).path }}
{{- if or (eq $path "") (eq $path "/") }}
{{- fail (printf "horopter: telemetry.tracesEndpoint must include the signal path, e.g. %s/v1/traces" (trimSuffix "/" .)) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "horopter.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- define "horopter.checkExposure" -}}
{{- range $name := list "ingress" "egress" }}
{{- $d := index $.Values $name }}
{{- if and $d.httpRoute.enabled $d.kubernetesIngress.enabled }}
{{- fail (printf "horopter: enable at most one of %s.httpRoute and %s.kubernetesIngress" $name $name) }}
{{- end }}
{{- end }}
{{- end }}
