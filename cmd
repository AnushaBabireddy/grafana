**Get repo:**

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl create ns monitoring-system

**Install prometheus:**

helm install prometheus prometheus-community/prometheus -n monitoring-system
helm delete prometheus prometheus-community/prometheus -n monitoring-system

Issue: connection refused:

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

*Issue: storageclass issue*

Change the default StorageClass | Kubernetes
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}
kubectl patch storageclass gold -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'


**Mark the default StorageClass as non-default:**
Before:
quest@TVMDT1590:~> kubectl get sc
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  3d22h
longhorn (default)     driver.longhorn.io      Delete          Immediate              true                   16h



kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl get sc

$$
After patch:

TVMDT1590:/home/quest # kubectl get sc
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
longhorn (default)   driver.longhorn.io      Delete          Immediate              true                   16h
local-path           rancher.io/local-path   Delete          WaitForFirstConsumer   false                  3d23h

$$

Tried to install Prometheus again, not it is working.

**Install Grafana:**

helm install grafana grafana/grafana
helm delete grafana grafana/grafana

kubectl get secret  --namespace monitoring-system grafana -o yaml

echo "**" | base64 -d

echo “password_value” | openssl base64 -d ; echo
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

**User and pwd:**

User: Admin
Pwd: VlTZ7bni1KdG4oRqmtxhHx3KUBdaRy6zfPa9gnLB

HA: fSTwup6UlylbSOb3fuikywDKFU2O5RrkH0SM7ncA


**Expose:**
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext -n monitoring-system
