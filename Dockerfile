FROM mcr.microsoft.com/dotnet/sdk:9.0.305-bookworm-slim

RUN apt-get update && \
	apt-get install -y make && \
	# Clean up apt lists & temp dir to not bloat the layer
	rm -rf /var/lib/apt/lists/* /tmp/*
