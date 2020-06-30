server:
	docker build . -t sinatra-demo
	docker run -p 80:4567 sinatra-demo

shell:
	docker build . -t sinatra-demo
	docker run -it sinatra-demo:latest /bin/sh