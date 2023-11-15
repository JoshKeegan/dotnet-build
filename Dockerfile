FROM mcr.microsoft.com/dotnet/sdk:8.0.100-bookworm-slim

RUN apt-get update && \
	apt-get install -y make && \
	# Clean up apt lists & temp dir to not bloat the layer
	rm -rf /var/lib/apt/lists/* /tmp/*
