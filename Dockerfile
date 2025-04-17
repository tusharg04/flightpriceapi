# Base image with Java
FROM openjdk:11-jdk-slim

# Install Python, wget, and other dependencies
RUN apt-get update && apt-get install -y python3 python3-pip wget curl unzip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip

# Set environment variables for Java and PySpark
ENV JAVA_HOME=/usr/local/openjdk-11
ENV PYSPARK_PYTHON=python3
ENV SPARK_VERSION=3.4.1
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/spark
ENV PATH="$SPARK_HOME/bin:$PATH"

# Install Apache Spark
RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Set working directory
WORKDIR /app

# Copy files to container
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000
EXPOSE 8000

# Run Flask app with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
