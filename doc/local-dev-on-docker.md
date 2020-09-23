# Speeding Up Your Dockerized Development Workflow

## Problem Statement:

Development in Docker locally can be a big pain. It is slow. A developer is waiting a painful amount of time for the container to restart after every small code change.

## Solution:

What if there was a way to bind mounts to share your project directory with a running container so that you can reuse your dev Docker image more frequently in a painless manner? Continue reading to find out how!

### Place Your Project Directory Into Docker

Typically, your developement environment should be designed for fast iterations. However, with Docker, many believe you must create a complete Docker image when deploying your code in the dev environment. That's not needed.

Instead, you can share your code with a started container by using [bind mounts](https://docs.docker.com/storage/bind-mounts/) This'll prevent you from creating a new image on each code change.

When starting a new container using Docker CLI, here's how you mount a local "./source_dir":
  
   Docker CLI (two different options):
  
  > $ docker run -it -v "$(pwd)/source_dir:/app/target_dir" ubuntu bash
  
  > $ docker run -it --mount "type=bind,source=$(pwd)/source_dir,target=/app/target_dir" ubuntu bash
  
  ![mount bind](https://docs.docker.com/storage/images/types-of-mounts-bind.png)
  
To bind mount, you can provide it an absolute path to a host directory and direct where it should be mounted inside the container once you've coloned using **--mount.**

Further, to be more efficient, you may consider utilizing **docker-compose** and using **docker-compose.yml** files to configure the Docker container. The goal is to use bind mounts to share your project directory with a running container. This will allow you to reuse your development Docker image with every code iteration and a lot more frequently. The content of the local directory overwrites the content from the image when the container has started. All you need to do is build the image once with the required dependencies and OS requirements until either dependencies or OS versions have change (this can be done with a requirements.txt file too). Otherwise, there's no need to recreate a new image when you modify your code.

Here's an example of creating a new file in a common folder and by running docker-compose up it will exit the container. This can be done like this:

(A simple example of a docker-compose.yml file to mount a local directory)
    
    > Version: '3'
    
    > Services:
       
       > example
    
    > image: ubuntu
    
    > volumes:
    
      > - ./source_dir:/app/target_dir
      
    > command: touch /app/target_dir/hello
    
Thus, when building with Docker in your dev environment, you can see results right away by using bind mounts to share code between your local machine and the Docker container. This will ensure that you will no longer need to rebuild your Docker image in development for every small code change. This make iterating a lot faster and makes local developement experience better! 

