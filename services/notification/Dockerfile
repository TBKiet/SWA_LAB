FROM node:18-alpine

WORKDIR /app

# Cài đặt PM2
RUN npm install pm2 -g

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Create logs directory
RUN mkdir -p logs

# Expose port
EXPOSE 3005

# Start với PM2
CMD ["pm2-runtime", "start", "src/index.js"] 