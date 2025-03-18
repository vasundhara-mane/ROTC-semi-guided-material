#!/usr/bin/env bash

set -eu -o pipefail

AVAILABLE_TOOLS=()

RED="\e[31m"
GREEN="\e[32m"
LIGHT_RED="\e[91m"
RESET="\e[0m"

info() {
	echo "[INFO]" "$@"
}

warn() {
	echo -e "${LIGHT_RED}[WARN]${RESET}" "$@" >&2
}

error() {
	echo -e "${RED}[ERROR]${RESET}" "$@" >&2
}

success() {
	echo -e "${GREEN}[INFO]${RESET}" "$@" >&2
}

error_if_docker_env_varialbe_is_set() {
	if [ -n "${DOCKER_HOST+x}" ]; then
		error "DOCKER_HOST is set! Likely in your ~/.bashrc or ~/.zshrc. This overrides any other config and interferes with docker context."
		error "DOCKER_HOST=${DOCKER_HOST:-}"
		error "Please remove and start a fresh shell before proceeding!"
		exit 1
	fi
}

check_colima_installed() {
	if type colima &>/dev/null; then
		AVAILABLE_TOOLS+=("colima")
	fi
}

check_colima_running() {
	if ! colima status &>/dev/null; then
		error "colima seems installed, but is not started. Call 'colima start'"
		exit 1
	fi

	if ! colima status 2>&1 | grep -q "kubernetes: enabled"; then
		error "colima is running, but kubernetes extenstion not started"
		error "call: colima kubernetes start"
		exit 1
	fi
}

check_minikube_installed() {
	if type minikube &>/dev/null; then
		AVAILABLE_TOOLS+=("minikube")
	fi
}

check_minikube_running() {
	if ! minikube status &>/dev/null; then
		error "minikube seems installed, but is not started. Call 'minikube start' or 'minikube status'"
		exit 1
	fi

	if grep DriverName ~/.minikube/machines/minikube/config.json | grep -i docker; then
		warn "Seems minikube is using docker driver - this could be colima or rancher-desktop!"
		warn "Ensure colima and rancher-desktop are stopped before minikube is started!"
	fi
}

show_minikube_docker_warning() {
	if ! is_minikube_docker_context_active; then
		warn "minikube has it's own appraoch to docker context!"
		warn "when directly calling docker, make sure to use 'minikube docker-env'"
	fi
}

error_if_minikube_docker_is_used() {
	if is_minikube_docker_context_active; then
		error "You are using the minikube docker-env!"
		error "Use a fresh shell and ensure 'eval \$(minikube -p minikube docker-env)' is not in your .bashrc/.zshrc"
		exit 1
	fi
}

is_minikube_docker_context_active() {
	[[ -n "${MINIKUBE_ACTIVE_DOCKERD+x}" ]]
}

check_rancher_desktop_installed() {
	if type rdctl &>/dev/null; then
		AVAILABLE_TOOLS+=("rancher-desktop")
	else
		if [ -d "/Applications/Rancher Desktop.app" ]; then
			warn "Found Rancher Desktop, but it not properly configured!"
			warn "Check 'Diagnostics' section in the 'Rancher Desktop' app!"
		fi
	fi
}

tool_available() {
	local tool="$1"

	[[ "${AVAILABLE_TOOLS[*]}" == *"${tool}"* ]]
}

current_docker_context() {
	docker context show
}

activate_docker_context() {
	local tool="$1"
	local current

	current=$(current_docker_context)

	if [ "${tool}" != "${current}" ]; then
		info "Switching docker context from ${current} to ${tool}"
		docker context use "${tool}"

		# check activation worked
		current=$(current_docker_context)
		if [ "${tool}" != "${current}" ]; then
			error "Failed to activate ${tool} docker context"
			exit 1
		fi
	else
		info "${tool} is already current docker context"
	fi
}

current_kubectl_context() {
	kubectl config current-context
}

activate_kubectl_context() {
	local tool="$1"
	local current

	current=$(current_kubectl_context)

	if [ "${tool}" != "${current}" ]; then
		info "Switching kubectl context from ${current} to ${tool}"
		kubectl config use-context "${tool}"

		# check activation worked
		current=$(current_kubectl_context)
		if [ "${tool}" != "${current}" ]; then
			error "Failed to activate ${tool} kubectl context"
			exit 1
		fi
	else
		info "${tool} is already current kubectl context"
	fi
}

if [ $# -eq 0 ]; then
	cat <<EOF
Please specicy the environment to activate:

- $0 rancher-desktop
- $0 colima
- $0 minikube

Make sure the tool is installed before activating it!
EOF

	exit 0
fi

check_colima_installed
check_minikube_installed
check_rancher_desktop_installed

TOOL="$1"

if ! tool_available "${TOOL}"; then
	joined=$(printf "\n[INFO] - %s" "${AVAILABLE_TOOLS[@]}")
	info "Tools available: ${joined}"
	error "$TOOL not found" 1>&2
	exit 1
fi

error_if_docker_env_varialbe_is_set

case "${TOOL}" in
colima)
	error_if_minikube_docker_is_used
	check_colima_running
	activate_docker_context colima
	activate_kubectl_context colima
	success "colima contexts are active!"
	;;
rancher-desktop)
	error_if_minikube_docker_is_used
	activate_docker_context rancher-desktop
	activate_kubectl_context rancher-desktop
	success "rancher-desktop contexts are active!"
	;;
minikube)
	check_minikube_running
	show_minikube_docker_warning
	activate_kubectl_context minikube
	success "minikube context is active!"
	;;
esac
