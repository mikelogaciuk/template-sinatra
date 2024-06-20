# Start from a base image with Ruby installed
FROM ruby:3.3.1

# Set the timezone to UTC
RUN dpkg-reconfigure -f noninteractive tzdata

# Install the necessary dependencies for Microsoft SQL Server
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev unixodbc odbcinst unixodbc-dev freetds-dev wget curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install krb5-user libgssapi-krb5-2

# Install MSSQL ODBC driver
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
CMD ["source", "~/.bashrc"]

RUN wget https://packages.microsoft.com/debian/11/prod/pool/main/m/msodbcsql18/msodbcsql18_18.3.2.1-1_amd64.deb
RUN ACCEPT_EULA=Y dpkg -i msodbcsql18_18.3.2.1-1_amd64.deb

# Prepare Kerberos Config
COPY config/krb5/krb5.conf /etc/

# Install bundler
RUN gem install bundler

# Set an environment variable to install the gems in /gems
ENV GEM_HOME=/gems
ENV BUNDLE_PATH=/gems

# Set an environment variable to enable YJIT
ENV RUBYOPT="--yjit"

# Create a directory for the app code
RUN mkdir /app

# Set the working directory to /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to /app
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the app code to /app
COPY . .

