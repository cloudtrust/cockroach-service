# cockroach-service
CockroachDB service.


docker build --build-arg cockroach_service_git_tag=initial --build-arg cockroach_release=https://binaries.cockroachdb.com/cockroach-v1.1.5.linux-amd64.tgz --build-arg config_git_tag=master --build-arg config_repo=https://github.com/cloudtrust/dev-config.git -t cloudtrust-cockroach-service -f cloudtrust-cockroach.dockerfile .

docker create --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name cockroach-1 cloudtrust-cockroach-service