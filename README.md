Steps to use:

- Checkout this repo
- Build the Dockerfile with a tag name: `docker build . -t sinatra-demo` Redo this when you make changes!
- Run the Dockerfile `docker run -p 80:4567 sinatra-demo`. 
- Browse to [localhost/hello-world](http://localhost:80/hello-world) 
- Alternately, shell into the container with `docker run -it sinatra-demo:latest /bin/bash`

Now imagine; you can use this on a machine that doesn't even have Ruby installed. OpenSSL problems? Gone. Same file will run in production just fine!

Try to remove lines from the Dockerfile and see what happens when you re-build and run!

### Makefile

Makefiles are cool too! This one's really simple but has two commands:

- `make server`
- `make shell`