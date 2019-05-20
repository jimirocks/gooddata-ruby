FROM harbor.intgdc.com/tools/gdc-java-8-jre:d0f5e08

ARG GIT_COMMIT=unspecified
ARG BRICKS_VERSION=unspecified

LABEL image_name="GDC LCM Bricks"
LABEL maintainer="LCM <lcm@gooddata.com>"
LABEL git_repository_url="https://github.com/gooddata/gooddata-ruby/"
LABEL parent_image="harbor.intgdc.com/tools/gdc-java-8-jre:d0f5e08"
LABEL git_commit=$GIT_COMMIT
LABEL bricks_version=$BRICKS_VERSION

# which is required by RVM
RUN yum install -y curl which patch make git \
    && yum clean all \
    && rm -rf /var/cache/yum

# Switch to directory with sources
WORKDIR /src

RUN groupadd -g 48 apache && \
    useradd -r -u 48 -g apache apache && \
    mkhomedir_helper apache && \
    chown apache: /home && \
    chown apache: /src
USER 48

RUN gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

# login shell is required by rvm
RUN /bin/bash -l -c ". /home/apache/.rvm/scripts/rvm && rvm install jruby-9.2.5.0 && gem update --system \
    && gem install bundler rake"

ENV GOODDATA_RUBY_COMMIT=$GIT_COMMIT

ADD ./bin ./bin
ADD ./lib ./lib
ADD ./SDK_VERSION .
ADD ./VERSION .
ADD ./Gemfile .
ADD ./gooddata.gemspec .

RUN /bin/bash -l -c ". /home/apache/.rvm/scripts/rvm && bundle install"

CMD [ "./bin/help.sh" ]
