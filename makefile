AUTH_SERVICE_TEST:=authentication-service/docker-compose.auth-service.test.yml
COMPANY_SERVICE_TEST:=company-service/docker-compose.company-service.test.yml
MONITORING_SERVICE_TEST:=monitoring-service/docker-compose.monitoring.test.yml
NETWORKS_TEST:=networks/docker-compose.networks.test.yml
USER_SERVICE_TEST:=user-service/docker-compose.user-service.test.yml
FRONTEND_SERVICE_TEST:=frontend-service/docker-compose.frontend-service.yml

AUTH_SERVICE_PROD=authentication-service/docker-compose.auth-service.yml
COMPANY_SERVICE_PROD:=company-service/docker-compose.company-service.yml
MONITORING_SERVICE_PROD:=monitoring-service/docker-compose.monitoring.yml
NETWORKS_PROD:=networks/docker-compose.networks.yml
USER_SERVICE_PROD:=user-service/docker-compose.user-service.yml
FRONTEND_SERVICE_PROD:=frontend-service/docker-compose.frontend-service.yml

stop_test_env:
	@echo "stopping locally running containers"
	docker-compose down

up_test_env:
	@echo "starting containers via docker-compose locally"
	docker-compose -f $(MONITORING_SERVICE_TEST) -f $(AUTH_SERVICE_TEST) -f $(COMPANY_SERVICE_TEST) -f $(USER_SERVICE_TEST) -f $(NETWORKS_TEST) config
	docker-compose -f $(MONITORING_SERVICE_TEST) -f $(AUTH_SERVICE_TEST) -f $(COMPANY_SERVICE_TEST) -f $(USER_SERVICE_TEST) -f $(NETWORKS_TEST) up --remove-orphans
	
convert_to_kubernetes:
	@echo "creating manifest file from compose doc."
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(FRONTEND_SERVICE_PROD) -f $(NETWORKS_PROD) convert -o manifest.yaml && mv *.yaml ./kubernetes/test

deploy:
	# kubectl proxy --port=8080 && export KUBERNETES_MASTER=http://127.0.0.1:8080
	@echo "deploying production manifest file"
	# exporting the linkerd path to make it globally accessible
	export PATH=$PATH:$HOME/.linkerd2/bin
	# retrieves deployment running in the default namespace, runs the manifest through linkerd injectm and then reapplies to the cluster
	# annotations are added to the pod spec instructing linkerd to add ("inject") the proxy as a container to the pod sp`	``ec
	kubectl get -n default deploy -o yaml | linkerd inject - | kubectl apply -f ./kubernetes/prod/manifest.yaml
	# linkerd -n default check --proxy

monitor: deploy
	linkerd -n default stat deploy
	linkerd -n default top deploy

deploy_prod:
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(NETWORKS_PROD) up

down_prod:
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(NETWORKS_PROD) down

delete_all:
	kubectl delete --all pods --namespace=default
	kubectl delete --all deployments --namespace=default
	kubectl delete --all namespaces

linkerd-dashboard:
	@echo "viewing linkerd dashboard"

	
