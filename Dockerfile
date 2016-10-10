FROM buildpack-deps:trusty
MAINTAINER Gonzalo Peci <pecigonzalo@outlook.com>

ARG VERSION
ENV VERSION ${VERSION}
ENV DEBIAN_FRONTEND noninteractive
ENV BUILD_LIST "build-essential clang"

RUN apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_LIST && \

# Install ruby-install
    wget -O ruby-install.tar.gz \
    https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz && \
    tar -xzvf ruby-install.tar.gz && \
    cd ruby-install-0.6.0/ && \
    make install && \

# Install chruby
    wget -O chruby.tar.gz \
    https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz && \
    tar -xzvf chruby.tar.gz && \
    cd chruby-0.3.9/ && \
    make install && \

# Compile ruby
    ruby-install -c -j4 --system "ruby-$VERSION" \
    -- --disable-install-rdoc CC=clang && \

# Image cleanup
    apt-get clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /ruby-install* \
    /chruby* \
    /usr/local/src/ruby*

COPY ./gemrc /root/.gemrc

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN echo '[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return' \
    >> /etc/profile.d/chruby.sh && \
    echo 'source /usr/local/share/chruby/chruby.sh' \
    >> /etc/profile.d/chruby.sh && \
    mkdir -p "$GEM_HOME" "$BUNDLE_BIN" && \
	  chmod 777 "$GEM_HOME" "$BUNDLE_BIN" && \
    gem install bundler

CMD ["irb"]
