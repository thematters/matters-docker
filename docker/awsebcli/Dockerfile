FROM mesosphere/aws-cli
RUN apk -v --update add py-pip git && pip install --upgrade awsebcli
ENTRYPOINT ["aws"]
