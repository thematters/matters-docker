FROM jupyter/all-spark-notebook

# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html
RUN conda install -y -c plotly plotly
RUN conda install -y -c anaconda sqlalchemy psycopg2

COPY example.ipynb /home/jovyan/
COPY README.md /home/jovyan/

