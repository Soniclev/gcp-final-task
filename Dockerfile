FROM python:3.10
WORKDIR /root/gcp-final-task
RUN apt update &&\
apt install screen locales -y &&\
echo "LC_ALL=en_US.UTF-8" >> /etc/environment &&\
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
echo "LANG=en_US.UTF-8" > /etc/locale.conf &&\
locale-gen en_US.UTF-8
ENV PYTHONPATH "/root/gcp-final-task/"
ENV PYTHONUTF8 1
ENV TZ=Europe/Minsk
ENV DATABASE=sqlite:///./sql_app.db
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN pip install poetry
COPY poetry.lock pyproject.toml ./
RUN poetry install
COPY . ./
CMD ["poetry", "run", "uvicorn", "src.main:app", "--host", "0.0.0.0"]
