# Use the official Crystal image as the base image
FROM crystallang/crystal:latest

# Set the working directory in the container
WORKDIR /app

# Copy the Crystal application files into the container
COPY . .

# Install the dependencies
RUN shards install

# Compile the Crystal application
RUN crystal build src/training-todo-api.cr --release

# Expose port 3000, which is the default port for Kemal
EXPOSE 3000

# Define the command to run the application
CMD ["./training-todo-api"]
