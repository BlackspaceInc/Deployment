AUTH_SERVICE:=authentication-service/docker-compose.auth-service.yml
COMPANY_SERVICE:=company-service/docker-compose.company-service.yml
MONITORING_SERVICE:=monitoring-service/docker-compose.monitoring.yml
NETWORKS:=networks/docker-compose.networks.yml
USER_SERVICE:=user-service/docker-compose.user-service.yml

stop:
	docker-compose down

up:
	docker-compose -f $(MONITORING_SERVICE) -f $(AUTH_SERVICE) -f $(COMPANY_SERVICE) -f $(USER_SERVICE) -f $(NETWORKS) config
	docker-compose -f $(MONITORING_SERVICE) -f $(AUTH_SERVICE) -f $(COMPANY_SERVICE) -f $(USER_SERVICE) -f $(NETWORKS) up --remove-orphans

