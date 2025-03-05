# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Install required packages and create non-root user early
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -r apprunner && \
    useradd -r -g apprunner -s /sbin/nologin apprunner

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./app /app

# Set permissions and install dependencies
RUN chown -R apprunner:apprunner /app && \
    pip install --no-cache-dir -r requirements.txt

# Switch to non-root user
USER apprunner

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Run the application
CMD ["python", "app.py"]
