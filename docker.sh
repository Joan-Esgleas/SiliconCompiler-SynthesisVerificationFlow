#!/bin/bash

IMAGE_NAME="silicon-compiler-image"
CONTAINER_NAME="silicon-compiler-image-container"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_TAR="${SCRIPT_DIR}/.silicon-compiler-image.tar"

build() {
    docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}" || exit 1
    docker save -o "${IMAGE_TAR}" "${IMAGE_NAME}"
}

ensure_image() {
    docker image exists "${IMAGE_NAME}" 2>/dev/null && return 0

    if [ -f "${IMAGE_TAR}" ]; then
        docker load -i "${IMAGE_TAR}" || return 1
        return 0
    fi

    echo "Image '${IMAGE_NAME}' not found. Run './docker.sh build' first."
    return 1
}

init() {
    ensure_image || exit 1

    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
            docker exec -it "${CONTAINER_NAME}" /bin/bash
            return
        fi
        if docker start "${CONTAINER_NAME}" 2>/dev/null; then
            docker exec -it "${CONTAINER_NAME}" /bin/bash
            return
        fi
        docker rm -f "${CONTAINER_NAME}" 2>/dev/null
    fi

    docker run -it \
        --name "${CONTAINER_NAME}" \
        --hostname "${CONTAINER_NAME}" \
        -v "${SCRIPT_DIR}:/workspace:rw" \
        --net=host \
        --ipc=host \
        "${IMAGE_NAME}" \
        /bin/bash
}

delete() {
    docker stop "${CONTAINER_NAME}" 2>/dev/null
    docker rm "${CONTAINER_NAME}" 2>/dev/null
}

stop() {
    docker stop "${CONTAINER_NAME}"
}

shell() {
    docker exec -it "${CONTAINER_NAME}" /bin/bash
}

salloc_init() {
    local account="share-ie-idi"
    local nodes="1"
    local partition="CPUQ"
    local cpus="4"
    local mem="32G"
    local time="04:00:00"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a|--account)   account="$2";    shift 2 ;;
            -n|--nodes)     nodes="$2";      shift 2 ;;
            -p|--partition) partition="$2";  shift 2 ;;
            -c|--cpus)      cpus="$2";       shift 2 ;;
            -m|--mem)       mem="$2";        shift 2 ;;
            -t|--time)      time="$2";       shift 2 ;;
            *) echo "Unknown option: $1"; exit 1 ;;
        esac
    done

    salloc --account="${account}" \
           --nodes="${nodes}" \
           --partition="${partition}" \
           -c "${cpus}" \
           --mem="${mem}" \
           --time="${time}" \
           bash -c "cd ${SCRIPT_DIR} && ${SCRIPT_DIR}/docker.sh init"
}

reattach() {
    local jobid="$1"

    if [[ -z "$jobid" ]]; then
        local running_jobs
        running_jobs=$(squeue -u "$USER" -h -t RUNNING -o "%i %j %N %M" 2>/dev/null)

        if [[ -z "$running_jobs" ]]; then
            echo "No running SLURM jobs found. Use './docker.sh salloc' to start one."
            exit 1
        fi

        local job_count
        job_count=$(echo "$running_jobs" | wc -l)

        if [[ "$job_count" -eq 1 ]]; then
            jobid=$(echo "$running_jobs" | awk '{print $1}')
        else
            echo "Multiple running jobs found:"
            printf "  %-12s %-20s %-15s %-10s\n" "JOBID" "NAME" "NODE" "TIME"
            echo "$running_jobs" | while read -r line; do
                printf "  %-12s %-20s %-15s %-10s\n" $line
            done
            echo "Specify a job ID: ./docker.sh reattach <JOBID>"
            exit 1
        fi
    fi

    srun --jobid="$jobid" --pty bash -c "cd ${SCRIPT_DIR} && ${SCRIPT_DIR}/docker.sh init"
}

usage() {
    echo "Usage: $0 {build|init|salloc|reattach|delete|stop|shell}"
    echo ""
    echo "  build              Build and save the Docker image"
    echo "  init               Start or attach to the container"
    echo "  salloc [-a|-n|-p|-c|-m|-t]  Request a SLURM node and run init"
    echo "  reattach [JOBID]   Reattach to an existing SLURM job"
    echo "  delete             Stop and remove the container"
    echo "  stop               Stop the container"
    echo "  shell              Open a shell in the running container"
}

# Main script logic
case "$1" in
    build)
        build
        ;;
    init)
        init
        ;;
    salloc)
        shift
        salloc_init "$@"
        ;;
    reattach)
        shift
        reattach "$@"
        ;;
    delete)
        delete
        ;;
    stop)
        stop
        ;;
    shell)
        shell
        ;;
    *)
        usage
        exit 1
        ;;
esac
