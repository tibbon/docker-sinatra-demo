server:
	docker build . -t sinatra-demo
	docker run -p 80:4567 sinatra-demo

shell:
	docker build . -t sinatra-demo
	docker exec -it sinatra-demo /bin/bash