## Preparation

1. Install Docker
2. Pull the image: `docker pull matterslab/analytics`
3. Create a local directory to store your notebooks `YOUR_WORK_DIRECTORY`
4. Prepare your AWS Access Key ID and Secret Access Key. They may look like `ABCDEFGHIJKLML` and `pq/wxyz1234wxyz1234wxyz1234`.

## Starting the notebook

Run in a console:
```bash
docker run --rm -p 8888:8888 -v YOUR_WORK_DIRECTORY:/home/jovyan/work  -e "AWS_ACCESS_KEY_ID=ABCDEFGHIJKLML" -e "AWS_SECRET_ACCESS_KEY=pq/wxyz1234wxyz1234wxyz1234" -t -i matterslab/analytics
```
Yes, the `/home/jovyan/work` path is fixed and just leave it as is. Replace `YOUR_WORK_DIRECTORY`, `ABCDEFGHIJKLML`, and `pq/wxyz1234wxyz1234wxyz1234` with your values.

Then go to http://localhost:8888

## Stopping

Press `Ctrl+C` in the console then `y`. This will stop the notebook server, the Spark session, and finally remove the container. Everything in the container will be lost, except for files in `YOUR_WORK_DIRECTORY`.

## Alternative of mananing jupyter container

To start an jupyter container, you could also use `shell/start-jupyter.sh` like this:
```
sh shell/start-jupyter.sh
```
And in this case, the container is running in daemon mode.
