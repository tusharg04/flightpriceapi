# Base image with Java and Python
FROM openjdk:11-jdk-slim

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip

# Set environment variables
ENV JAVA_HOME=/usr/local/openjdk-11
ENV PYSPARK_PYTHON=python3

# Set workdir
WORKDIR /app

# Copy files to container
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000
EXPOSE 8000

# Command to run the app with gunicorn (Flask app runs on port 5000 internally)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
