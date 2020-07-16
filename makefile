AUTH_SERVICE_TEST:=authentication-service/docker-compose.auth-service.test.yml
COMPANY_SERVICE_TEST:=company-service/docker-compose.company-service.test.yml
MONITORING_SERVICE_TEST:=monitoring-service/docker-compose.monitoring.test.yml
NETWORKS_TEST:=networks/docker-compose.networks.test.yml
USER_SERVICE_TEST:=user-service/docker-compose.user-service.test.yml

AUTH_SERVICE_PROD=authentication-service/docker-compose.auth-service.yml
COMPANY_SERVICE_PROD:=company-service/docker-compose.company-service.yml
MONITORING_SERVICE_PROD:=monitoring-service/docker-compose.monitoring.yml
NETWORKS_PROD:=networks/docker-compose.networks.yml
USER_SERVICE_PROD:=user-service/docker-compose.user-service.yml

stop_test_env:
	docker-compose down

up_test_env:
	docker-compose -f $(MONITORING_SERVICE_TEST) -f $(AUTH_SERVICE_TEST) -f $(COMPANY_SERVICE_TEST) -f $(USER_SERVICE_TEST) -f $(NETWORKS_TEST) config
	docker-compose -f $(MONITORING_SERVICE_TEST) -f $(AUTH_SERVICE_TEST) -f $(COMPANY_SERVICE_TEST) -f $(USER_SERVICE_TEST) -f $(NETWORKS_TEST) up --remove-orphans
	
convert_prod:
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(NETWORKS_PROD) convert -o manifest.yaml && mv *.yaml ./kubernetes/test
	# && kubectl apply -f manifest.yaml
deploy:
	kubectl apply -f ./kubernetes/prod/manifest.yaml

deploy_prod:
	# kubectl proxy --port=8080 && export KUBERNETES_MASTER=http://127.0.0.1:8080
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(NETWORKS_PROD) up

down_prod:
	kompose -f $(AUTH_SERVICE_PROD) -f $(COMPANY_SERVICE_PROD) -f $(USER_SERVICE_PROD) -f $(NETWORKS_PROD) down
	
