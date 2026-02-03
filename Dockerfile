# Use the official Browsertrix Crawler image as the base
FROM webrecorder/browsertrix-crawler:latest

# ------------------------------------------------------------------
# Create the group and user
# ------------------------------------------------------------------
RUN useradd -u 1101 -g users -m -s /usr/sbin/nologin heritrix

# Switch to the new user for subsequent commands / runtime
USER heritrix
