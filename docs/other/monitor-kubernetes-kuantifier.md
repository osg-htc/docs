title: Monitor Kubernetes Workloads with Kuantifier
DateReviewed: 2024-02-07

Monitoring Kubernetes Workloads with Kuantifier
===============================================

Workload jobs run via Kubernetes will not integrate with [Gratia accounting](./troubleshooting-gratia/) by default.
To report contributions to OSG made via Kubernetes, install the [Kuantifier][kuantifier-github] helm chart
on your cluster.

Before Starting
---------------

### Confirm access to a running Kubernetes cluster

All subsequent instructions assume you have administrative access to a running Kubernetes cluster, and can run [kubectl][kubectl]
against that cluster.

### Install the Helm command line tools 

Kuantifier itself, and several of its prerequisites, are installed via [Helm chart](https://helm.sh/). The Helm
command line tools are used to install helm charts against a running kubernetes cluster, and can be installed
as follows:

1. Download the latest [release of Helm][helm-release].
1. Unpack the release blob (eg. `tar -zxvf helm-v3.0.0-linux-amd64.tar.gz`).
1. Move the `helm` binary from the archive into a location along your `$PATH` (eg. `mv linux-amd64/helm ~/.local/bin`).

### Install Prometheus and kube-state-metrics in your Kubernetes cluster

Kuantifier relies on [Prometheus][prometheus] with [kube-state-metrics][kube-state-metrics] to account for pod resource usage. 
There are a number of ways to install both, such as:

- Via the [prometheus community helm charts][prometheus-community].
- Via [OpenShift user-defined project monitoring][openshift-monitoring].


### Ensure that the namespace where your workload pods run is properly configured

1. Kuantifier relies on the `spec.containers[].resources.requests.cpu` field in workload pods
   to determine processor count for GRACC reporting. Ensure a CPU request is set for pods in
   your workspace.
 
1. Kuantifier relies on the Prometheus pod completion time metric to calculate workload job run times.
   This metric is sometimes missed for pods that are spontaneously deleted, such as those created by
   Deployments. For best results, run workload pods via Kubernetes Jobs.

1. (Known issue) Kuantifier currently doesn't support calculating usage metrics for workload pods
   running multiple containers. Ensure that workload pods in your namespace have only one container.

Installation
------------

Kuantifier itself is also installed via a Helm chart, hosted on [OSG Harbor](https://hub.opensciencegrid.org).


### Configuring Kuantifier's Values File

Several instance-specific modifications to the default [Values File][values-file] provided with the chart 
must be made prior to installation. For full documentation of the values in the values file, see the 
[Helm chart README on Github][helm-values-readme].

1. Fetch the default values.yaml for Kuantifier via the helm cli:

        :::console
        helm show values oci://hub.opensciencegrid.org/iris-hep/kuantifier

1. Update the top-level `.outputFormat` in values.yaml to output records to [GRACC](https://gracc.opensciencegrid.org/):
      
        :::yaml
        outputFormat: "gratia"

1. Update the `.processor.config` map with the details of your deployment.
    - All of the following need to be set:
        - `NAMESPACE`: The namespace of the pods for which Kuantifier will collect and report metrics.

            !!! note "Installation per Monitored Namespace"
                Each installation of kuantifier only reports on pods in a single namespace. You must
                install multiple instances of the chart to support reporting on multiple namespaces.

        - `SITE_NAME`: The name of the site being reported.
        - `SUBMIT_HOST`: Uniquely identifying name for the Kubernetes cluster where your workload pods run, in FQDN format.
        - `VO_NAME`: Virtual Organization (VO) of jobs.

    - Additionally, the following may need to be set:
        - `PROMETHEUS_SERVER`: The DNS name of the Prometheus server installed in your Kubernetes cluster. 
            - If Prometheus was installed in your cluster via the prometheus-community Helm chart in the monitoring
              namespace, the DNS name will be `prometheus-server.monitoring.svc.cluster.local` 
            - If Prometheus was installed via OpenShift, the DNS name for the cluster Prometheus instance can be discovered
              [via the `oc` command line tool][openshift-prometheus-url].
            - Otherwise, [construct](https://kubernetes.io/docs/concepts/services-networking/service/#dns) the URL based on the standard Kubernetes service discovery mechanism (i.e. service name and namespace).
    
    - A fully configured `.processor.config` might look like:

            :::yaml
            processor:
              config:
                NAMESPACE: workload-namespace
                SITE_NAME: CHTC
                VO_NAME: University of Wisconsin
                SUBMIT_HOST: tiger-cluster.chtc.wisc.edu
                PROMETHEUS_SERVER: prometheus-server.monitoring.svc.cluster.local

1. (Optional) If Prometheus in your cluster is configured to require authentication, an
   authentication header can be specified via a key within an already-existing [Service Account API Token][kubernetes-secret] in the namespace:

        :::yaml
        processor:
          prometheus_auth:
            secret: <service account secret name>
            key: token



    !!! note "Authentication"
           API Token-based authentication is required by default in OpenShift. Prometheus instances installed via the
           community helm charts are unauthenticated by default.

1. (Optional) Update the frequency of the Kuantifier Reporting job. This may be useful for debugging.

        :::yaml
        cronJob:
          schedule: "@daily"

### Installing Kuantifier

After configuring an appropriate values file for your instance, install the chart via helm:

    :::console
    helm install -f <values.yaml> -n <install namespace> kuantifier oci://hub.opensciencegrid.org/iris-hep/kuantifier

Validation
----------

After running `helm install`, ensure that the expected Kubernetes objects have been created. The following commands assume
that Kuantifier has been installed in the monitoring namespace.

1. Check that a CronJob was created for running the Kuantifier processor:

        :::console
        kubectl -n monitoring get cronjob kuantifier-cronjob

1. Check that a ConfigMap was created to configure processor jobs, and that the values in the ConfigMap
   align with the values set in `.processor.config` in the values file:

        :::console
        kubectl -n monitoring get configmap kuantifier-processor-config -o yaml


If the Helm chart artifacts are present as expected, run a test instance of the CronJob and inspect its output.

1. Create a new job from the CronJob, then find the Pod created by the job:

        :::console
        kubectl -n monitoring create job --from=cronjob/kuantifier-cronjob kuantifier-test-job
        kubectl -n monitoring get pod | grep kuantifier-test-job

1. Inspect the logs from the processor initContainer, which queries Prometheus to generate output records:

        :::console
        kubectl -n monitoring logs <test-job-pod-name> -c processor

1. Inspect the logs from the `gratia-output` container, which sends the output records to GRACC:

        :::console
        kubectl -n monitoring logs <test-job-pod-name> -c gratia-output

If both the processor initContainer and `gratia-output` container run to completion without error, the next step
is to confirm that contributions from your site appear on the [GRACC dashboard][gracc-dashboard].

Getting Help
------------

If you need help with configuring monitoring for your Kubernetes site, follow the [contact instructions](../common/help.md).

[helm-release]: https://github.com/helm/helm/releases
[kuantifier-github]: https://github.com/rptaylor/kapel/
[helm-values-readme]: https://github.com/rptaylor/kapel/blob/master/chart/README.md
[values-yaml]: https://github.com/rptaylor/kapel/blob/master/chart/values.yaml
[values-file]: https://helm.sh/docs/chart_template_guide/values_files/
[prometheus-community]: https://github.com/prometheus-community/helm-charts/tree/main
[kubectl]: https://kubernetes.io/docs/reference/kubectl/
[prometheus]: https://prometheus.io/
[gracc-dashboard]: https://gracc.opensciencegrid.org/d/000000079/site-summary?orgId=1
[openshift-monitoring]: https://docs.redhat.com/en/documentation/openshift_container_platform/4.12/html/monitoring/enabling-monitoring-for-user-defined-projects
[openshift-prometheus-url]: https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/monitoring/accessing-metrics#accessing-metrics-as-a-developer
[kube-state-metrics]: https://github.com/kubernetes/kube-state-metrics
[kubernetes-secret]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-a-long-lived-api-token-for-a-serviceaccount
