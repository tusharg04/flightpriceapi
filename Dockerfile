FROM openjdk:11-jdk-slim

# Install Python and dependencies
RUN apt-get update && apt-get install -y python3 python3-pip wget curl unzip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip

# Environment variables
ENV JAVA_HOME=/usr/local/openjdk-11 \
    PYSPARK_PYTHON=python3 \
    SPARK_HOME=/spark \
    PATH="/spark/bin:$PATH"

# Install Apache Spark
RUN wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz && \
    tar -xzf spark-3.4.1-bin-hadoop3.tgz && \
    mv spark-3.4.1-bin-hadoop3 /spark && \
    rm spark-3.4.1-bin-hadoop3.tgz

WORKDIR /app

# Copy app files
COPY . .

# Install requirements
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8000

# Run Flask app (simpler and safer with Spark)
CMD ["python3", "app.py"]
