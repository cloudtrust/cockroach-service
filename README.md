# cockroach-service
CockroachDB service.


docker build --build-arg cockroach_service_git_tag=initial --build-arg cockroach_release=https://binaries.cockroachdb.com/cockroach-v1.1.5.linux-amd64.tgz --build-arg config_git_tag=master --build-arg config_repo=https://github.com/cloudtrust/dev-config.git -t cloudtrust-cockroach-service -f cloudtrust-cockroach.dockerfile .

You need to enter the container and manually init a cluser. This work is usually done by Kubernetes
/opt/cockroach/cockroach init --insecure --host=<host>
