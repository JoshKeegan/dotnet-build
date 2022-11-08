FROM mcr.microsoft.com/dotnet/sdk:7.0.100-bullseye-slim

RUN apt-get update && \
	apt-get install -y make && \
	# Clean up apt lists & temp dir to not bloat the layer
	rm -rf /var/lib/apt/lists/* /tmp/*
