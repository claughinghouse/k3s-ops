Build the custom image for mkdocs

`docker build -t squidfunk/mkdocs-material .`

Run the local server

`docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material`
