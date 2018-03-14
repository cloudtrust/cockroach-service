# cockroach-service
CockroachDB service.

docker build --build-arg cockroach_service_git_tag=initial --build-arg cockroach_release=https://binaries.cockroachdb.com/cockroach-v1.1.6.linux-amd64.tgz --build-arg config_git_tag=master --build-arg config_repo=https://github.com/cloudtrust/dev-config.git -t cloudtrust-cockroach -f cloudtrust-cockroach.dockerfile .

docker run --net=ct_bridge -it --rm --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name cockroach --hostname cockroach cloudtrust-cockroach

You need to enter the container and manually init a cluser. This work is usually done by Kubernetes
/opt/cockroach/cockroach init --insecure --host=cockroach

Create other nodes:
docker run --net=ct_bridge -it --rm --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name cockroach-2 --hostname cockroach-2 cloudtrust-cockroach
