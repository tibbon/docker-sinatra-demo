server:
	docker build . -t sinatra-demo
	docker run sinatra-demo

shell:
	docker build . -t sinatra-demo
	docker exec -it sinatra-demo /bin/bash