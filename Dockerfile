# Base image with Java
FROM openjdk:11-jdk-slim

# Install Python, wget, and other tools
RUN apt-get update && apt-get install -y python3 python3-pip wget curl unzip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip

# Set environment variables
ENV JAVA_HOME=/usr/local/openjdk-11
ENV PYSPARK_PYTHON=python3
ENV SPARK_HOME=/spark
ENV PATH="${SPARK_HOME}/bin:${PATH}"

# Install Apache Spark 3.4.1 with Hadoop 3
RUN wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz && \
    tar -xzf spark-3.4.1-bin-hadoop3.tgz && \
    mv spark-3.4.1-bin-hadoop3 /spark && \
    rm spark-3.4.1-bin-hadoop3.tgz

# Set work directory
WORKDIR /app

# Copy app files
COPY . .

# Install Python requirements
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8000

# Run app using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
